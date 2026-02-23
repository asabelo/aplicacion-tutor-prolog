rebanada_de_pan(rebanada).

relleno(jamon_y_queso).

relleno(salchicha_y_queso).

relleno(huevo_y_bacon).

relleno(carne_picada).

hacer_sandwich(Sandwich) :-
rebanada_de_pan(Rebanada1),    
rebanada_de_pan(Rebanada2),
relleno(Relleno),    
Sandwich = [Rebanada1, Relleno, Rebanada2].

hacer_sandwich(Rebanada1,Rebanada2,Relleno) :-
rebanada_de_pan(Rebanada1),    
rebanada_de_pan(Rebanada2),
relleno(Relleno).