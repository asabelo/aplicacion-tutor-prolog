// @ts-check
import { defineConfig } from 'astro/config';
import { viteStaticCopy } from "vite-plugin-static-copy";
import { dirname, join } from "path";
import { fileURLToPath } from "url";
import { PYODIDE_DEST } from "./pyodide.config.mjs";

const PYODIDE_EXCLUDE = [
  "!**/*.{md,html}",
  "!**/*.d.ts",
  "!**/*.whl",
  "!**/node_modules",
];

// https://pyodide.org/en/latest/usage/working-with-bundlers.html#vite
export function viteStaticCopyPyodide() {
  const pyodideDir = dirname(fileURLToPath(import.meta.resolve("pyodide")));
  return viteStaticCopy({
    targets: [
      {
        src: [join(pyodideDir, "*").replace(/\\/g, "/")].concat(
          PYODIDE_EXCLUDE
        ),
        dest: PYODIDE_DEST,
      },
    ],
  });
}

// https://astro.build/config
export default defineConfig({
    vite: {
        optimizeDeps: { exclude: ["pyodide"] },
        plugins: [viteStaticCopyPyodide()],
    }
});
