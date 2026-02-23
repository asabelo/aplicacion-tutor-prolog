:- dynamic output/1.

f1(Numero, Resultado) :-
    retractall(output(_)),  
    f1_aux(Numero, Resultado, Output),
    assert(output(Output)).

f1_aux(Numero, Resultado, Acc) :-
    Numero =< 1,
    Resultado is 2 + Numero,
    with_output_to(string(Salida), (
        write_elements(Numero, Resultado)
    )),
    string_concat('', Salida, Acc).

f1_aux(Numero, Resultado, Acc) :-
    Numero > 1,
    PrimeraX is Numero - 1,
    SegundaX is Numero - 2,
    f1_aux(PrimeraX, Acumulador1, Acc1),
    f1_aux(SegundaX, Acumulador2, Acc2),
    Resultado is Acumulador1 + Acumulador2,
    with_output_to(string(Salida), (
        write_elements(Numero, Resultado)
    )),
    string_concat(Acc1, Acc2, AccTemp),  % Corrected the order here for concatenation
    string_concat(AccTemp, Salida, Acc). % Corrected to accumulate all outputs

write_elements(Numero, Resultado) :-
    Numero =< 1,
    format('Caso base alcanzado: El numero ~w devuelve el resultado ~w~n', [Numero, Resultado]).

write_elements(Numero, Resultado) :-
    Numero > 1,
    PrimeraX is Numero - 1, % Calculating correctly for output
    SegundaX is Numero - 2,
    format('Operacion del caso recursivo: f1(~w) = f1(~w) + f1(~w) = ~w~n', [Numero, PrimeraX, SegundaX, Resultado]).
