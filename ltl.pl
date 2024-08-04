initialize() :-
    py_func(query_engine, set_max_time_id(), _).

global(E) :- 
    term_string(E, S),
    py_func(query_engine, execute_global(S), Res), 
    Res == 'True'.

future(E) :-
    term_string(E, S),
    py_func(query_engine, execute_finally(S), Res),
    Res == 'True'.

next(TID, E) :-
    term_string(E, S), atom_string(A, S),
    py_call(query_engine:'execute_next'(TID, A), Res),
    Res == 'True'.

% all(E) :-
