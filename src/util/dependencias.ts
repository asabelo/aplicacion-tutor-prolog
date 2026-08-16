// Recorre el grafo de dependencias de una entrada de colección en post-orden, con
// detección de ciclos, y devuelve las entradas en orden de carga y sin duplicados.
export async function recolectarDependencias<E>(
    ids: string[],
    busca: (id: string) => Promise<{ dependencias: string[], entrada: E } | undefined>,
    origen: string
): Promise<E[]> {

    const recogidos: E[] = [];
    const vistos: string[] = [];

    async function visitar(id: string, visitados: string[]) {
        if (visitados.includes(id)) {
            throw Error(`Dependencia circular en ${[...visitados, id].join(" → ")}`);
        }

        const encontrado = await busca(id);
        if (!encontrado) throw Error(`No se ha encontrado la dependencia ${id} de ${origen}`);

        for (const dependencia of encontrado.dependencias) {
            await visitar(dependencia, [...visitados, id]);
        }

        if (!vistos.includes(id)) {
            vistos.push(id);
            recogidos.push(encontrado.entrada);
        }
    }

    for (const id of ids) await visitar(id, []);
    return recogidos;
}
