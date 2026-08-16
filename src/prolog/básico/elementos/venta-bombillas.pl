% consulta: puede_vender(Vendedor, Cliente).
% parámetro Departamento =
% parámetro Comprador =

:- ensure_loaded(venta).

puede_vender(Vendedor, Cliente) :-
    trabaja_en(Vendedor, Departamento),
    no_tiene_pelo(Comprador).
