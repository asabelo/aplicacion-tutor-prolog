% consulta: primer_elemento(tupla(a, b), X).

:- ensure_loaded(tupla).

primer_elemento(tupla(X, _), X).
segundo_elemento(tupla(_, Y), Y).
