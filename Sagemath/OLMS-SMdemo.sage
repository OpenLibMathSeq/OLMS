def portrait(seq):
    L = seq()

    print "\n*** Using triangle representation\n"
    T = L.triangle()
    for r in T.get(6): print r
    print
    print "row 5    ", T.row(5)
    print "center   ", T.center(7)

    print "\n*** Using rectangle representation\n"
    R = L.rectangle()
    for r in R.get(5,6): print r
    print
    print "row 5    ", R.row(5,6)
    print "column 3 ", R.column(3,6)
    print "rowdiag 2", R.rowdiag(2,5)
    print "coldiag 2", R.coldiag(2,5)

    print "\n*** Using matrix representation\n"
    M = L.matrix()
    print "matrix     \n", M.get(6)
    print "\nreverse matrix\n", M.reverse(6)
    print "\ninverse matrix\n", M.inverse(6)
    
    print "\n*** As polynomials\n"
    for p in L.polynomials(5): print p

    def unity():
        while true: 
            yield 1
            
    def sq():
        n = 0
        while true: 
            yield n*n
            n += 1

    print "\n*** Use as a transformation\n"
    print "transform of unity"
    U = L.transform(unity())
    print [U.next() for _ in range(9)]
    Uinv = L.transform(unity(), inv=true)
    print [Uinv.next() for _ in range(9)]
    
    print "transform of the squares"
    U = L.transform(sq())
    print [U.next() for _ in range(9)]
    Uinv = L.transform(sq(), inv=true)
    print [Uinv.next() for _ in range(9)] 
  

class Lah(OLMS2):
    
    def number(self, n, k):   # single value
        if n == k: return 1
        if n<0 and k<0: return number(-k, -n)
        if k<0 or  k>n: return 0
        return (k*n*gamma(n)^2) / (gamma(k+1)^2 * gamma(n-k+1))

    def row_generator(self):   # generator of rows
        yield[1]
        L, n = [0], 0
        while True:
            L.append(1)
            for k in range(n, 0, -1):
                L[k] = L[k] * (n + k) + L[k - 1]
            yield L
            n += 1
            
portrait(Lah)
