:- encoding(utf8).
% Tic-tac-toe (gato) with minimax, in Prolog (SWI-Prolog).
% Run:  swipl gato.pl
%       ?- game.
% You play x and move first. Type a cell and a dot, e.g.  4.
%     0 1 2
%     3 4 5
%     6 7 8

% ---------- Winning lines: rows, columns, diagonals ----------
line(0,1,2). line(3,4,5). line(6,7,8).
line(0,3,6). line(1,4,7). line(2,5,8).
line(0,4,8). line(2,4,6).

winner(Board, P) :-
    line(A, B, C),
    nth0(A, Board, P), P \== e,
    nth0(B, Board, P), nth0(C, Board, P).

% ---------- Moves ----------
moves(Board, Moves) :-
    findall(I, nth0(I, Board, e), Moves).

play(Board, I, P, NewBoard) :-
    nth0(I, Board, e, Rest),       % remove e
    nth0(I, NewBoard, P, Rest).    % insert P

% ---------- Turn, terminal test and utility ----------
to_move(Board, P) :-
    count(x, Board, NX), count(o, Board, NO),
    ( NX =:= NO -> P = x ; P = o ).

count(P, Board, N) :-
    include(==(P), Board, L), length(L, N).

terminal(Board) :- winner(Board, _), !.
terminal(Board) :- \+ memberchk(e, Board).

utility(Board, U) :-
    (   winner(Board, x) -> U = 1
    ;   winner(Board, o) -> U = -1
    ;   U = 0
    ).

% ---------- Minimax: x is MAX, o is MIN ----------
:- table minimax/3.

minimax(Board, Val, Best) :-
    (   terminal(Board)
    ->  utility(Board, Val), Best = none
    ;   to_move(Board, P),
        moves(Board, Moves),
        findall(V-I,
                ( member(I, Moves),
                  play(Board, I, P, B2),
                  minimax(B2, V, _) ),
                Pairs),
        best(P, Pairs, Val-Best)
    ).

best(x, Pairs, Best) :-
    max_member(Best, Pairs).
best(o, Pairs, Best) :-
    min_member(Best, Pairs).

% ---------- Playing against the agent ----------
show(Board) :-
    forall(member(Row, [[0,1,2],[3,4,5],[6,7,8]]),
           ( maplist(cell(Board), Row, Cs),
             format("~w ~w ~w~n", Cs) )),
    nl.

cell(Board, I, C) :-
    nth0(I, Board, X),
    ( X == e -> C = '-' ; C = X ).

game :- turn([e,e,e,e,e,e,e,e,e]).

turn(Board) :-
    terminal(Board), !,
    show(Board), utility(Board, U), result(U).
turn(Board) :-
    show(Board), to_move(Board, P),
    choose(P, Board, I),
    play(Board, I, P, Board2),
    turn(Board2).

choose(x, Board, I) :-             % you
    repeat,
      write('Move (0-8): '), read(I),
      moves(Board, Ms),
      (   memberchk(I, Ms) -> !
      ;   writeln('Not a legal move'), fail
      ).
choose(o, Board, I) :-             % the agent
    minimax(Board, _, I),
    format("Agent plays ~w~n", [I]).

result(1)  :- writeln('X wins').
result(-1) :- writeln('O wins').
result(0)  :- writeln('Draw').
