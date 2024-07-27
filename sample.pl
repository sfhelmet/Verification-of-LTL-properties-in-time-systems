% Define variable facts
var(1, temp, 12).
var(2, temp, 13).
var(3, temp, 0).
var(4, temp, 12).
var(5, temp, 100).

var(1, threshold, 100).
var(2, threshold, 100).
var(3, threshold, 100).
var(4, threshold, 100).
var(5, threshold, 100).

% Define state facts
state(1, 'Idle').
state(2, 'Idle').
state(3, 'Reading').
state(4, 'Reading').
state(5, 'Error').

global(TID, E) :- 
    py_call(query_engine:'execute_global'(TID, E), Res), 
    write(Res).

