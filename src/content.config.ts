// 1. Import utilities from `astro:content`
import { defineCollection } from 'astro:content';

// 2. Import loader(s)
import { glob } from 'astro/loaders';

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

// 5. Export a single `collections` object to register your collection(s)
export const collections = { quizzes };