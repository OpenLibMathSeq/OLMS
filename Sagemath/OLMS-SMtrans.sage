hypergeom = lambda a,b,x: hypergeometric(a,b,x).simplify_hypergeometric()

def coefficient_list(p, x, exponential = false) :
    c = 0
    L = []
    R = p.expand().coefficients(x)
    for r in R :
        while r[1] != c :
            L.append(0)
            c = c + 1
        if exponential:
            L.append(factorial(c)*r[0])
        else:
            L.append(r[0])
        c = c + 1
    return L

def OGF(ogf, n):
    f = taylor(ogf, x, 0, n)
    return coefficient_list(f, x, false)

def EGF(egf, n):
    f = taylor(egf, t, 0, n)
    return coefficient_list(f, t, true)

def partial_sum(seq):
    """
    Input : seq sequence generator
    """
    s = seq.next()
    yield s
    while True:
        s += seq.next()
        yield s

def alternating_sign(seq):
    e = False
    while True:
        e = not e
        if e:
            yield seq.next()
        else:
            yield -seq.next()

def alternating_sum(seq):
    """
    Input : seq sequence generator
    """
    s = seq.next()
    e = True
    yield s
    while True:
        e = not e
        if e:
            s += seq.next()
        else:
            s -= seq.next()
        yield s

def partial_prod(seq):
    """
    Input : seq sequence generator
    """
    s = seq.next()
    yield s
    while True:
        s *= seq.next()
        yield s

def first_difference(seq):
    """
    Input : seq sequence generator
    """
    b = seq.next()
    while True:
        a = seq.next()
        yield a - b
        b = a

def binomial_gen():
    #     """
    #     Input : seq sequence generator
    #     """
    B = [1]
    n = 0
    while True:
        yield B
        n += 1
        B.append(0)
        for j in (1..n):
            B[-j] += B[-j-1]


def binomial_trans(seq):
    """
    Input : seq sequence generator
    """
    B = binomial_gen()
    S = []
    n = 0

    while True:
        S.append(seq.next())
        b = B.next()
        yield sum(b[k] * S[k] for k in (0..n))
        n += 1

def binomial_invtrans(seq):
    """
    Input : seq sequence generator
    """
    B = binomial_gen()
    S = []
    n = 0

    while True:
        S.append(seq.next())
        b = B.next()
        yield sum((-1)^(n - k) * b[k] * S[k] for k in (0..n))
        n += 1

def lah_trans(seq):
    """
    Input : seq sequence generator
    """
    L = lah_gen()
    S = []
    n = 0

    while True:
        S.append(seq.next())
        l = L.next()
        yield sum(l[k] * S[k] for k in (0..n))
        n += 1

def lah_invtrans(seq):
    """
    Input : seq sequence generator
    """
    L = lah_gen()
    S = []
    n = 0

    while True:
        S.append(seq.next())
        l = L.next()
        yield sum((-1)^(n-k) * l[k] * S[k] for k in (0..n))
        n += 1

def convolution(seqA, seqB):
    A, B = [], []
    n = 0
    while True:
        A.append(seqA.next())
        B.append(seqB.next())
        # convolution(A, B)
        yield sum(A[k] * B[n - k] for k in (0..n))
        n += 1

def self_convolution(seq):
    A = []
    n = 0
    while True:
        A.append(seq.next())
        yield sum(A[k] * A[n - k] for k in (0..n))
        n += 1

def oddpart(seq):
    while True:
        yield odd_part(seq.next())

def evenpart(seq):
    while True:
        n = seq.next()
        if n == 0:
            yield 1
        else:
            yield n//odd_part(n)

def count(start):
    n = start
    while True:
        yield n
        n += 1

def const(val):
    while True:
        yield val

def const_alter(val):
    while True:
        yield val
        val = -val

def riordan_array(d, h, n, exp=false):

    def taylor_list(f, n):
        t = SR(f).taylor(x, 0, n-1).list()
        return t + [0]*(n-len(t))

    td = taylor_list(d, n)
    th = taylor_list(h, n)
    M = matrix(QQ, n, n)

    for k in (0..n-1): M[k, 0] = td[k]

    for k in (1..n-1):
        for m in (k..n-1):
            M[m, k] = add(M[j, k-1]*th[m-j] for j in (k-1..m-1))

    if exp:
        u = 1
        for k in (1..n-1):
            u *= k
            for m in (0..k):
                j = u if m==0 else j/m
                M[k, m] *= j

    return M

def bell_trans(n,k,a):
    @cached_function
    def T(n, k):
        if k==0: return a[0]^n
        return sum(binomial(n-1,j-1)*a[j]*T(n-j,k-1) for j in (0..n-k+1))
    return T(n,k)

def PtransMatrix(dim, f, norm = None, inverse = False, reduced = False):
    i = 1; F = [1]
    if reduced:
        while i <= dim: F.append(f(i)); i += 1
    else:
        while i <= dim: F.append(F[i-1]*f(i)); i += 1

    C = [[0 for k in range(m+1)] for m in range(dim)]
    C[0][0] = 1
    if inverse:
        for m in (1..dim-1):
            C[m][m] = -C[m-1][m-1]/F[1]
            for k in range(m-1, 0, -1):
                C[m][k] = -(C[m-1][k-1]+sum(F[i]*C[m][k+i-1]
                          for i in (2..m-k+1)))/F[1]
    else:
        for m in (1..dim-1):
            C[m][m] = -C[m-1][m-1]*F[1]
            for k in range(m-1, 0, -1):
                C[m][k] = -sum(F[i]*C[m-i][k-1] for i in (1..m-k+1))

    if norm == None: return C
    for m in (1..dim-1):
        for k in (1..m): C[m][k] *= norm(m,k)
    return C

def partition_trans(f, dim, norm = None):
    i = 1; F = [1]
    while i <= dim: F.append(F[i-1]*f(i)); i += 1
    C = [[0 for k in range(m+1)] for m in range(dim)]
    C[0][0] = 1
    for m in (1..dim-1):
        C[m][m] = -C[m-1][m-1]*F[1]
        for k in range(m-1, 0, -1):
            C[m][k] = -sum(F[i]*C[m-i][k-1] for i in (1..m-k+1))
    if norm == None: return C
    for m in (1..dim-1):
        for k in (1..m): C[m][k] *= norm(m,k)
    return C

def hankel1_trans(A) :
    f, k, t = [A.next()], 0, 1
    while True:
        yield t
        k += 1
        t = matrix(k, lambda i, j: f[i+j]).det()
        f.append(A.next())
        f.append(A.next())

def hankel2_trans(A) :
    f, k, m, t, b = [A.next()], 0, 1, 1, True
    while True:
        yield t
        if b: k += 1
        m = 1 - m
        b = not b
        f.append(A.next())
        t = matrix(k, lambda i, j: f[i+j+m]).det()
