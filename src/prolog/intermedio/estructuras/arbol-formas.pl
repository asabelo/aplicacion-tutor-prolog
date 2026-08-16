% Un árbol vacío
arbol(nil).

% Un nodo de un árbol binario
arbol(raiz, subarbol_izquierdo, subarbol_derecho).

% Un nodo hoja de un árbol binario
arbol(raiz, nil, nil).

% Ejemplo de un árbol
arbol(1, arbol(2, nil, nil), arbol(3, nil, nil)).
