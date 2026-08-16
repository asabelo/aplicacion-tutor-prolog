% consulta: setof(X, (member(X, Lista), menor_que_cinco(X)), Resultado).
% parámetro Lista = [3,1,2,5,1,7,8]

menor_que_cinco(X) :- X < 5.

recoge_numeros(List) :-
    setof(X, menor_que_cinco(X), List).
