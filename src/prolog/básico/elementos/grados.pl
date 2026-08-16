% parámetro Hueco1 =
% parámetro Hueco2 =
% parámetro Hueco3 =
% parámetro Hueco4 =
% parámetro Hueco5 =
% parámetro Hueco6 =
% parámetro Hueco7 =

grado3(P1, P2) :- padre(P1, P2).
grado3(P1, P2) :- madre(P1, P2).
grado3(P1, P2) :- hermano(P1, P2).
grado3(P1, P2) :- Hueco1(P1, P2).
grado3(P1, P2) :- abuela(P1, P2).
grado3(P1, P2) :- Hueco2(P1, P2).
grado3(P1, P2) :- tia(P1, P2).

no_matrimonio_primos(P1, P2) :-
    Hueco3(P1, P2),
    padre(Hueco4, P1),
    padre(Hueco5, P2),
    primo(Padre1, Padre2).

no_matrimonio_primos(P1, P2) :-
    primo(P1, P2),
    madre(Madre1, P1),
    madre(Madre2, P2),
    primo(Hueco6, Hueco7).
