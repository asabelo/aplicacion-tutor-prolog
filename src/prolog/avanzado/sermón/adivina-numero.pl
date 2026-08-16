% consulta: adivinar_numero(Pensado).
% parámetro Pensado = 42

adivinar_numero(Numero) :-
    format("Voy a intentar adivinar el numero en el que estas pensando (entre 1 y 100).~n", []),
    adivinar(1, 100, Numero).

adivinar(Min, Max, Secreto) :-
    Min =< Max,
    Medio is (Min + Max) // 2,
    comparar(Medio, Min, Max, Secreto).

comparar(Medio, _, _, Secreto) :-
    Medio =:= Secreto,
    format("Lo tengo. Tu numero es: ~w~n", [Medio]).

comparar(Medio, _, Max, Secreto) :-
    Medio < Secreto,
    format("Es tu numero ~w?~nNo. Mi numero es mayor a ~w.~n", [Medio, Medio]),
    NuevoMin is Medio + 1,
    adivinar(NuevoMin, Max, Secreto).

comparar(Medio, Min, _, Secreto) :-
    Medio > Secreto,
    format("Es tu numero ~w?~nNo. Mi numero es menor a ~w.~n", [Medio, Medio]),
    NuevoMax is Medio - 1,
    adivinar(Min, NuevoMax, Secreto).
