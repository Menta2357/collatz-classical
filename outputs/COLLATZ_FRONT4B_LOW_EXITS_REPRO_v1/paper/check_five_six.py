"""Replay the three new exit cylinders and their exact affine prices."""

N0 = 1156359581173680383779426258047
ROWS = (
    (3,18,32,65,48703904041268437968961386239215,82408411687020299631788378142744, (5,6)),
    (5,10,128,66,21076350839635022295760718777647,247225235061060898895365134428232, (5,)),
)
PREFIX = (1,1,1,2,2,1,1,1,2,1)
EXPECTED = {(3,5):(1976,65536),(3,6):(34744,131072),(5,5):(10016,65536)}


def require(condition, detail):
    if not condition:
        raise RuntimeError(detail)


def book(word):
    s=b=0
    for a in word:
        b,s=3*b+2**s,s+a
    return s,b


def walk(x,m):
    word=[]
    for _ in range(m):
        y=3*x+1
        a=(y&-y).bit_length()-1
        x=y>>a
        word.append(a)
    return x,tuple(word)


def main():
    count=0
    for row,u0,du,clock,j0,js,exits in ROWS:
        n0,ns=N0+2**100*u0,2**100*du
        for c in exits:
            head=PREFIX+(c,)
            s,B=book(head)
            D,A=2**s,3**len(head)
            modulus=2*D
            residue=((D-B)*pow(A,-1,modulus))%modulus
            require((residue-j0)%8==0 and js%16==8,'Affine dyadic phase')
            stride=modulus//8
            t0=((residue-j0)//8*pow(js//8,-1,stride))%stride
            require((t0,stride)==EXPECTED[row,c],'Exact exit cylinder')
            if c==5:
                require(2*(A*j0+B)<D*(3*n0+1) and 2*A*js<3*D*ns,'Strict capture price')
                require(D*n0<A*j0+B and D*ns<A*js,'This terminal remains above the seed')
            else:
                require(A*j0+B<D*n0 and A*js<D*ns,'Strict descent price')
            for t in (t0,t0+stride,t0+113*stride):
                N,J=n0+ns*t,j0+js*t
                require(walk(N,clock)[0]==J,'Original history')
                Y,word=walk(J,len(head))
                require(word==head and D*Y==A*J+B,'True valuations and original additive')
                if c==5:
                    w=(2*Y-1)//3
                    require(Y>N and w%2==1 and 0<w<N and 3*w+1==2*Y,'Physical paid source')
                else:
                    require(Y<N,'Strict descent')
                count+=1
    print(f'PASS: {count} exact physical traces across three affine exit cylinders')


if __name__=='__main__':
    main()
