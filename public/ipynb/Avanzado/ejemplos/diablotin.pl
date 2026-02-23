tablero_ordenado([ ['@', 'A', 'B', 'C', 'D', 'E', 'F'],
          		   ['G', 'H', 'I', 'J', 'K', 'L', 'M'],
          	       ['N', 'O', 'P', 'Q', 'R', 'S', 'T'],
                   ['U', 'V', 'W', 'X', 'Y', 'Z', ' '] ]).
ficha('@',0,0).
ficha('A',0,1).
ficha('B',0,2).
ficha('C',0,3).
ficha('D',0,4).
ficha('E',0,5).
ficha('F',0,6).
ficha('G',1,0).
ficha('H',1,1).
ficha('I',1,2).
ficha('J',1,3).
ficha('K',1,4).
ficha('L',1,5).
ficha('M',1,6).
ficha('N',2,0).
ficha('O',2,1).
ficha('P',2,2).
ficha('Q',2,3).
ficha('R',2,4).
ficha('S',2,5).
ficha('T',2,6).
ficha('U',3,0).
ficha('V',3,1).
ficha('W',3,2).
ficha('X',3,3).
ficha('Y',3,4).
ficha('Z',3,5).
ficha(' ',3,6).



tablero_desordenado10([ ['@', 'A', 'B', ' ', 'C', 'D', 'F'],
			  		  	['G', 'H', 'I', 'J', 'K', 'E', 'M'],
					  	['N', 'O', 'P', 'Q', 'R', 'L', 'T'],
					  	['U', 'V', 'W', 'X', 'Y', 'S', 'Z'] ]).

tablero_desordenado2([ ['@', 'A', 'B', 'C', 'D', 'E', 'F'],
					   ['G', 'H', 'I', 'J', 'K', 'L', ' '],
					   ['N', 'O', 'P', 'Q', 'R', 'S', 'M'],
					   ['U', 'V', 'W', 'X', 'Y', 'Z', 'T'] ]).

tablero_desordenado2b( [ ['@', 'A', 'B', 'C', 'D', 'E', 'F'],
                       	 ['G', 'H', 'I', 'J', 'K', 'L', 'M'],
                         ['N', 'O', 'P', 'Q', 'R', ' ', 'T'],
                         ['U', 'V', 'W', 'X', 'Y', 'S', 'Z'] ] ).

tablero_desordenado6([ ['@', 'A', 'B', 'C', 'D', ' ', 'F'],
                       ['G', 'H', 'I', 'J', 'K', 'E', 'M'],
                       ['N', 'O', 'P', 'Q', 'R', 'L', 'T'],
                       ['U', 'V', 'W', 'X', 'Y', 'S', 'Z']] ).


:-dynamic(visitado/1).
:- dynamic output/1.


% [[@, A, B, C, D, E, F], [G, H, I, J, K, L, M], [N, O, P, Q, R, S, ], [U, V, W, X, Y, Z, T]] Da false
% Modificar el predicado para capturar la salida en una lista de caracteres
resolver_diablotin_id(NumCambios) :-
    retractall(visitado(_)),
    desordenar_tablero(NumCambios, TableroDesordenado),
    %tablero_desordenado2b(TableroDesordenado),
    with_output_to(string(Output), (
        format("Tablero de partida:~n"),
        mostrar_posiciones([TableroDesordenado]), format("~n~n"),
        evaluar_posicion(TableroDesordenado, PrimeraEvaluacion),
        resolver(PrimeraEvaluacion, [[PrimeraEvaluacion, TableroDesordenado]], Solucion),
        length(Solucion, NumMovimientos),
        N1 is NumMovimientos - 1,
        format("Solución encontrada.~n"),
        format("Número de movimientos: ~d~n", [N1]),
        format("Secuencia de posiciones:~n"),
        mostrar_posiciones(Solucion)
    )), assert(output(Output)), !.
