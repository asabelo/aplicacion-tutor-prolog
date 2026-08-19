:- ensure_loaded(sandwich).

hacer_sandwich(Pan1, Relleno, Pan2) :-
    rebanada_de_pan(Pan1),
    relleno(Relleno),
    rebanada_de_pan(Pan2).

hacer_sandwich(Pan1, Relleno, Pan2) :-
    \+ ( rebanada_de_pan(Pan1), relleno(Relleno), rebanada_de_pan(Pan2) ),
    write('QUE CLASE DE SANDWICH ME ESTAS ARMANDO, PEDAZO DE PSICOPATA'), nl,
    fail.
