export interface Datos {
    título: string,
    descripción: string
}

import type { AstroInstance } from "astro";

export interface AstroInstance2 extends AstroInstance {
    datos: Datos
}