% consulta: obtener_valor([nombre-ana, edad-33], Buscada, Valor).
% parámetro Buscada = nombre

obtener_valor(Diccionario, Clave, Valor) :-
    member(Clave-Valor, Diccionario).
