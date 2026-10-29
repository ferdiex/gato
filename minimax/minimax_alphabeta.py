"""Minimax and alpha-beta pruning in Python.

Two-ply tree from the slides: leaves 3 12 8 | 2 4 6 | 14 5 2
Run:  python3 minimax_alphabeta.py
"""
import math

# ---------- The game tree ----------
TREE = {
    "root": ["a1", "a2", "a3"],
    "a1": ["a11", "a12", "a13"],
    "a2": ["a21", "a22", "a23"],
    "a3": ["a31", "a32", "a33"],
}

# ---------- Utility of the leaves ----------
UTILITY = {"a11": 3, "a12": 12, "a13": 8,
           "a21": 2, "a22": 4, "a23": 6,
           "a31": 14, "a32": 5, "a33": 2}

# ---------- Who moves (every other inner node is MIN) ----------
MAX_TO_MOVE = {"root"}


def children(pos):
    return TREE.get(pos, [])


def leaf_value(pos):
    val = UTILITY[pos]
    print(f"  leaf {pos} = {val}")
    return val


# =========================================================
#  1. MINIMAX
# =========================================================
def minimax(pos):
    """Return (value, best_next_pos)."""
    kids = children(pos)
    if not kids:                          # terminal
        return leaf_value(pos), None
    pairs = [(minimax(k)[0], k) for k in kids]
    if pos in MAX_TO_MOVE:
        return max(pairs, key=lambda p: p[0])
    return min(pairs, key=lambda p: p[0])


# =========================================================
#  2. ALPHA-BETA
#  alpha: the best value MAX can already guarantee
#  beta:  the best value MIN can already guarantee
# =========================================================
def alphabeta_search(pos):
    return alphabeta(pos, -math.inf, math.inf)


def alphabeta(pos, alpha, beta):
    kids = children(pos)
    if not kids:                          # terminal
        return leaf_value(pos), None
    if pos in MAX_TO_MOVE:
        return max_value(kids, alpha, beta)
    return min_value(kids, alpha, beta)


def max_value(kids, alpha, beta):
    v, best = -math.inf, None
    for i, kid in enumerate(kids):
        kid_v, _ = alphabeta(kid, alpha, beta)
        if kid_v > v:
            v, best = kid_v, kid
        if v >= beta:                     # beta cut
            prune(kids[i + 1:])
            return v, best
        alpha = max(alpha, v)
    return v, best


def min_value(kids, alpha, beta):
    v, best = math.inf, None
    for i, kid in enumerate(kids):
        kid_v, _ = alphabeta(kid, alpha, beta)
        if kid_v < v:
            v, best = kid_v, kid
        if v <= alpha:                    # alpha cut
            prune(kids[i + 1:])
            return v, best
        beta = min(beta, v)
    return v, best


def prune(rest):
    """Show the siblings that are never explored."""
    if rest:
        print(f"  prune: skip {rest}")


if __name__ == "__main__":
    print(">>> minimax('root')")
    val, move = minimax("root")
    print(f"Best move: {move}   Value: {val}")
    print()
    print(">>> alphabeta_search('root')")
    val, move = alphabeta_search("root")
    print(f"Best move: {move}   Value: {val}")
