import type { Loader } from "astro/loaders";
import { blanca, cargadorDeFicheros } from "./ficheros";
import { comoPalabra, HUECO_LIBRE, REGEX_DEPENDENCIA_PROLOG } from "../util/prolog/huecos";

// La configuración sale de marcas en comentarios, para que el .pl siga siendo cargable
// en SWI-Prolog:
//   % consulta: <objetivo>.        objetivo que se ejecuta
//   % consulta libre               el objetivo lo escribe entero el usuario
//   % parámetro Nombre = <valor>   hueco con su valor por defecto, que puede ir vacío
//   :- ensure_loaded(hermano).     dependencia de un hermano del mismo directorio
// No hay marca «no ejecutable»: sin consulta no hay nada que ejecutar.

const VARIABLE = String.raw`[\p{Lu}_][\p{L}\p{N}_]*`;
const ÁTOMO = String.raw`[a-z][A-Za-z0-9_]*`;

const CONSULTA = new RegExp(String.raw`^%\s*consulta:\s*(.+?)\s*$`, "u");
const CONSULTA_LIBRE = new RegExp(String.raw`^%\s*consulta libre\s*$`, "u");
const PARÁMETRO = new RegExp(String.raw`^%\s*parámetro\s+(${VARIABLE})\s*=\s*(.*?)\s*$`, "u");

export type Tipo = "átomo" | "término";

export interface Parámetro {
    nombre: string,
    tipo: Tipo,
    porDefecto: string,
    en: "código" | "consulta"
}

function valorPorDefecto(literal: string): { tipo: Tipo, porDefecto: string } {
    const entrecomillado = literal.match(/^'([\s\S]*)'$/);
    if (entrecomillado) return { tipo: "átomo", porDefecto: entrecomillado[1].replaceAll("''", "'") };

    if (new RegExp(String.raw`^${ÁTOMO}$`).test(literal)) return { tipo: "átomo", porDefecto: literal };

    return { tipo: "término", porDefecto: literal };
}

function aparicionesComoPalabra(texto: string, nombre: string) {
    return texto.match(comoPalabra(nombre, "gu"))?.length ?? 0;
}

function analizar(id: string, fuente: string, hermanos: Set<string>) {
    const directorio = id.includes("/") ? id.slice(0, id.lastIndexOf("/")) : "";

    const declarados: { nombre: string, tipo: Tipo, porDefecto: string }[] = [];
    const dependencias: string[] = [];
    const mostradas: string[] = [];

    let consulta: string | null = null;
    let consultaLibre = false;
    let reciénBorrada = false;

    for (const línea of fuente.split(/\r?\n/)) {

        const objetivo = línea.match(CONSULTA);
        if (objetivo) {
            if (consulta !== null || consultaLibre) throw Error(`${id} declara más de una consulta.`);
            consulta = objetivo[1].endsWith(".") ? objetivo[1] : `${objetivo[1]}.`;
            reciénBorrada = true;
            continue;
        }

        if (CONSULTA_LIBRE.test(línea)) {
            if (consulta !== null) throw Error(`${id} declara más de una consulta.`);
            consultaLibre = true;
            reciénBorrada = true;
            continue;
        }

        const parámetro = línea.match(PARÁMETRO);
        if (parámetro) {
            const [, nombre, literal] = parámetro;
            if (declarados.some(p => p.nombre === nombre)) {
                throw Error(`${id} declara dos veces el parámetro «${nombre}».`);
            }
            declarados.push({ nombre, ...valorPorDefecto(literal) });
            reciénBorrada = true;
            continue;
        }

        const blancoSobrante = reciénBorrada && blanca(línea)
            && (mostradas.length === 0 || blanca(mostradas.at(-1)!));
        if (blancoSobrante) continue;
        reciénBorrada = false;

        const dependencia = línea.match(REGEX_DEPENDENCIA_PROLOG);
        if (dependencia) {
            const ruta = directorio ? `${directorio}/${dependencia[1]}` : dependencia[1];
            if (!hermanos.has(ruta)) {
                throw Error(`${id} carga «${dependencia[1]}», que no existe en su mismo directorio.`);
            }
            if (!dependencias.includes(ruta)) dependencias.push(ruta);
        }

        mostradas.push(línea);
    }

    const código = mostradas.join("\n").trim();
    const programa = mostradas.filter(l => !REGEX_DEPENDENCIA_PROLOG.test(l)).join("\n").trim();

    const parámetros: Parámetro[] = declarados.map(p => {
        const enCódigo = aparicionesComoPalabra(código, p.nombre);
        const enConsulta = aparicionesComoPalabra(consulta ?? "", p.nombre);
        const total = enCódigo + enConsulta;

        if (total !== 1) throw Error(
            `El parámetro «${p.nombre}» de ${id} aparece ${total} veces entre el programa y ` +
            `la consulta, y tiene que aparecer exactamente una.`
        );

        return { ...p, en: enConsulta === 1 ? "consulta" : "código" };
    });

    if (consultaLibre) {
        if (parámetros.length > 0) {
            throw Error(`${id} tiene consulta libre y parámetros; el objetivo ya lo escribe entero el usuario.`);
        }
        consulta = HUECO_LIBRE;
        parámetros.push({ nombre: HUECO_LIBRE, tipo: "término", porDefecto: "", en: "consulta" });
    }

    return {
        fuente,
        código,
        programa,
        consulta,
        ejecutable: consulta !== null,
        dependencias,
        parámetros
    };
}

export function prolog(base: string): Loader {
    return cargadorDeFicheros("prolog", ".pl", base, analizar);
}
