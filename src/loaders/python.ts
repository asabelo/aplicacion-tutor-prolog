import type { Loader } from "astro/loaders";
import { blanca, cargadorDeFicheros } from "./ficheros";

// La configuración sale de marcas en el propio .py, para que siga corriendo con
// `python fichero.py` desde su directorio:
//   # no ejecutable                  se muestra sin botón «Ejecutar»
//   nombre = <literal>  # parámetro  caja de texto; el literal da valor por defecto y tipo
//   from hermano import …            dependencia, si `hermano.py` está en el mismo sitio
// Las líneas marcadas no se muestran: el componente vuelve a pintar los parámetros.

const IDENT = String.raw`[\p{L}_][\p{L}\p{N}_]*`;
const NO_EJECUTABLE = new RegExp(String.raw`^#\s*no ejecutable\s*$`);
const PARÁMETRO = new RegExp(String.raw`^(${IDENT})\s*=\s*(.+?)\s*#\s*parámetro\s*$`, "u");
const IMPORTACIÓN = new RegExp(String.raw`^\s*(?:from\s+(${IDENT})\s+import\s|import\s+(${IDENT}))`, "u");

function valorPorDefecto(literal: string, id: string, nombre: string) {
    const cadena = literal.match(/^(['"])([\s\S]*)\1$/);
    if (cadena) return { tipo: "texto" as const, porDefecto: cadena[2] };

    if (/^-?\d+$/.test(literal)) return { tipo: "entero" as const, porDefecto: literal };

    throw Error(
        `El parámetro «${nombre}» de ${id} vale \`${literal}\`, que no es una cadena ` +
        `ni un entero literal. Solo se admiten esos dos tipos.`
    );
}

function analizar(id: string, fuente: string, hermanos: Set<string>) {
    const directorio = id.includes("/") ? id.slice(0, id.lastIndexOf("/")) : "";

    const parámetros: { nombre: string, tipo: "texto" | "entero", porDefecto: string }[] = [];
    const dependencias: string[] = [];
    const mostradas: string[] = [];

    let ejecutable = true;
    let reciénBorrada = false;

    for (const línea of fuente.split(/\r?\n/)) {
        if (NO_EJECUTABLE.test(línea)) {
            ejecutable = false;
            reciénBorrada = true;
            continue;
        }

        const parámetro = línea.match(PARÁMETRO);
        if (parámetro) {
            const [, nombre, literal] = parámetro;
            parámetros.push({ nombre, ...valorPorDefecto(literal, id, nombre) });
            reciénBorrada = true;
            continue;
        }

        const blancoSobrante = reciénBorrada && blanca(línea)
            && (mostradas.length === 0 || blanca(mostradas.at(-1)!));
        if (blancoSobrante) continue;
        reciénBorrada = false;

        const importación = línea.match(IMPORTACIÓN);
        if (importación) {
            const módulo = importación[1] ?? importación[2];
            const ruta = directorio ? `${directorio}/${módulo}` : módulo;
            if (hermanos.has(ruta) && !dependencias.includes(ruta)) dependencias.push(ruta);
        }

        mostradas.push(línea);
    }

    return {
        fuente,
        código: mostradas.join("\n").trim(),
        ejecutable,
        dependencias,
        parámetros
    };
}

export function python(base: string): Loader {
    return cargadorDeFicheros("python", ".py", base, analizar);
}
