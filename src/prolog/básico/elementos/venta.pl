% consulta: puede_vender(Vendedor, Cliente).

% Departamentos y empleados
trabaja_en(javier, melenas).
trabaja_en(alberto, bombillas).

% Clientes
tiene_pelo(ana).
tiene_pelo(bruno).
no_tiene_pelo(alvaro).
no_tiene_pelo(antonio).

% Regla para determinar si un vendedor puede vender productos a un cliente con pelo
puede_vender(Vendedor, Cliente) :-
    trabaja_en(Vendedor, melenas),
    tiene_pelo(Cliente).
