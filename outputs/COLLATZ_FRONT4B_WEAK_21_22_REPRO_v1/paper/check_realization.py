"""Construct physical witnesses in each original Front4b row by congruence."""
from derive_heads import ADAPTIVE, HEADS, physical, record, require


ROWS = (
    (18,32,65,48703904041268437968961386239215,82408411687020299631788378142744),
    (10,128,66,21076350839635022295760718777647,247225235061060898895365134428232),
)
SEED = 1156359581173680383779426258047


def step(x):
    numerator = 3*x+1
    valuation = (numerator & -numerator).bit_length()-1
    return numerator >> valuation, valuation


def orbit(x, count):
    word = []
    for _ in range(count):
        x, valuation = step(x)
        word.append(valuation)
    return x, tuple(word)


def main():
    checks = 0
    for row in ROWS:
        u0, us, absolute, j0, js = row
        require(j0%8==7 and js%16==8, 'Original row coefficient')
        for name, (head, auxiliary) in HEADS.items():
            h, s, c = record(head)
            modulus = 2**(s+1)
            uf = ((2**s-c-8*3**h)*pow(3**(h+2), -1, modulus)) % modulus
            _, P0, PS = physical(9*uf+8, 9*modulus, head)[-1]
            trailing_runs = (0,4,19) if name in ADAPTIVE else (None,)
            for L in (2,5,27):
                for r in trailing_runs:
                    u_residue, u_modulus = uf, modulus
                    if r is not None:
                        q0 = 3*pow(3**(r+1), -1, 4) % 4
                        t_mod = 2**(r+2)
                        t_residue = ((2**r*q0-(P0+1)//2)*pow(PS//2, -1, t_mod)) % t_mod
                        u_residue += modulus*t_residue
                        u_modulus *= t_mod
                    q_mod = u_modulus//2
                    q_res = ((u_residue+1)//2)*pow(3**(L-2), -1, q_mod) % q_mod
                    j_mod = 2**(L-2)*q_mod
                    row_parameter = (2**(L-2)*q_res-(j0+1)//8)*pow(js//8, -1, j_mod) % j_mod
                    u = u0+us*row_parameter
                    N = SEED+2**100*u
                    J = j0+js*row_parameter
                    require(orbit(N,absolute)[0] == J, 'Exact original physical prefix')
                    w = (J-3)//4
                    require(J%4==3 and 0<w<N and w%2==1, 'Paid source from original seed')
                    orig_tail, aux_tail = head, auxiliary
                    if r is not None:
                        orig_tail += (1,)*r+(2,)
                        aux_tail += (1,)*(r+2)
                    prefix_orig, prefix_aux = (1,)*L+orig_tail, (1,)*(L-2)+aux_tail
                    Z, actual_orig = orbit(J, len(prefix_orig))
                    W, actual_aux = orbit(w, len(prefix_aux))
                    require(prefix_orig == actual_orig and prefix_aux == actual_aux, 'Exact valuation words')
                    end, gamma = step(Z)
                    require(W==4*Z+1 and step(W)==(end,gamma+2), 'Physical paid meeting')
                    checks += 1
    print(f'PASS: {checks} constructed guards in both original Front4b rows, keeping the same seed and valuation words')


if __name__ == '__main__':
    main()
