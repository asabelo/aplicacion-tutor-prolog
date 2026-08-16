abuelo(Persona1, Persona2) :-
    padre(Persona1, X),
    padre(X, Persona2).
