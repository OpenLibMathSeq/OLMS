def check(lhs, rhs, len):
    try:
        L = [lhs(n) for n in range(len)]
    except TypeError:
        L = [lhs.next() for _ in range(len)]

    try:
        R = [rhs(n) for n in range(len)]
    except TypeError:
        R = [rhs.next() for _ in range(len)]

    if L != R:
        print "Error"
        print L
        print R
    else:
        print R

def check2(lhs, rhs, len):
    for n in range(len):
        try:
            L = [lhs(n, k) for k in (0..n)]
        except TypeError:
            L = lhs.next()

        try:
            R = [rhs(n, k) for k in (0..n)]
        except TypeError:
            R = rhs.next()

        if L != R:
            print "Error"
            print L
            print R
        else:
            print R

def square():
    for n in NonNegativeIntegers():
        yield n * n

def fact():
    f = 1
    for n in PositiveIntegers():
        yield f
        f *= n

def Binomial(n, k):
    if n == k: return 1
    return binomial(n,k)
