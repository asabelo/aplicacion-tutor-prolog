import type { Loader } from "astro/loaders";
import { readdir, readFile } from "node:fs/promises";
import { fileURLToPath } from "node:url";
import { join } from "node:path";

export const blanca = (línea: string) => línea.trim() === "";

// Colección de ficheros de código bajo una raíz, con el id igual a la ruta relativa sin
// extensión. `analizar` saca los datos de la entrada a partir de la fuente y del conjunto
// de ids existentes (para resolver dependencias entre hermanos).
export function cargadorDeFicheros(
    nombre: string,
    extensión: string,
    base: string,
    analizar: (id: string, fuente: string, hermanos: Set<string>) => Record<string, unknown>
): Loader {
    return {
        name: nombre,

        load: async ({ store, parseData, generateDigest, watcher, logger, config }) => {
            const raíz = fileURLToPath(new URL(base, config.root));

            const cargar = async () => {
                const nombres = (await readdir(raíz, { recursive: true }))
                    .map(n => n.replaceAll("\\", "/"))
                    .filter(n => n.endsWith(extensión));

                const ids = nombres.map(n => n.slice(0, -extensión.length));
                const hermanos = new Set(ids);

                store.clear();
                for (const [i, fichero] of nombres.entries()) {
                    const id = ids[i];
                    const fuente = await readFile(join(raíz, fichero), "utf-8");
                    const data = await parseData({ id, data: analizar(id, fuente, hermanos) });
                    store.set({ id, data, digest: generateDigest(fuente) });
                }

                logger.info(`Cargados ${nombres.length} ficheros de ${nombre}`);
            };

            await cargar();

            watcher?.add(raíz);
            watcher?.on("all", (_evento, ruta) => {
                if (ruta.endsWith(extensión)) cargar();
            });
        }
    };
}
