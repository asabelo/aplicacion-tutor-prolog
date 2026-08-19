// Compartido entre el cargador de Prolog y el componente, en sus dos lados: por eso no
// puede vivir en el cargador, que el cliente no puede importar (arrastra node:fs)

// Hueco donde el usuario escribe el objetivo, en vez de un argumento suelto
export const HUECO_LIBRE = "Consulta";

// Aparición del nombre de un hueco como palabra completa, que es donde va su caja
export function comoPalabra(nombre: string, indicadores = "u"): RegExp {
    return new RegExp(String.raw`(?<![\p{L}\p{N}_])${nombre}(?![\p{L}\p{N}_])`, indicadores);
}

// Directiva que declara una dependencia de un hermano; se muestra pero no se consulta
export const REGEX_DEPENDENCIA_PROLOG = /^\s*:-\s*ensure_loaded\(\s*'?([^'()]+?)'?\s*\)\s*\.\s*$/u;
