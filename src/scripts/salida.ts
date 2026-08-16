const MÁX_LÍNEAS = 5000;

export interface Escritor {
    escribir: (texto: string) => void,
    limpiar: () => void
}

export function crearEscritor(salida: HTMLElement, máxLíneas = MÁX_LÍNEAS): Escritor {

    let líneas = 0;

    return {
        escribir(texto) {
            if (líneas > máxLíneas) return;
            líneas += texto.split("\n").length;
            salida.textContent += líneas > máxLíneas
                ? "\n… salida truncada …"
                : texto;
        },

        limpiar() {
            salida.textContent = "";
            líneas = 0;
        }
    };
}
