% Primera generación
padre(ferdinand,john).
padre(ferdinand,james).

% Segunda generación

padre(john, harry).       
madre(mary, harry).
padre(john, william).     
madre(mary, william).

padre(james, emily).      
madre(susan, emily).
padre(james, margaret).
madre(susan, margaret).
padre(james, oliver).
madre(susan, oliver).

% Tercera generación
padre(harry, jim).       
madre(emily, jim).
padre(harry, sophie).
madre(emily, sophie).

padre(william, sebastian).
madre(margaret, sebastian).
padre(william, charlotte).
madre(margaret, charlotte).

padre(oliver, george).    
madre(emma, george).
padre(oliver, lily).
madre(emma, lily).

padre(sebastian, ella).       
madre(claire, ella).
padre(sebastian, jack).
madre(claire, jack).

% Ejemplo de primos cuyos padres son primos porque lo demás se ve mas o menos bien
% - Jim y Charlotte son primos que no se pueden casar, ya que sus padres, Harry, Emily, william y charlotte, son primos


% Definición de relaciones familiares básicas
padre(Padre, Hijo).
madre(Madre, Hijo).
abuelo(Abuelo, Nieto) :- padre(Abuelo, Padre), padre(Padre, Nieto).
abuelo(Abuelo, Nieto) :- padre(Abuelo, Madre), madre(Madre, Nieto).
abuela(Abuela, Nieto) :- madre(Abuela, Padre), padre(Padre, Nieto).
abuela(Abuela, Nieto) :- madre(Abuela, Madre), madre(Madre, Nieto).
hermano(Persona1, Persona2) :- padre(Padre, Persona1), padre(Padre, Persona2), Persona1 \= Persona2.
hermano(Persona1, Persona2) :- madre(Madre, Persona1), madre(Madre, Persona2), Persona1 \= Persona2.
tio(Tio, Sobrino) :- hermano(Tio, Padre), padre(Padre, Sobrino).
tio(Tio, Sobrino) :- hermano(Tio, Madre), madre(Madre, Sobrino).
tia(Tia, Sobrino) :- hermana(Tia, Padre), padre(Padre, Sobrino).
tia(Tia, Sobrino) :- hermana(Tia, Madre), madre(Madre, Sobrino).
primo(Persona1, Persona2) :- padre(Padre1, Persona1), hermano(Padre1, Padre2), padre(Padre2, Persona2).
primo(Persona1, Persona2) :- madre(Madre1, Persona1), hermana(Madre1, Madre2), madre(Madre2, Persona2).

% Grado de consanguinidad 2 (prohibido casarse)
grado2(P1, P2) :- padre(P1, P2).
grado2(P1, P2) :- madre(P1, P2).
grado2(P1, P2) :- hermano(P1, P2).
grado2(P1, P2) :- abuelo(P1, P2).
grado2(P1, P2) :- abuela(P1, P2).
grado2(P1, P2) :- tio(P1, P2).
grado2(P1, P2) :- tia(P1, P2).

% Prohibición de matrimonio entre primos cuyos padres sean primos
no_matrimonio_primos(P1, P2) :-
    primo(P1, P2),
    padre(Padre1, P1),
    padre(Padre2, P2),
    primo(Padre1, Padre2).

no_matrimonio_primos(P1, P2) :-
    primo(P1, P2),
    madre(Madre1, P1),
    madre(Madre2, P2),
    primo(Madre1, Madre2).

% Regla para permitir el matrimonio si no hay consanguinidad prohibida
pueden_casarse(P1, P2) :-
    \+ grado2(P1, P2),
    \+ no_matrimonio_primos(P1, P2).