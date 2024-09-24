initialize() :-
    py_func(query_engine, set_max_time_id(), _).

set_timeid(TID) :-
    py_func(query_engine, set_time_id(TID), _).
% Create set/get increment/decrement functions for time id

global(TID, E) :-
    term_string(E, S), atom_string(A, S),
    py_func(query_engine, execute_global(TID, A), Res),
    Res == 'True'.


future(TID, E) :-
    term_string(E, S), atom_string(A, S),
    py_func(query_engine, execute_finally(TID, A), Res),
    Res == 'True'.

next(TID, E) :-
    term_string(E, S), atom_string(A, S),
    py_func(query_engine, execute_next(TID, A), Res),
    Res == 'True'.

release(TID, E1, E2) :-
    term_string(E1, S1), atom_string(A1, S1),
    term_string(E2, S2), atom_string(A2, S2),
    py_func(query_engine, execute_release(TID, A1, A2), Res),
    Res == 'True'.

release(E1, E2) :-
    release(1, E1, E2).

until(TID, E1, E2) :-
    term_string(E1, S1), atom_string(A1, S1),
    term_string(E2, S2), atom_string(A2, S2),
    py_func(query_engine, execute_until(TID, A1, A2), Res),
    Res == 'True'.

weak_until(TID, E1, E2) :-
    term_string(E1, S1), atom_string(A1, S1),
    term_string(E2, S2), atom_string(A2, S2),
    py_func(query_engine, execute_weak_until(TID, A1, A2), Res),
    Res == 'True'.

strong_release(TID, E1, E2) :-
    term_string(E1, S1), atom_string(A1, S1),
    term_string(E2, S2), atom_string(A2, S2),
    py_func(query_engine, execute_strong_release(TID, A1, A2), Res),
    Res == 'True'.

% all(E) :-

print_nested(Term) :-
    term_to_nested(Term, Nested),
    % term_to_atom(Nested, Atom),
    py_call(query_engine:'print_nested'(Nested), Res).

term_to_nested(Term, Nested) :-
    (   atomic(Term) ->
        Nested = Term
    ;   Term =.. [Functor | Args],
        maplist(term_to_nested, Args, NestedArgs),
        Nested = [Functor | NestedArgs]
    ).
