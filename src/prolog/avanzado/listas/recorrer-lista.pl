% consulta: recorrer_lista(Lista).
% parámetro Lista = [1,2,3,4,5]

% Caso base, la lista está vacía y no hay nada que recorrer.
recorrer_lista([]).

% Caso recursivo, la lista contiene al menos un elemento.
recorrer_lista([H|T]):-
    write('Elemento en la cabeza '),
    write(H),
    nl,
    recorrer_lista(T).
