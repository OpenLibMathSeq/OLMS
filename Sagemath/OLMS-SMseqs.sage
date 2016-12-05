# needs OLMS-SMbase.sage!
# load("OLMS-SMbase.sage")

class MotzkinClass(OLMS1):

    def number(self, n):   # single value
        return simplify((-1)^n*hypergeometric([-n,1/2],[2],4))

    def generator(self):   # generator
        a, b, fa, fb, n = 1, 1, 0, 3, 3
        yield a
        while True:
            yield b
            n += 1; fb += 2; fa += 3
            a, b = b, (fb*b + fa*a) / n

class CatalanClass(OLMS1):

    def number(self, n):   # single value
        return catalan_number(n)

    def generator(self):   # generator
        n = 0
        while true:
            yield catalan_number(n)
            n += 1

class Eulerian2Class(OLMS2):

    #@cached_function
    def number(self, n, k):
        if k==0: return 1
        if k==n: return 0
        return self.number(n-1, k)*(k+1)+self.number(n-1, k-1)*(2*n-k-1)

    def generator(self):   # generator
        n = 0
        while true:
            yield self.number(n, k)
            n += 1
