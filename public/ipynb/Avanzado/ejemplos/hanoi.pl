:- dynamic output/1.

hanoi(0, _, _, _, Output, Output) :- !.

hanoi(N, Source, Target, Auxiliary, CurrentOutput, FinalOutput) :-
    N > 0,
    M is N - 1,
    hanoi(M, Source, Auxiliary, Target, CurrentOutput, MidOutput1),
    with_output_to(string(MoveOutput), move_disk(Source, Target)),
    string_concat(MidOutput1, MoveOutput, MidOutput2),
    hanoi(M, Auxiliary, Target, Source, MidOutput2, FinalOutput).

move_disk(Source, Target) :-
    format('Mover disco de ~w a ~w~n', [Source, Target]).

write_element(Output) :-
    format('Caso base').

mover(N) :-
    retractall(output(_)),
    hanoi(N, 'izquierda', 'derecha', 'centro', '', Output),
    assert(output(Output)).
