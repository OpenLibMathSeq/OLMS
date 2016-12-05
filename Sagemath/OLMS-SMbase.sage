class OLMS1(object):

    def sequence(self, len):  # sequence
        A = self.generator()
        return [A.next() for _ in range(len)]

    def convolve(self, seq, len):  # seq sequence generator
        L = [seq.next() for _ in range(len)]
        R = self.sequence(len)
        return convolution(L, R)[:len]

    def number(self, n):   # single value
        return self.sequence(n+1)[n]

    def __call__(self, n): # single value
        return self.number(n)

class Triangle():

    def __init__(self, number, generator) :
        self.number = number
        self.generator = generator

    def get(self, len):   # triangle as a list of rows
        A = self.generator()
        return [list(A.next()) for _ in range(len)]

    def row(self, n) :
        return [self.number(n, k) for k in (0..n)]

    def center(self, len) :
        return [self.number(2*k, k) for k in range(len)]

class Rectangle():

    def __init__(self, number, generator) :
        self.number = number
        self.generator = generator

    def get(self, numrow, numcol) :
        return [self.row(m, numcol) for m in range(numrow)]

    def row(self, m, len) :
        return [self.number(m + k, k) for k in range(len)]

    def column(self, m, len) :
        return [self.number(k + m , m) for k in range(len)]

    def rowdiag(self, m, len) :
        return [self.number(m + 2*k, k) for k in range(len)]

    def coldiag(self, m, len) :
        return [self.number(m + 2*k, m + k) for k in range(len)]

    def center(self, len) :
        return [self.number(2*k, k) for k in range(len)]

class Matrix():

    def __init__(self, number, generator) :
        self.number = number
        self.generator = generator

    def get(self, dim) :
        G = self.generator()
        L = [G.next() + [0]*(dim-n-1) for n in range(dim)]
        return matrix(ZZ, L)

    def reverse(self, dim) :
        G = self.generator()
        L = [G.next()[::-1] + [0]*(dim-n-1) for n in range(dim)]
        return matrix(ZZ, L)

    def inverse(self, dim) :
        M = self.get(dim)
        if M.det() == 0 :
            print "Not invertible."
            return
        return M.inverse()

class OLMS2(object):

    def number(self, n, k):   # single value
        if k<0 or k>n: return 0
        G = self.row_generator()
        for _ in (0..n): L = G.next()
        return L[k]

    def __call__(self, n, k): # single value
        return self.number(n,k)

    def triangle(self, len = None):
        if len == None:
            return Triangle(self.number, self.row_generator)
        return Triangle(self.number, self.row_generator).get(len)

    def rectangle(self, numrow = None, numcol = None):
        if numrow == None and numcol == None:
            return Rectangle(self.number, self.row_generator)
        if numcol == None:
            return Rectangle(self.number, self.row_generator).get(numrow, numrow)
        return Rectangle(self.number, self.row_generator).get(numrow, numcol)

    def matrix(self, dim = None):
        if dim == None:
            return Matrix(self.number, self.row_generator)
        return Matrix(self.number, self.row_generator).get(dim)

    def polynomials(self, len):  # list of polynomials
        R = self.row_generator()
        L = []
        for n in range(len):
            r = R.next()
            L.append(sum(r[k]*x^k for k in (0..n)))
        return L

    def values(self, numrow, numcol):  # polynomials at integers
        P = self.polynomials(numrow)
        L = []
        for p in P:
            L.append([p(x=k) for k in range(numcol)])
        return L

    def transform(self, seq, inv = false): # seq generator
        R = self.row_generator()
        S, n = [], 0
        while True:
            r = R.next()
            S.append(seq.next())
            if inv:
                yield sum((-1)^(n-k)*r[k]*S[k] for k in (0..n))
            else:
                yield sum(r[k]*S[k] for k in (0..n))
            n += 1
