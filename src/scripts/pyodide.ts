import type { PyodideInterface } from "pyodide";

import { PYODIDE_DEST } from "../../pyodide.config.mjs";

let instancia: Promise<PyodideInterface> | null = null;

export function obtenerPyodide(): Promise<PyodideInterface> {
    // dest establecido a PYODIDE_DEST en viteStaticCopyPyodide()
    const indexURL = `${import.meta.env.BASE_URL.replace(/\/?$/, "/")}${PYODIDE_DEST}/`;
    instancia ??= import("pyodide").then(módulo => módulo.loadPyodide({ indexURL }));
    return instancia;
}

// Para ejecutar secuencialmente los scripts de una misma página, ya que comparten instancia de pyodide
let cola: Promise<unknown> = Promise.resolve();

export function encolarTarea<T>(tarea: () => Promise<T>): Promise<T> {
    const resultado = cola.then(tarea, tarea);
    cola = resultado.catch(() => {});
    return resultado;
}
