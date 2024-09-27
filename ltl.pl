initialize() :-
    py_func(query_engine, set_max_time_id(), _).

set_timeid(TID) :-
    py_func(query_engine, set_time_id(TID), _).

get_timeid() :-
    py_func(query_engine, get_time_id(), Res),
    write(Res).

increment_timeid() :-
    py_func(query_engine, increment_time_id(), _).

decrement_timeid() :-
    py_func(query_engine, decrement_time_id(), _).

global(Expr) :-
    term_string(Expr, String), atom_string(Atom, String),
    py_func(query_engine, execute_global(Atom), Res),
    Res == 'True'.


future(Expr) :-
    term_string(Expr, String), atom_string(Atom, String),
    py_func(query_engine, execute_finally(Atom), Res),
    Res == 'True'.

finally(Expr) :-
    future(Expr).

next(Expr) :-
    term_string(Expr, String), atom_string(Atom, String),
    py_func(query_engine, execute_next(Atom), Res),
    Res == 'True'.

release(Expr1, Expr2) :-
    term_string(Expr1, String1), atom_string(Atom1, String1),
    term_string(Expr2, String2), atom_string(Atom2, String2),
    py_func(query_engine, execute_release(Atom1, Atom2), Res),
    Res == 'True'.

until(Expr1, Expr2) :-
    term_string(Expr1, String1), atom_string(Atom1, String1),
    term_string(Expr2, String2), atom_string(Atom2, String2),
    py_func(query_engine, execute_until(Atom1, Atom2), Res),
    Res == 'True'.

weak_until(Expr1, Expr2) :-
    term_string(Expr1, String1), atom_string(Atom1, String1),
    term_string(Expr2, String2), atom_string(Atom2, String2),
    py_func(query_engine, execute_weak_until(Atom1, Atom2), Res),
    Res == 'True'.

strong_release(Expr1, Expr2) :-
    term_string(Expr1, String1), atom_string(Atom1, String1),
    term_string(Expr2, String2), atom_string(Atom2, String2),
    py_func(query_engine, execute_strong_release(Atom1, Atom2), Res),
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