mostrar_posiciones([]).
mostrar_posiciones([P | Ps]) :-
    mostrar_filas(P),
    format("-------------------------~n"),
    mostrar_posiciones(Ps).

mostrar_filas([]).
mostrar_filas([F | Fs]) :-
    format("~w~n", [F]),
    mostrar_filas(Fs).


% Comprobar si hemos llegado a un tablero ordenado
resolver(_, [ [_, TableroActual] | _], [TableroActual]) :-
    tablero_ordenado(TableroOrdenado),
    TableroActual = TableroOrdenado, !.

% Dado un tablero, encontrar los movimientos posibles desde ese tablero y, haciendo búsqueda en profundidad,
% continuar los movimientos sucesivos a partir de éstos. Las posiciones (tableros) por las que se avanzan
% se van guardando en MovimientosSolucion:
resolver(LimiteEvaluacion, [ [ _, TableroSiguiente] | TablerosSiguientes], [TableroSiguiente | MovimientosSolucion]) :-
    assert(visitado(TableroSiguiente)),
    movimientos_siguientes(1, TableroSiguiente, SiguientesActual, []),
    %exclude(quitar_visitados, SiguientesActual, Siguientes),
    insertar_movimientos(LimiteEvaluacion, SiguientesActual, TablerosSiguientes, SiguientesOrdenados),
    resolver(LimiteEvaluacion, SiguientesOrdenados, MovimientosSolucion).


quitar_visitados(Tablero) :-
    visitado(Tablero).



% https://stackoverflow.com/questions/14680829/8-puzzle-has-a-solution-in-prolog-using-manhattan-distance
% https://stackoverflow.com/questions/24630245/how-to-solve-15-puzzle-paradigm-in-prolog-with-manhattan-hamming-heuristics
% insertar_movimiento([ [0,2], [6,3] ], [ [2,3], [5,5], [9,8], [12,2]], P)
insertar_movimientos(LimiteEvaluacion, Siguientes, TablerosSiguientes, SiguientesOrdenados) :-
    evaluar_movimientos(Siguientes, Evaluados),
    %exclude(quitar_malas_posiciones(LimiteEvaluacion), EvaluadosPotenciales, Evaluados),
    ordenar_evaluaciones(Evaluados, EvaluadosOrdenados),
    insertar_movimiento(EvaluadosOrdenados, TablerosSiguientes, SiguientesOrdenados).

quitar_malas_posiciones(Limite, [Evaluacion, _]) :-
    L1 is Limite + 2,
    Evaluacion > L1.


insertar_movimiento([], POs, POs).
insertar_movimiento([ [E, P] | Ps], [ [E1, P1] | POs], [ [E1, P1] | Insertado]) :-
    E >= E1,
    insertar_movimiento([ [E, P] | Ps], POs, Insertado), !.
insertar_movimiento([P1 | Ps], POs, [P1 | Insertado]) :-
    insertar_movimiento(Ps, POs, Insertado).



% ordenar_evaluaciones([ [2,3], [5,5], [1,8], [8,2]], M)
ordenar_evaluaciones([], []).
ordenar_evaluaciones([P], [P]) :- !.
ordenar_evaluaciones([P | Ps], Ordenados) :-
    menores(P, Ps, Menores),
    ordenar_evaluaciones(Menores, MenoresOrdenados),
    mayores(P, Ps, Mayores),
    ordenar_evaluaciones(Mayores, MayoresOrdenados),
    PMayores = [P | MayoresOrdenados],
    append(MenoresOrdenados, PMayores, Ordenados).

% mayores([4,3], [ [2,3], [5,5], [1,8], [8,2]], M)
menores(_, [], []).
menores([E, P], [ [E1, P1] | Ps], [ [E1, P1] | Ms]) :-
    E1 =< E,
    menores([E, P], Ps, Ms), !.
menores(P, [_ | Ps], Ms) :-
    menores(P, Ps, Ms).

