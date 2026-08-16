% consulta: miembro(Elemento, Lista).
% parámetro Elemento = 5
% parámetro Lista = [1,2,3,4,5,1,2]

% Buscar elemento en lista
% Caso base, el elemento en la cabeza de la lista coincide con el elemento que buscamos.
miembro(Element, [Element|_]).
% Caso recursivo, ignoramos la cabeza de la lista y avanzamos en la lista.
miembro(Element, [_|T]) :-
    miembro(Element, T).
