"""Directed exact checks of mixed words, shift optimality and the reset phase."""


def require(condition, detail):
    if not condition:
        raise RuntimeError(detail)


def ledger(word):
    r, s, cost = 0, 0, 0
    for value in word:
        cost = 3*cost + 2**s
        r, s = r+1, s+value
    return 3**r, 2**s, cost


def walk(x, word):
    for value in word:
        d = 2**value
        num = 3*x+1
        require(num % (2*d) == d, 'Actual terminal valuation')
        x = num//d
    return x


def run_path(episodes):
    word = tuple(v for l,b in episodes for v in (1,)*l+(2,b))
    a, d, cost = ledger(word)
    # Pin a length-two reentry beyond the chosen finite path as well.
    J = ((7*d-cost)*pow(a, -1, 16*d))%(16*d)
    current = J
    for l,b in episodes:
        local_word = (1,)*l+(2,b)
        nxt = walk(current, local_word)
        x,y=17*current+73,17*nxt+73
        A,D,B=ledger(local_word)
        require(D*y <= A*x and ((D*y==A*x) == (l==2 and b==2)), 'Optimal local shift')
        if l==2 and b==1:
            require(32*y+2336==81*x, 'Exact reset charge')
            if nxt%16==7:
                require(x%64==32, 'Exact reset phase')
        if l==2 and b==2:
            require(64*y==81*x, 'Zero-charge relay')
        current=nxt
    require(d*current==a*J+cost, 'Composed additive ledger')
    require(d*(17*current+73)<=a*(17*J+73), 'Optimal switched bound')
    require(d*17*(current+1)<a*(17*J+73), 'Strict cofactor bound')


def main():
    require(17*73+73*64==73*81 and 73+4*64>4*81, 'Boundary shift')
    words = [((2,1),), ((2,2),), ((2,1),(3,2)), ((2,2),(4,1),(3,2),(5,2)),
             ((2,1),(2,2),(2,2),(2,1),(2,2),(2,1),(2,1),(2,2))]
    for word in words:
        run_path(word)
    print('PASS: 5 exact directed words, additive ledger, 73/17 bound, and weak reset charges')


if __name__ == '__main__':
    main()
