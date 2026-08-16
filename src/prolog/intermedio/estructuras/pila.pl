% consulta: apilar(c, [b, a], Pila), desapilar(Pila, Cima, Resto).

% Apilar significa añadir un elemento a la pila.
apilar(Elemento, Pila, [Elemento|Pila]).

% Desapilar significa eliminar un elemento de la pila
desapilar([Elemento|Pila], Elemento, Pila).
