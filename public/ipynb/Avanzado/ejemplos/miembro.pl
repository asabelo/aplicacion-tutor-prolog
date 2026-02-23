:- dynamic output/1.

miembro(X, List) :-
    member(X, List, Salida),
    retractall(output(_)),
    assert(output(Salida)).

write_elements(Element, []) :-
    format('El elemento ~w no se ha encontrado~n', [Element]).

write_elements(Element, Element) :-
    format('El elemento ~w se ha encontrado en la lista~n', [Element]).

write_elements(Element, Element1) :-
    format('El elemento ~w no coincide con el elemento ~w~n', [Element, Element1]).

member(Element, [Element|_], Salida) :-
    with_output_to(string(Elemento), (
        write_elements(Element, Element)
    )),
    format('~w', [Elemento]),
    string_concat(Elemento, '', Salida).

member(Element, [H|T], Salida) :-
    with_output_to(string(Elemento), (
        write_elements(Element, H)
    )),
    format('~w', [Elemento]),
    member(Element, T, Salida2),
    string_concat(Elemento, Salida2, Salida).
