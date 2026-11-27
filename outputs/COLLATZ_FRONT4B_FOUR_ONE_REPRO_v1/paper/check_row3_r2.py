"""Exact directed reproduction of the odd-rupture reserve-two cylinder."""

N0 = 1156359581173680383779426258047
U0 = 7308983964186331826684671241969942827
US = 65692813073042632584925871202837021156


def require(condition, note):
    if not condition:
        raise RuntimeError(note)


def orbit(x,n):
    vals=[]
    states=[x]
    for _ in range(n):
        d=3*x+1
        a=(d&-d).bit_length()-1
        x=d>>a
        vals.append(a)
        states.append(x)
    return x,tuple(vals),states


def book(word):
    s=B=0
    for a in word:
        B,s=3*B+2**s,s+a
    return s,B


def cylinder(word):
    s,B=book(word)
    d,A=2**s,3**len(word)
    mod=2*d
    residue=((d-B)*pow(A,-1,mod))%mod
    require((residue-U0)%4==0 and US%8==4,'Certified dyadic starting cylinder')
    step=mod//4
    k=((residue-U0)//4*pow(US//4,-1,step))%step
    return k,step


def test(word,mode):
    k,step=cylinder(word)
    for t in (k,k+step,k+17*step):
        N=N0+2**100*(3733266+33554432*t)
        V,_,_=orbit(N,62)
        U,path,fromV=orbit(V,16)
        require(U==U0+US*t and path==(1,1,2,1,1,1,2,2,1,1,1,2,1,4,2,2),'Exact prefix')
        require(N<V<U<2*N+1 and (3*U+1)%4==2,'Historical price and compulsory one')
        Y,actual,states=orbit(U,len(word))
        require(actual==word,'Real valuation word')
        if mode=='cross':
            require(N<Y<V and all(x>=V for x in fromV+states[:-1]),'First crossing at exact terminal')
        elif mode=='crossU':
            require(N<V<Y<U and all(x>=U for x in states[:-1]),'First crossing under the newer checkpoint')
        elif mode=='land':
            require(N<Y<2*N+1,'Ambient window')
        elif mode=='descend':
            require(Y<N,'Immediate descent')
        else:
            if mode=='half':
                w=(U-1)//2
                source=(1,)*(len(word)-2)+(2,word[-1]-2)
            elif mode=='one':
                w=(2*Y-1)//3
                source=(1,)
            else:
                w=(4*(Y+1))//9-1
                source=(1,1)
            require(w%2==1 and 0<w<N,'Paid against the same original seed')
            z,aux,_=orbit(w,len(source))
            require(z==Y and aux==source,'Distinct physical source book')
    return k,step


def main():
    cases=[((1,3),'descend'),((1,9),'descend'),((1,2),'land'),((1,2,3),'descend'),((1,2,2),'crossU'),((1,1,3),'half'),
           ((1,)*27+(5,),'half'),((1,)*3+(2,3),'one'),((1,)*4+(2,4),'cross'),
           ((1,)*6+(2,5),'one'),((1,)*7+(2,5),'two')]
    for w,mode in cases:
        k,d=test(w,mode)
        print(f'{w}: k={k} mod {d}, {mode}')
    print(f'PASS: {3*len(cases)} directed exact original traces')


if __name__=='__main__':
    main()
