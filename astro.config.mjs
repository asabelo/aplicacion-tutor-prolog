// @ts-check
import { defineConfig } from 'astro/config';
import { viteStaticCopy } from "vite-plugin-static-copy";
import { dirname, join } from "path";
import { fileURLToPath } from "url";
import { PYODIDE_DEST } from "./runtimes.config.mjs";

const PYODIDE_EXCLUDE = [
  "!**/*.{md,html}",
  "!**/*.d.ts",
  "!**/*.whl",
  "!**/node_modules",
];

// https://pyodide.org/en/latest/usage/working-with-bundlers.html#vite
function pyodideTarget() {
  const pyodideDir = dirname(fileURLToPath(import.meta.resolve("pyodide")));
  return {
    src: [join(pyodideDir, "*").replace(/\/g, "/")].concat(PYODIDE_EXCLUDE),
    dest: PYODIDE_DEST,
  };
}

// https://astro.build/config
export default defineConfig({
    vite: {
        optimizeDeps: { exclude: ["pyodide"] },
        plugins: [viteStaticCopy({ targets: [pyodideTarget()] })],
    }
});
