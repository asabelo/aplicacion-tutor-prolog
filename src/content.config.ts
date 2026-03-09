// 1. Import utilities from `astro:content`
import { defineCollection } from 'astro:content';

// 2. Import loader(s)
import { glob, file } from 'astro/loaders';

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

const búhos = defineCollection({
    loader: file("src/data/búhos.json"),
    schema: ({ image }) => z.object({
        id: z.string(),
        éxito: z.boolean(),
        máxErrores: z.nullable(z.number()),
        imagen: z.nullable(z.object({
            ruta: image(),
            alt: z.string()
        })),
        texto: z.string()
    })
});

// 5. Export a single `collections` object to register your collection(s)
export const collections = { quizzes, búhos };