% consulta: f1(N, Resultado).
% parámetro N = 4

f1(Numero, Resultado) :-
    Numero =< 1,
    Resultado is 2 + Numero.

f1(Numero, Resultado) :-
    Numero > 1,
    PrimeraX is Numero - 1,
    SegundaX is Numero - 2,
    f1(PrimeraX, Acumulador1),
    f1(SegundaX, Acumulador2),
    Resultado is Acumulador1 + Acumulador2.
