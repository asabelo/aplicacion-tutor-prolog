% consulta: todos_pares(Lista).
% parámetro Lista = [2,4,6]

es_par(X) :- 0 is X mod 2.

todos_pares(List) :-
    maplist(es_par, List).