mayores(_, [], []).
mayores([E, P], [ [E1, P1] | Ps], [ [E1, P1] | Ms]) :-
    E1 > E,
    mayores([E, P], Ps, Ms), !.
mayores(P, [_ | Ps], Ms) :-
    mayores(P, Ps, Ms).



% tablero_desordenado10(_T), movimientos_siguientes(1, _T, _TS, []), evaluar_movimientos(_TS, E)
evaluar_movimientos(Posiciones, Evaluados) :-
    maplist(evaluar_posicion, Posiciones, Evaluaciones),
    maplist(incluir_evaluacion, Evaluaciones, Posiciones, Evaluados).
incluir_evaluacion(Evaluacion, Posicion, [Evaluacion, Posicion]).



evaluar_posicion(Filas, Evaluacion) :-
    length(Filas, NF), NF1 is NF - 1, numlist(0, NF1, NumFilas),
    Filas = [Fila | _], length(Fila, NC), NC1 is NC - 1, numlist(0, NC1, NumColumnas),
    foldl(evaluar_fila(NumColumnas), NumFilas, Filas, 0, Evaluacion).

% evaluar_fila([0, 1, 2, 3, 4, 5, 6], 0, [(@), 'A', 'B', ' ', 'C', 'D', 'F'], 0, E)
evaluar_fila(NumColumnas, NumFila, Fila, Evaluacion1, Evaluacion) :-
    foldl(evaluar_ficha(NumFila), NumColumnas, Fila, 0, Evaluacion2),
    Evaluacion is Evaluacion1 + Evaluacion2.

evaluar_ficha(NumFila, NumColumna, Ficha, Evaluacion1, Evaluacion2) :-
    ficha(Ficha, F, C),
    F1 is abs(F - NumFila),
    C1 is abs(C - NumColumna),
    Evaluacion2 is Evaluacion1 + F1 + C1.


% Dado un tablero, obtiene todos los tableros posibles y válidos resultantes
% de mover el hueco a alguna posición colindante
movimientos_siguientes(5, _, TablerosSiguientes, TablerosSiguientes).
movimientos_siguientes(Movimiento, TableroActual, TablerosSiguientes, AccTableros) :-
    hacer_movimiento(Movimiento, TableroActual, TableroSiguiente),
    \+ visitado(TableroSiguiente),
    M1 is Movimiento + 1,
    movimientos_siguientes(M1, TableroActual, TablerosSiguientes, [TableroSiguiente | AccTableros]), !.
movimientos_siguientes(Movimiento, TableroActual, TablerosSiguientes, AccTableros) :-
    M1 is Movimiento + 1,
    movimientos_siguientes(M1, TableroActual, TablerosSiguientes, AccTableros), !.



% PREDICADOS PARA DESORDENAR EL TABLERO %%%%%%%%%%%%%%%%
desordenar_tablero(NumMovimientos, TableroDesordenado) :-
    tablero_ordenado(TableroOrdenado),
    mover_hueco_aleatorio(NumMovimientos, TableroOrdenado, TableroDesordenado).


mover_hueco_aleatorio(0, TableroFinal, TableroFinal) :- !.
mover_hueco_aleatorio(NumMovimientos, TableroEntrada, TableroDesordenado) :-
    NumMovimientos > 0,
    random(1, 5, Movimiento),
    hacer_movimiento(Movimiento, TableroEntrada, TableroMovido),
    N1 is NumMovimientos - 1,
    mover_hueco_aleatorio(N1, TableroMovido, TableroDesordenado), !.
mover_hueco_aleatorio(NumMovimientos, TableroEntrada, TableroDesordenado) :-
    mover_hueco_aleatorio(NumMovimientos, TableroEntrada, TableroDesordenado).




% PREDICADOS PARA MOVER EL HUECO EN LAS CUATRO DIRECCIONES %%%%%%%%%%%%%%%%
hacer_movimiento(1, TableroEntrada, TableroMovido) :-
	mover_hueco_izquierda(TableroEntrada, TableroMovido).
