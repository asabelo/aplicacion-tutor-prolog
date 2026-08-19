// Usado en los quizes y en los errores de prolog

export function elegirBúho(secciones: Iterable<Element>, numErrores: number): Element | null {
    let menorMáxErrores = Infinity;
    let mejorOpción: Element | null = null;
    let opciónPorDefecto: Element | null = null;

    for (const sección of secciones) {
        const dataMáxErrores = sección.getAttribute("data-máxErrores");
        if (!dataMáxErrores) {
            opciónPorDefecto = sección;
        } else {
            const máxErrores = parseInt(dataMáxErrores);
            if (numErrores <= máxErrores && máxErrores < menorMáxErrores) {
                menorMáxErrores = máxErrores;
                mejorOpción = sección;
            }
        }
    }

    return mejorOpción ?? opciónPorDefecto;
}
