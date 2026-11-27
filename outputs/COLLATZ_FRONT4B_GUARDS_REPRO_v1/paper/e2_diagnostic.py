"""Bounded diagnostic for cheap exact affine meetings after the e2 terminals."""
from collections import Counter

N0 = 1156359581173680383779426258047
NS = 2**100
V0 = 1392102202856011511751362094175
VS = 4*3**62
CASES = ((3,34,64,(1,1,2,1,2)),(5,202,256,(1,1,2,2,1,2)),
         (7,938,1024,(1,1,2,2,2,1,2)))


def factor(y):
    value=3*y+1
    return (value & -value).bit_length()-1


def forward(point):
    a,b=point
    e=factor(a)
    if 3*b % (2**(e+1)):
        return None
    return ((3*a+1)>>e,3*b>>e),e


def below(x,n):
    return x[0]<n[0] and x[1]<=n[1]


def paid(point,n,depth=8,valmax=6):
    seen={point}
    todo={point:()}
    for _ in range(depth):
        next_level={}
        for (a,b), previous in todo.items():
            if a%3==0 or b%3:
                continue
            for e in range(1 if a%3==2 else 2,valmax+1,2):
                source=((2**e*a-1)//3,2**e*b//3)
                if source in seen:
                    continue
                if below(source,n):
                    return source,(e,*previous)
                seen.add(source)
                next_level[source]=(e,*previous)
        todo=next_level
    return None


def main():
    for c,r,m,word in CASES:
        known=[]
        missing=[]
        tally=Counter()
        for rr in range(128):
            u=r+m*rr
            n=(N0+NS*u,NS*m*128)
            y=(V0+VS*u,VS*m*128)
            for e in word:
                y,actual=forward(y)
                assert e==actual
            more=[]
            paid_word=None
            for _ in range(8):
                if below(y,n):
                    path='descent',tuple(more)
                    break
                found=paid(y,n)
                if found:
                    path='payment',tuple(more),found[1]
                    paid_word=found[0]
                    break
                result=forward(y)
                if result is None:
                    path='cut',tuple(more)
                    break
                y,a=result
                more.append(a)
            else:
                path='horizon',tuple(more)
            tally[path[0]]+=1
            if path[0]=='payment':
                known.append((rr,path,paid_word))
            if path[0]=='cut':
                missing.append((rr,path,y[0]%16))
        print('c=', c, dict(tally))
        print('pay representatives',[(rr,path) for rr,path,_ in known[:16]])
        print('cut representatives',missing[:8])


if __name__=='__main__':
    main()
