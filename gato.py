"""Tic-tac-toe (gato) with minimax, in Python.

Run:  python3 gato.py
You play X and move first. Cells are numbered 0..8:
    0 1 2
    3 4 5
    6 7 8
"""
from functools import lru_cache

# ---------- Winning lines: rows, columns, diagonals ----------
LINES = [(0, 1, 2), (3, 4, 5), (6, 7, 8),
         (0, 3, 6), (1, 4, 7), (2, 5, 8),
         (0, 4, 8), (2, 4, 6)]


def winner(board):
    for a, b, c in LINES:
        trio = board[a] + board[b] + board[c]
        if trio in ("xxx", "ooo"):
            return trio[0]
    return None


# ---------- Moves ----------
def moves(board):
    return [i for i in range(9)
            if board[i] == "-"]


def play(board, i, player):
    return board[:i] + player + board[i + 1:]


# ---------- Turn, terminal test and utility ----------
def to_move(board):
    x, o = board.count("x"), board.count("o")
    return "x" if x == o else "o"


def terminal(board):
    return (winner(board) is not None
            or "-" not in board)


def utility(board):
    scores = {"x": 1, "o": -1, None: 0}
    return scores[winner(board)]


# ---------- Minimax: X is MAX, O is MIN ----------
@lru_cache(maxsize=None)
def minimax(board):
    """Return (value, best_move)."""
    if terminal(board):
        return utility(board), None
    player = to_move(board)
    pairs = []
    for i in moves(board):
        child = play(board, i, player)
        pairs.append((minimax(child)[0], i))
    if player == "x":
        return max(pairs)
    return min(pairs)


# ---------- Playing against the agent ----------
RESULT = {1: "X wins", -1: "O wins", 0: "Draw"}


def show(board):
    for r in (0, 3, 6):
        print(" ".join(board[r:r + 3]))
    print()


def game():
    board = "-" * 9
    while not terminal(board):
        show(board)
        player = to_move(board)
        if player == "x":                # you
            i = int(input("Move (0-8): "))
            if i not in moves(board):
                print("Not a legal move")
                continue
        else:                            # the agent
            _, i = minimax(board)
            print(f"Agent plays {i}")
        board = play(board, i, player)
    show(board)
    print(RESULT[utility(board)])


if __name__ == "__main__":
    game()