hacer_movimiento(2, TableroEntrada, TableroMovido) :-
	mover_hueco_derecha(TableroEntrada, TableroMovido).
hacer_movimiento(3, TableroEntrada, TableroMovido) :-
	mover_hueco_arriba(TableroEntrada, TableroMovido).
hacer_movimiento(4, TableroEntrada, TableroMovido) :-
	mover_hueco_abajo(TableroEntrada, TableroMovido).


% Mover el hueco a la izquierda, derecha, arriba o abajo en un tablero
mover_hueco_izquierda([ Fila | RestoFilas], [FilaMovida | RestoFilas] ) :-
    fila_hueco_izquierda(Fila, FilaMovida), !.
mover_hueco_izquierda([ Fila | RestoFilas], [ Fila | FilasMovidas ] ) :-
    mover_hueco_izquierda(RestoFilas, FilasMovidas), !.

mover_hueco_derecha([ Fila | RestoFilas], [FilaMovida | RestoFilas] ) :-
    fila_hueco_derecha(Fila, FilaMovida), !.
mover_hueco_derecha([ Fila | RestoFilas], [ Fila | FilasMovidas ] ) :-
    mover_hueco_derecha(RestoFilas, FilasMovidas), !.

mover_hueco_arriba([ Fila1, Fila2 | RestoFilas], [ FilaMovida1, FilaMovida2 | RestoFilas ] ) :-
    fila_hueco_arriba(Fila1, Fila2, [ FilaMovida1, FilaMovida2 ]), !.
mover_hueco_arriba([ Fila | RestoFilas], [ Fila | FilasMovidas ] ) :-
    mover_hueco_arriba(RestoFilas, FilasMovidas), !.

mover_hueco_abajo([ Fila1, Fila2 | RestoFilas], [ FilaMovida1, FilaMovida2 | RestoFilas ] ) :-
    fila_hueco_abajo(Fila1, Fila2, [ FilaMovida1, FilaMovida2 ]), !.
mover_hueco_abajo([ Fila | RestoFilas], [ Fila | FilasMovidas ] ) :-
    mover_hueco_abajo(RestoFilas, FilasMovidas), !.


% Mover el hueco a la izquierda, derecha, arriba o abajo en una fila
fila_hueco_izquierda([Ficha, ' ' | RestoFila], [' ', Ficha | RestoFila]) :- !.
fila_hueco_izquierda([Ficha | RestoFila], [Ficha | FilaMovida ]) :-
    fila_hueco_izquierda(RestoFila, FilaMovida).

fila_hueco_derecha([' ', Ficha | RestoFila], [Ficha, ' ' | RestoFila]) :- !.
fila_hueco_derecha([Ficha | RestoFila], [Ficha | FilaMovida ]) :-
    fila_hueco_derecha(RestoFila, FilaMovida).

% Mover el hueco arriba o abajo afecta a dos filas
fila_hueco_arriba([Ficha1 | RestoFila1], [' ' | RestoFila2],
                 [ [' ' | RestoFila1], [Ficha1 | RestoFila2] ]) :- !.
fila_hueco_arriba([Ficha1 | RestoFila1], [Ficha2 | RestoFila2],
                 [ [ Ficha1 | FilaMovida1 ], [Ficha2 | FilaMovida2] ]) :-
    fila_hueco_arriba(RestoFila1, RestoFila2, [ FilaMovida1, FilaMovida2 ] ).

fila_hueco_abajo([' ' | RestoFila1], [Ficha2 | RestoFila2],
                 [ [Ficha2 | RestoFila1], [' ' | RestoFila2] ]) :- !.
fila_hueco_abajo([Ficha1 | RestoFila1], [Ficha2 | RestoFila2],
                 [ [ Ficha1 | FilaMovida1 ], [Ficha2 | FilaMovida2] ]) :-
    fila_hueco_abajo(RestoFila1, RestoFila2, [ FilaMovida1, FilaMovida2 ] ).

