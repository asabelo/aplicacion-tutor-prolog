% consulta: nth_element(Lista, Posicion, Elemento).
% parámetro Lista = [1,2,3]
% parámetro Posicion = 2

% Caso base: Si N es 1, el primer elemento es la cabeza de la lista.
nth_element([H|_], 1, H).

% Caso recursivo: Decrementamos N y llamamos recursivamente con la cola de la lista.
nth_element([_|T], N, Elemento) :-
    N > 1,
    N1 is N - 1,
    nth_element(T, N1, Elemento).
