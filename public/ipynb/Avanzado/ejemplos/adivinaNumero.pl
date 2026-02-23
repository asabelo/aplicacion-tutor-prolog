:- dynamic output/1.
adivinar_numero(X) :-

        retractall(output(_)),
        once(adivinar_aux(X,Output)),
    assert(output(Output)).

adivinar_aux(X,Output):-
    with_output_to(string(SalidaIntro), (
        escribir_intro
    )),
    format('~w~n', [SalidaIntro]),
    adivinar(1, 100, X, SalidaAdivinar),
    string_concat(SalidaIntro, SalidaAdivinar, Output).



adivinar(Min, Max, NumeroSecreto, Salida) :-
    Min =< Max,
    Middle is (Min + Max) // 2,
    simular_respuesta(Middle, NumeroSecreto, Respuesta, SalidaSimulacion),
    manejar_respuesta(Respuesta, Min, Max, Middle, NumeroSecreto, SalidaManejo),
    string_concat(SalidaSimulacion, SalidaManejo, Salida).

simular_respuesta(Middle, NumeroSecreto, si, '') :-
    Middle =:= NumeroSecreto.

simular_respuesta(Middle, NumeroSecreto, mayor, Salida) :-
    Middle < NumeroSecreto,
    with_output_to(string(Salida1), (
        escribir_continuacion(Middle, mayor)
    )),
       format('~w~n', [Salida1]),
    string_concat(Salida1, '', Salida).

simular_respuesta(Middle, NumeroSecreto, menor, Salida) :-
    Middle > NumeroSecreto,
    with_output_to(string(Salida1), (
        escribir_continuacion(Middle, menor)
    )),
        format('~w~n', [Salida1]),
    string_concat('', Salida1, Salida).


manejar_respuesta(si, _, _, X, _, Salida) :-
    with_output_to(string(Salida1), (
        escribir_final(X)
    )),
        format('~w~n', [Salida1]),
    string_concat('', Salida1, Salida).


manejar_respuesta(mayor, _, Max, Middle, NumeroSecreto, Salida) :-
    NuevoMin is Middle + 1,
    adivinar(NuevoMin, Max, NumeroSecreto, Salida).

manejar_respuesta(menor, Min, _, Middle, NumeroSecreto, Salida) :-
    NuevoMax is Middle - 1,
    adivinar(Min, NuevoMax, NumeroSecreto, Salida).

escribir_intro :-
    format('Voy a intentar adivinar el numero en el que estas pensando (entre 1 y 100).~n').

escribir_continuacion(X, mayor) :-
    format('Es tu numero ~w?~nNo. Mi numero es mayor a ~w.~n', [X, X]).

escribir_continuacion(X, menor) :-
    format('Es tu numero ~w?~nNo. Mi numero es menor a ~w.~n', [X, X]).

escribir_final(X) :-
    format('Lo tengo. Tu numero es: ~w~n', [X]).
