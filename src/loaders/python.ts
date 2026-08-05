import type { Loader } from "astro/loaders";
import { readdir, readFile } from "node:fs/promises";
import { fileURLToPath } from "node:url";
import { join } from "node:path";

const IDENT = String.raw`[\p{L}_][\p{L}\p{N}_]*`;
const NO_EJECUTABLE = new RegExp(String.raw`^#\s*no ejecutable\s*$`);
const PARÁMETRO = new RegExp(String.raw`^(${IDENT})\s*=\s*(.+?)\s*#\s*parámetro\s*$`, "u");
const IMPORTACIÓN = new RegExp(String.raw`^\s*(?:from\s+(${IDENT})\s+import\s|import\s+(${IDENT}))`, "u");

function valorPorDefecto(literal: string, id: string, nombre: string) {
    const cadena = literal.match(/^(['"])([\s\S]*)\1$/);
    if (cadena) return { tipo: "texto" as const, porDefecto: cadena[2] };

    if (/^-?\d+(?:\.\d+)?$/.test(literal)) return { tipo: "número" as const, porDefecto: literal };

    throw Error(
        `El parámetro «${nombre}» de ${id} vale \`${literal}\`, que no es una cadena ` +
        `ni un número literal. Solo se admiten esos dos tipos.`
    );
}

function analizar(id: string, fuente: string, hermanos: Set<string>) {
    const directorio = id.includes("/") ? id.slice(0, id.lastIndexOf("/")) : "";

    const parámetros: { nombre: string, tipo: "texto" | "número", porDefecto: string }[] = [];
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

        // También se borran las líneas en blanco pegadas a lo que acabamos de borrar
        const enBlanco = línea.trim() === "";
        if (reciénBorrada && enBlanco && (mostradas.length === 0 || mostradas.at(-1)!.trim() === "")) {
            continue;
        }
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
    return {
        name: "python",

        load: async ({ store, parseData, generateDigest, watcher, logger, config }) => {
            const raíz = fileURLToPath(new URL(base, config.root));

            const cargar = async () => {
                const nombres = (await readdir(raíz, { recursive: true }))
                    .map(n => n.replaceAll("\\", "/"))
                    .filter(n => n.endsWith(".py"));

                const ids = nombres.map(n => n.slice(0, -".py".length));
                const hermanos = new Set(ids);

                store.clear();
                for (const [i, nombre] of nombres.entries()) {
                    const id = ids[i];
                    const fuente = await readFile(join(raíz, nombre), "utf-8");
                    const data = await parseData({ id, data: analizar(id, fuente, hermanos) });
                    store.set({ id, data, digest: generateDigest(fuente) });
                }

                logger.info(`Cargados ${nombres.length} scripts de Python`);
            };

            await cargar();

            watcher?.add(raíz);
            watcher?.on("all", (_evento, ruta) => {
                if (ruta.endsWith(".py")) cargar();
            });
        }
    };
}
