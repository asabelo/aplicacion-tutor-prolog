// 1. Import utilities from `astro:content`
import { defineCollection } from 'astro:content';

// 2. Import loader(s)
import { glob, file } from 'astro/loaders';
import { python } from './loaders/python';
import { prolog } from './loaders/prolog';

// 3. Import Zod
import { z } from 'astro/zod';

// 4. Define your collection(s)
const quizzes = defineCollection({
    loader: glob({ pattern: "**/*.json", base: "./src/data/quizzes" }),
    schema: z.array(
        z.object({
            orden: z.number(),
            pregunta: z.string(),
            opciones: z.array(
                z.object({
                    clave: z.number(),
                    texto: z.string()
                })
            ),
            respuesta: z.number()
        })
    )
});

const capítulos = defineCollection({
    loader: file("src/data/capítulos.json"),
    schema: z.object({
        id: z.string(), // La ruta de la página, sin la barra inicial
        orden: z.number(),
        título: z.string(),
        descripción: z.string()
    })
});

const factorial = defineCollection({
    loader: file("src/data/factorial.json"),
    schema: z.object({
        id: z.string(),
        orden: z.number(),
        título: z.optional(z.string()),
        texto: z.optional(z.string()),
        código: z.optional(z.array(z.string()))
    })
});

const búhos = defineCollection({
    loader: file("src/data/búhos.json"),
    schema: ({ image }) => z.object({
        id: z.string(),
        contextos: z.array(z.enum(["quiz", "sintaxis"])).nonempty(),
        éxito: z.boolean(),
        máxErrores: z.nullable(z.number()),
        imagen: z.nullable(z.object({
            ruta: image(),
            alt: z.string()
        })),
        texto: z.string()
    })
});

const pythons = defineCollection({
    loader: python("./src/python"),
    schema: z.object({
        fuente: z.string(), // Código sin procesar para importar en otros scripts
        código: z.string(), // Código procesado para mostrar en el HTML
        ejecutable: z.boolean(),
        dependencias: z.array(z.string()),
        parámetros: z.array(
            z.object({
                nombre: z.string(),
                tipo: z.enum(["texto", "entero"]),
                porDefecto: z.string()
            })
        )
    })
});

const prologs = defineCollection({
    loader: prolog("./src/prolog"),
    schema: z.object({
        fuente: z.string(),   // El fichero tal cual, para poder cargarlo en SWI-Prolog
        código: z.string(),   // Sin las marcas: es lo que se muestra
        programa: z.string(), // El código sin las directivas `ensure_loaded`: es lo que se consulta
        consulta: z.nullable(z.string()),
        ejecutable: z.boolean(),
        dependencias: z.array(z.string()),
        parámetros: z.array(
            z.object({
                nombre: z.string(),
                porDefecto: z.string(),
                en: z.enum(["código", "consulta"])
            })
        )
    })
});

// 5. Export a single `collections` object to register your collection(s)
export const collections = { quizzes, capítulos, factorial, búhos, pythons, prologs };