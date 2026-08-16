% consulta: mover(Discos).
% parámetro Discos = 3

hanoi(0, _, _, _) :- !.
hanoi(N, Origen, Destino, Auxiliar) :-
    N > 0,
    M is N - 1,
    hanoi(M, Origen, Auxiliar, Destino),
    mover_disco(Origen, Destino),
    hanoi(M, Auxiliar, Destino, Origen).

mover_disco(Origen, Destino) :-
    format("Mover disco de ~w a ~w~n", [Origen, Destino]).

mover(N) :-
    hanoi(N, izquierda, derecha, centro).
