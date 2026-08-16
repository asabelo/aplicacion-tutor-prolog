// Piezas de un bloque de código con huecos, la entrada de Código.astro

export type Fragmento =
    | { texto: string }
    | { entrada: Entrada };

export interface Entrada {
    nombre: string,
    tipo: string,
    valor: string,
    ancho?: number,
    marcador?: string
}
