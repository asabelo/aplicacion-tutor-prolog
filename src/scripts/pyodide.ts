import type { PyodideInterface } from "pyodide";

import { PYODIDE_DEST } from "../../runtimes.config.mjs";

let instancia: Promise<PyodideInterface> | null = null;

export function obtenerPyodide(): Promise<PyodideInterface> {
    const indexURL = `${import.meta.env.BASE_URL.replace(/\/?$/, "/")}${PYODIDE_DEST}/`;
    instancia ??= import("pyodide").then(módulo => módulo.loadPyodide({ indexURL }));
    return instancia;
}

let cola: Promise<unknown> = Promise.resolve();

export function encolarTarea<T>(tarea: () => Promise<T>): Promise<T> {
    const resultado = cola.then(tarea, tarea);
    cola = resultado.catch(() => {});
    return resultado;
}
