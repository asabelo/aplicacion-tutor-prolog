import { TAU_DEST, TAU_MÓDULOS } from "../../runtimes.config.mjs";

const PASOS_POR_TANDA = 20_000;
const TIEMPO_ANTES_DE_PAUSAR = 5_000;

// Tau no autocarga las librerías y SWI-Prolog sí. `format` necesita además `charsio`, que
// es de donde saca `write_term_to_chars/3`.
const PRELUDIO = TAU_MÓDULOS
    .filter(módulo => módulo !== "core")
    .map(módulo => `:- use_module(library(${módulo})).`)
    .join("\n");

let motor: Promise<Tau.Pl> | null = null;

function cargarGuión(url: string) {
    return new Promise<void>((cumplir, romper) => {
        const guión = document.createElement("script");
        guión.src = url;
        guión.addEventListener("load", () => cumplir());
        guión.addEventListener("error", () => romper(Error(`No se ha podido cargar ${url}`)));
        document.head.append(guión);
    });
}

async function cargarMotor() {
    const base = `${import.meta.env.BASE_URL.replace(/\/?$/, "/")}${TAU_DEST}/`;
    // De uno en uno: `core` define `window.pl` y los demás se registran sobre él
    for (const guión of TAU_MÓDULOS) await cargarGuión(`${base}${guión}.js`);

    if (!window.pl) throw Error("Tau Prolog se ha cargado pero no ha dejado nada en window.pl");
    return window.pl;
}

export type Resultado =
    | { tipo: "solución", texto: string, sinAlternativas: boolean }
    | { tipo: "sinMás" }
    | { tipo: "error", texto: string }
    | { tipo: "pausa" };

export interface Consulta {
    siguiente(): Promise<Resultado>
}

// Se sustituye el objeto de dentro del flujo, no el flujo: ver src/tau-prolog.d.ts
function capturarSalida(sesión: Tau.Session, escribir: (texto: string) => void) {
    sesión.streams["user_output"].stream = {
        put: texto => { escribir(texto); return true; },
        flush: () => true
    };
}

export async function abrirConsulta(
    programas: string[],
    objetivo: string,
    escribir: (texto: string) => void
): Promise<Consulta> {

    const pl = await (motor ??= cargarMotor());
    const sesión = pl.create(PASOS_POR_TANDA);

    capturarSalida(sesión, escribir);

    for (const programa of [PRELUDIO, ...programas]) await consultar(sesión, programa);
    await preguntar(sesión, objetivo);

    return { siguiente: () => responder(sesión) };
}

function consultar(sesión: Tau.Session, programa: string) {
    return new Promise<void>((cumplir, romper) => sesión.consult(programa, {
        success: () => cumplir(),
        error: error => romper(Error(sesión.format_answer(error)))
    }));
}

function preguntar(sesión: Tau.Session, objetivo: string) {
    return new Promise<void>((cumplir, romper) => sesión.query(objetivo, {
        success: () => cumplir(),
        error: error => romper(Error(sesión.format_answer(error)))
    }));
}

function responder(sesión: Tau.Session): Promise<Resultado> {
    const desde = Date.now();

    return new Promise(cumplir => {
        const tanda = () => sesión.answer({
            // Sin puntos de elección no queda nada que explorar y pedir otra solución daría
            // `false.` seguro. Al revés no vale: un punto pendiente puede resultar estéril.
            success: respuesta => cumplir({
                tipo: "solución",
                texto: sesión.format_answer(respuesta),
                sinAlternativas: sesión.thread.points.length === 0
            }),
            fail: () => cumplir({ tipo: "sinMás" }),
            error: error => cumplir({ tipo: "error", texto: sesión.format_answer(error) }),
            limit: () => Date.now() - desde < TIEMPO_ANTES_DE_PAUSAR ? tanda() : cumplir({ tipo: "pausa" })
        });

        tanda();
    });
}
