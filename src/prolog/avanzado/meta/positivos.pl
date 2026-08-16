% consulta: todos_positivos(Lista).
% parámetro Lista = [1,2,3]

positivo(X) :- X > 0.
todos_positivos(List) :-
    forall(member(X, List), positivo(X)).
