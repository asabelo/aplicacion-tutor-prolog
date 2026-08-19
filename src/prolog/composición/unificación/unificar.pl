consulta(Objetivo) :-
    \+ call(Objetivo),
    !,
    numbervars(Objetivo, 0, _),
    format("Esto de ~w devuelve falso, ¡bien preguntado!~n", [Objetivo]),
    fail.

consulta(Objetivo) :-
    format("Resultado:~n", []),
    call(Objetivo).

consulta(_) :-
    format("Vamos, que es verdad.~n", []),
    fail. % Hay que fallar para no incluir una solución de más que no tiene que ver con el objetivo del usuario.
          % Provoca un último "; false" extra en backtracking, por desgracia.
