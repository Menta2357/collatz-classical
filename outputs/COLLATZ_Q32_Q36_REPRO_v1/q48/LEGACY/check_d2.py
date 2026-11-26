"""Directed symbolic verification of the d=2 meeting in Front4b."""

F0, F1 = 71667327748009080469224948461, 2 * 3**60
N0 = 110482433359989887 + 2**58 * (428769801 + 2**31 * 108)
N1 = 2**96
B60 = 253163701604367108480427299121


def require(test, data):
    if not test:
        raise ArithmeticError(data)


def walk(start, word):
    intercept, stride = start
    divisions = additive = 0
    for valuation in word:
        divisor = 2**valuation
        require((3 * intercept + 1) % (2 * divisor) == divisor, (intercept, valuation))
        require((3 * stride) % (2 * divisor) == 0, (stride, valuation))
        intercept, stride = (3 * intercept + 1) // divisor, 3 * stride // divisor
        additive = 3 * additive + 2**divisions
        divisions += valuation
    return (intercept, stride), (len(word), divisions, additive)


def main():
    m, last = 20, 3
    z_modulus = 2**(last + 4)
    z = (2**(last + 3) - 47) * pow(27, -1, z_modulus) % z_modulus
    q = (2 * z + 5) * pow(9**m, -1, 2 * z_modulus) % (2 * z_modulus)
    period = 2**(3 * m + last + 5)
    residue = ((2**(3 * m + 1) * q - F0 - 5) // 2) * pow(F1 // 2, -1, period) % period
    require(z % 64 == 3 and q % 2 == 1 and residue % 8 == 7, (z, q, residue))
    f, n = (F0 + F1 * residue, F1 * period), (N0 + N1 * residue, N1 * period)
    w = ((f[0] - 5) // 2, f[1] // 2)
    require(w[0] % 2 == 1 and w[1] % 2 == 0 and 0 < w[0] < n[0] and w[1] < n[1], w)
    require(2**95 * f[0] == 3**60 * n[0] + B60 and 2**95 * f[1] == 3**60 * n[1], f)
    original_word = (1, 2) * m + (2, 3, last)
    source_word = (1, 2) * (m - 1) + (1, 3, 1, 4, last - 2)
    original, (returns, divisions, cost) = walk(f, original_word)
    auxiliary, auxiliary_book = walk(w, source_word)
    require(original == auxiliary and original[0] > n[0] and original[1] > n[1], original)
    require(cost == 135 * 9**m - 82 * 8**m and auxiliary_book[2] == 135 * 9**m - 41 * 8**m, cost)
    require(27 * 9**20 > 256 * 8**20, m)
    old_book = (60 + returns, 95 + divisions, 3**returns * B60 + 2**95 * cost)
    print('m,e:', (m, last), 's residue/modulus:', (residue, period))
    print('N, w, E:', (n[0], w[0], original[0]))
    print('original/auxiliary books:', old_book, auxiliary_book)
    print('affine margins N-w and E-N:', (n[0] - w[0], n[1] - w[1]), (original[0] - n[0], original[1] - n[1]))
    print('PASS: exact valuations and price throughout the directed affine class')


if __name__ == '__main__':
    main()
