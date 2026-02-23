padreomadre(antonio, maria).
padreomadre(marta, maria).

padreomadre(jose, pedro).
padreomadre(maria, pedro).


padreomadre(pedro, juan).
padreomadre(ana, juan).
padreomadre(pedro, elena).
padreomadre(ana, elena).

padreomadre(juan, carlos).
padreomadre(laura, carlos).
padreomadre(juan, sofia).
padreomadre(laura, sofia).

padreomadre(elena,alvaro).
padreomadre(alberto,alvaro).
padreomadre(elena,julia).
padreomadre(alberto,julia).


%antonio y marta son progenitores de maria
%Jose y maria son progenitores de pedro y laura
%pedro y ana son progenitores de juan y de elena
%juan y elena son hermanos
%juan y laura son progenitores de carlos y de sofia y tios de alvaro y julia
%carlos y sofia son hermanos y primos de alvaro y julia
%elena y alberto son progenitores de alvaro y julia y tios de carlos y sofia
%alvaro y julia son hermanos, y primos de carlos y sofia
hombre(jose).
hombre(pedro).
hombre(juan).
hombre(carlos).
hombre(antonio).
hombre(alberto).
hombre(alvaro).

mujer(maria).
mujer(ana).
mujer(laura).
mujer(sofia).
mujer(elena).
mujer(marta).
mujer(julia).

% Una persona será hijo de su progenitor si tienen parentesco directo y es un hombre.
hijo(Hijo, Progenitor) :- padreomadre(Progenitor, Hijo), hombre(Hijo).

% Una persona será hija de su progenitor si tienen parentesco directo y es una mujer.
hija(Hija, Progenitor) :- padreomadre(Progenitor, Hija), mujer(Hija).

% Una persona será abuelo de su nieto si es padre del progenitor de su nieto y es hombre.
abuelo(Abuelo, Nieto) :- padreomadre(Abuelo, Progenitor), padreomadre(Progenitor, Nieto), hombre(Abuelo).

% Una persona será abuela de su nieto si es madre del progenitor de su nieto y es mujer.
abuela(Abuela, Nieto) :- padreomadre(Abuela, Madre), padreomadre(Madre, Nieto), mujer(Abuela).

% Dos personas serán hermanos si tienen los mismos padres, son dos hombres o un hombre una mujer y sabiendo que una persona no puede ser hermano de si mismo.
hermano(Hermano1, Hermano2) :- padreomadre(Progenitor, Hermano1), padreomadre(Progenitor, Hermano2), Hermano1 \= Hermano2,
((hombre(Hermano1),hombre(Hermano2);hombre(Hermano1),mujer(Hermano2);mujer(Hermano1),hombre(Hermano2)),(not(mujer(Hermano1)), not(mujer(Hermano2)))).

% Dos personas serán hermanas si tienen los mismos padres, son dos mujeres y sabiendo que una persona no puede ser hermana de si misma.
hermana(Hermana1, Hermana2) :- padreomadre(Progenitor, Hermana1), padreomadre(Progenitor, Hermana2), Hermana1 \= Hermana2, mujer(Hermana1), mujer(Hermana2).

% Dos personas serán primos entre si si sus padres son hermanos y son dos hombres o un hombre y una mujer.
primo(Primo1, Primo2) :- padreomadre(Progenitor1, Primo1), padreomadre(Progenitor2, Primo2), hermano(Progenitor1, Progenitor2), Primo1 \= Primo2,
((hombre(Primo1),hombre(Primo2);hombre(Primo1),mujer(Primo2);mujer(Primo1),hombre(Primo2)),(not(mujer(Primo2)), not(mujer(Primo2)))).

% Dos personas serán primas entre si si sus padres son hermanos y mujeres.
prima(Prima1, Prima2) :- padreomadre(Progenitor1, Prima1), padreomadre(Progenitor2, Prima2), hermano(Progenitor1, Progenitor2), Prima1 \= Prima2, mujer(Prima1),mujer(Prima2).

% Una persona será tío de otra si es hermano del progenitor de su sobrino y es un hombre.
tio(Tio, Sobrino) :- padreomadre(Progenitor, Sobrino), hermano(Progenitor, Tio), hombre(Tio).

% Una persona será tía de otra si es hermana del progenitor de su sobrino y es un una mujer.
tia(Tia, Sobrina) :- padreomadre(Madre, Sobrina), hermana(Madre, Tia), mujer(Tia).