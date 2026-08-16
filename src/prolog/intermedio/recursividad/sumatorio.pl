% consulta: sumatorio(Inferior, Superior, Total).
% parámetro Inferior = 1
% parámetro Superior = 5

% Caso base: si los límites son iguales, la suma es simplemente el número.
sumatorio(L, L, L).

% Caso recursivo: Mientras el límite inferior esté por debajo del límite superior, suma el número actual con el sumatorio del siguiente número.
sumatorio(L, U, S) :-
    L < U,
    L1 is L + 1,
    sumatorio(L1, U, S1),
    S is L + S1.
