% Departamentos y empleados
trabaja_en(ramon, melenas).
trabaja_en(javier, melenas).
trabaja_en(alberto, bombillas).
trabaja_en(sara, bombillas).

% Clientes
tiene_pelo(melinda).
tiene_pelo(ana).
tiene_pelo(bruno).

no_tiene_pelo(guillermo).
no_tiene_pelo(alvaro).
no_tiene_pelo(antonio).

% Regla para determinar si un vendedor puede vender productos a un cliente
puede_vender(Vendedor, Cliente) :-
    trabaja_en(Vendedor, melenas),
    tiene_pelo(Cliente).

puede_vender(Vendedor, Cliente) :-
    trabaja_en(Vendedor, bombillas),
    no_tiene_pelo(Cliente).

% Ejemplos de consultas:
% ?- puede_vender(ramon, melinda).   % true
% ?- puede_vender(alberto, guillermo). % true
% ?- puede_vender(javier, alvaro).   % false
% ?- puede_vender(sara, bruno).      % false




