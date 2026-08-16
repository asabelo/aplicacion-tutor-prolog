choose_operation(Op) :-
    ( Op = add -> call(add, 2, 3);
      Op = multiply -> call(multiply, 2, 3) ).
