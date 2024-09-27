:- consult(ltl).

test(X) :- X == 10.
test(X) :- X == 20.

% Define variable facts
var(1, temp, 12).
var(2, temp, 13).
var(3, temp, 0).
var(4, temp, 12).
var(5, temp, 100).

var(1, threshold, 99).
var(2, threshold, 101).
var(3, threshold, 102).
var(4, threshold, 103).
var(5, threshold, 104).

% Define state facts
state(1, 'Idle').
state(2, 'Idle').
state(3, 'Reading').
state(4, 'Reading').
state(5, 'Error').
