% consulta: apply_to_all(Predicado, Lista).
% parámetro Predicado = integer
% parámetro Lista = [1,2,3]

apply_to_all(Predicate, List) :-
    maplist(call(Predicate), List).
