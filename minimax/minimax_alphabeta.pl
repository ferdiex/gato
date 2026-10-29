:- encoding(utf8).
% =========================================================
%  Minimax and alpha-beta pruning in Prolog
%  Two-ply tree from the slides: leaves 3 12 8 | 2 4 6 | 14 5 2
%  Run:  swipl minimax_alphabeta.pl
%        ?- minimax(root, Move, Val).
%        ?- alphabeta_search(root, Move, Val).
% =========================================================

% ---------- The game tree ----------
move(root, a1).  move(root, a2).  move(root, a3).
move(a1, a11).   move(a1, a12).   move(a1, a13).
move(a2, a21).   move(a2, a22).   move(a2, a23).
move(a3, a31).   move(a3, a32).   move(a3, a33).

% ---------- Utility of the leaves ----------
utility(a11, 3).  utility(a12, 12). utility(a13, 8).
utility(a21, 2).  utility(a22, 4).  utility(a23, 6).
utility(a31, 14). utility(a32, 5).  utility(a33, 2).

% ---------- Who moves ----------
max_to_move(root).
min_to_move(a1).  min_to_move(a2).  min_to_move(a3).

% ---------- A leaf: prints which nodes get evaluated ----------
leaf_value(Pos, Val) :-
    utility(Pos, Val),
    format("  leaf ~w = ~w~n", [Pos, Val]).

% =========================================================
%  1. MINIMAX
% =========================================================
minimax(Pos, BestNextPos, Val) :-
    findall(NextPos, move(Pos, NextPos), NextPosList),
    (   NextPosList \= []
    ->  findall(Value-ChildPos,
                ( member(ChildPos, NextPosList),
                  minimax(ChildPos, _, Value) ),
                ValsPosList),
        best(Pos, ValsPosList, Val-BestNextPos)
    ;   leaf_value(Pos, Val),
        BestNextPos = none
    ).

best(Pos, ValsPosList, Best) :-
    (   max_to_move(Pos) -> max_member(Best, ValsPosList)
    ;   min_to_move(Pos) -> min_member(Best, ValsPosList)
    ).

% =========================================================
%  2. ALPHA-BETA
%  Alpha: the best value MAX can already guarantee
%  Beta:  the best value MIN can already guarantee
% =========================================================
alphabeta_search(Pos, Best, Val) :-
    alphabeta(Pos, -1000, 1000, Best, Val).  % -1000/1000 act as -inf/+inf

alphabeta(Pos, Alpha, Beta, Best, Val) :-
    findall(C, move(Pos, C), Children),
    (   Children = []                    % terminal
    ->  leaf_value(Pos, Val), Best = none
    ;   max_to_move(Pos)
    ->  max_value(Children, Alpha, Beta,
                  none, -1000, Best, Val)
    ;   min_value(Children, Alpha, Beta,
                  none, 1000, Best, Val)
    ).

% MAX-VALUE: V and Alpha can only go up
max_value([], _, _, Best, V, Best, V).
max_value([C|Cs], Alpha, Beta, Best0, V0, Best, V) :-
    alphabeta(C, Alpha, Beta, _, CV),
    (   CV > V0 -> V1 = CV, Best1 = C
    ;   V1 = V0,  Best1 = Best0
    ),
    (   V1 >= Beta                       % beta cut
    ->  prune(Cs), Best = Best1, V = V1
    ;   Alpha1 is max(Alpha, V1),
        max_value(Cs, Alpha1, Beta, Best1, V1, Best, V)
    ).

% MIN-VALUE: V and Beta can only go down
min_value([], _, _, Best, V, Best, V).
min_value([C|Cs], Alpha, Beta, Best0, V0, Best, V) :-
    alphabeta(C, Alpha, Beta, _, CV),
    (   CV < V0 -> V1 = CV, Best1 = C
    ;   V1 = V0,  Best1 = Best0
    ),
    (   V1 =< Alpha                      % alpha cut
    ->  prune(Cs), Best = Best1, V = V1
    ;   Beta1 is min(Beta, V1),
        min_value(Cs, Alpha, Beta1, Best1, V1, Best, V)
    ).

% Shows the branches that are never explored
prune([]).
prune(Cs) :- Cs \= [],
    format("  prune: skip ~w~n", [Cs]).
