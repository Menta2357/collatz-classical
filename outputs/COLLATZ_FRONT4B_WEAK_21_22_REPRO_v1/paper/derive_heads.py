"""Replay each affine head, reconstruct its forcing phase, and print Lean data."""
from sys import argv


HEADS = {
    'six': ((2,1,6),(2,1,1,2,1)),
    'twoSix': ((2,1,2,6),(2,1,1,1,3,1)),
    'threeSix': ((2,1,3,6),(2,1,1,3,2,1)),
    'fourFour': ((2,1,4,4),(2,1,1,2,2,1)),
    'oneEight': ((2,1,1,8),(2,1,2,1,3,1)),
    'five': ((2,1,5),(2,1,1,2)),
    'fourThree': ((2,1,4,3),(2,1,1,2,2)),
    'twoFive': ((2,1,2,5),(2,1,1,1,3)),
}
ADAPTIVE = {'five', 'fourThree', 'twoFive'}


def require(condition, detail):
    if not condition:
        raise RuntimeError(detail)


def record(word):
    spent = cost = 0
    for valuation in word:
        cost = 3*cost + 2**spent
        spent += valuation
    return len(word), spent, cost


def physical(start, slope, word):
    tape = []
    for valuation in word:
        d = 2**valuation
        scaled = 3*start+1
        require(scaled % (2*d) == d and (3*slope) % (2*d) == 0, 'Invalid exact affine edge')
        start, slope = scaled//d, 3*slope//d
        tape.append((valuation, start, slope))
    return tape


def main(lean):
    data = {}
    for name, (original, auxiliary) in HEADS.items():
        h, s, cost = record(original)
        modulus = 2**(s+1)
        offset = (2**s - cost - 8*3**h) * pow(3**(h+2), -1, modulus) % modulus
        orig = physical(9*offset+8, 9*modulus, original)
        aux = physical(offset, modulus, auxiliary)
        _, ob, os = orig[-1]
        _, ab, ass = aux[-1]
        if name in ADAPTIVE:
            require(3*(ab+1)==4*(ob+1) and 3*ass==4*os, f'Adaptive identity: {name}')
        else:
            require(ab==4*ob+1 and ass==4*os, f'Fixed identity: {name}')
        data[name] = (offset, modulus, orig, aux)
    if lean:
        print('inductive Tail where\n  | '+' | '.join(HEADS)+'\n  deriving DecidableEq\n')
        print('def sourceStart : Tail → Affine')
        for name,(offset,modulus,_,_) in data.items():
            print(f'  | .{name} => ⟨{offset},{modulus}⟩')
        for kind,index in (('originalWord',2), ('sourceWord',3)):
            print(f'\ndef {kind} : Tail → Word')
            for name, row in data.items():
                writ = ','.join(f'({v},⟨{b},{s}⟩)' for v,b,s in row[index])
                print(f'  | .{name} => [{writ}]')
        print('\n-- Cases for phaseOfHead')
        for name,(offset,modulus,orig,_) in data.items():
            _,ob,os=orig[-1]
            h,s,cost=record(HEADS[name][0])
            print(f'''  | {name} =>
    change {2**s}*Z={3**h}*(9*U+8)+{cost} at book
    refine ⟨U/{modulus},?_⟩
    change U={offset}+{modulus}*(U/{modulus}) ∧ Z={ob}+{os}*(U/{modulus})
    omega''')
    else:
        print(f'PASS: {len(data)} exact affine pairs ({len(ADAPTIVE)} adaptive), relation verified symbolically')


if __name__ == '__main__':
    main(argv[1:] == ['--lean'])
