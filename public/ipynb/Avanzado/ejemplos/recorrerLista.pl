:- dynamic output/1.

% Caso recursivo, la lista contiene al menos un elemento.
recorrer_lista([H|T]) :-
    recorrer_lista_aux([H|T], Salida),
    retractall(output(_)),  % Limpia cualquier salida previa
    assert(output(Salida)).

write_elements([]).
write_elements(H) :-
    format('El elemento en la cabeza es ~w~n', [H]).
        
recorrer_lista_aux([], '').
recorrer_lista_aux([H|T], Salida) :-
    with_output_to(string(Elemento), (
        write_elements([H])
    )),
    format('~w', [Elemento]),
    nl,
    recorrer_lista_aux(T, Salida2),
    string_concat(Elemento, Salida2, Salida).
