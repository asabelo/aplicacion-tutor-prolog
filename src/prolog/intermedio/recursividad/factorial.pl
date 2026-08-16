% consulta: factorial(Numero, Resultado).
% parámetro Numero = 5

% CASO BASE
factorial(0, 1).
% CASO RECURSIVO
factorial(N, Result) :-
    N > 0,
    N1 is N - 1,
    factorial(N1, Result1),
    Result is N * Result1.
