"""Construct and replay the short exit phases without scanning a seed interval."""
import json


TWO_BLOCKS = (1, 1, 1, 2, 2, 1, 1, 1, 2, 1)
ROWS = {
    3: (18, 32, 65, 102, 48703904041268437968961386239215, 82408411687020299631788378142744),
    5: (10, 128, 66, 104, 21076350839635022295760718777647, 247225235061060898895365134428232),
}


def valuation(value):
    assert value > 0
    return (value & -value).bit_length() - 1


def accumulate(book, power):
    returns, divisions, additive = book
    return returns + 1, divisions + power, 3 * additive + (1 << divisions)


def affine_class(row, word, followed_by):
    _, _, _, _, intercept, slope = ROWS[row]
    returns, divisions, additive = (0, 0, 0)
    for power in word:
        returns, divisions, additive = accumulate((returns, divisions, additive), power)
    precision = 1 << (divisions + followed_by + 2)
    terminal = (1 << (followed_by + 1)) - 1
    required = (((1 << divisions) * terminal - additive) * pow(pow(3, returns), -1, precision)) % precision
    assert valuation(slope) == 3 and (required - intercept) % 8 == 0
    period = precision // 8
    return ((required - intercept) // 8 * pow(slope // 8, -1, period)) % period, period


def step(x):
    numerator = 3 * x + 1
    power = valuation(numerator)
    return numerator >> power, power


def replay(row, exit_power, length, weak_tail=None):
    cut = TWO_BLOCKS if exit_power == 1 else TWO_BLOCKS + (2,)
    word, terminal_length = cut, length
    if weak_tail is not None:
        word += (1,) * length + (2, weak_tail)
        terminal_length = 2
    t, period = affine_class(row, word, terminal_length)
    intercept, stride, entry_returns, entry_divisions, J0, J1 = ROWS[row]
    u = intercept + stride * t
    N = 1156359581173680383779426258047 + (1 << 100) * u
    value, book = N, (0, 0, 0)
    for _ in range(entry_returns):
        value, power = step(value)
        book = accumulate(book, power)
    assert value == J0 + J1 * t and book[1] == entry_divisions
    J, entry_book = value, book
    assert valuation(J + 1) == 4
    Q = (J + 1) // 16

    values, books = [J], [book]
    for expected in word:
        value, power = step(value)
        assert power == expected
        book = accumulate(book, power)
        values.append(value)
        books.append(book)

    X = values[10]
    Y, c = step(X)
    assert c == exit_power and X > J
    restart = values[len(cut)]
    assert restart == (X if c == 1 else Y)
    assert valuation(restart + 1) == length + 1
    q = (restart + 1) >> (length + 1)
    assert q % 2 == 1 and (q < Q) == (length >= 6) and (q > Q) == (length <= 5)
    assert (X % (128 if c == 1 else 512) == (127 if c == 1 else 169)) == (length >= 6)
    if c == 1:
        assert 512 * (X + 1) == 59049 * Q + 2085
    else:
        assert J < Y < X and 2048 * (Y + 1) == 177147 * Q + 7279
    returns, divisions, additive = books[-1]
    assert values[-1] * (1 << divisions) == pow(3, returns) * N + additive
    return {"row": row, "exit": c, "t": t, "modulus": period, "u": u, "N": N,
            "entry": J, "entry_book": entry_book, "macro_end": X, "after_exit": Y,
            "next_ones": length, "initial_cofactor": Q, "reentry_cofactor": q,
            "weak_tail": weak_tail, "old_height_exceeded": restart > J,
            "rank_decreases": q < Q, "reentry_book": books[len(cut)], "checked_book": books[-1]}


def replay_two_edges(row, c, total):
    e = total - c
    word = TWO_BLOCKS + (c, e)
    t, modulus = affine_class(row, word, 2)
    u0, stride, entry_returns, entry_divisions, j0, j1 = ROWS[row]
    u = u0 + stride * t
    N = 1156359581173680383779426258047 + (1 << 100) * u
    current, book = N, (0, 0, 0)
    for _ in range(entry_returns):
        current, power = step(current)
        book = accumulate(book, power)
    assert current == j0 + j1 * t and book[1] == entry_divisions
    J = current
    slope = stride * (1 << 100)
    seed_at_zero = 1156359581173680383779426258047 + (1 << 100) * u0
    if row == 3:
        assert 2 * seed_at_zero < j0 and 2 * slope < j1
        assert 2 * j0 < 5 * seed_at_zero and 2 * j1 < 5 * slope
    else:
        assert seed_at_zero < j0 and slope < j1
        assert 4 * j0 < 7 * seed_at_zero and 4 * j1 < 7 * slope
    for expected in word:
        current, power = step(current)
        assert power == expected
        book = accumulate(book, power)
    assert valuation(current + 1) == 3
    local_cost = 782529 + (1 << (13 + c))
    assert current * (1 << (13 + total)) == 531441 * J + local_cost
    returns, divisions, additive = book
    assert current * (1 << divisions) == pow(3, returns) * N + additive
    threshold = 8 if row == 3 else 7
    assert (current < N) == (threshold <= total)
    if total < threshold:
        assert N < current
    return {"row": row, "t": t, "modulus": modulus, "u": u, "N": N,
            "valuations": (c, e), "terminal": current, "descends": current < N,
            "book": book}

def main():
    witnesses = []
    for row in ROWS:
        for c in (1, 2):
            witnesses.append(replay(row, c, 1 if c == 1 else 0))
            for length in (5, 6):
                witnesses.append(replay(row, c, length, weak_tail=c))
    two_edges = [replay_two_edges(row, c, total)
                 for row, cutoff in ((3, 8), (5, 7))
                 for c in (1, 2) for total in (cutoff - 1, cutoff)]
    print(json.dumps({"status": "PASS", "reentries": witnesses, "two_edges": two_edges}, indent=2))


if __name__ == "__main__":
    main()
