# https://www.python-course.eu/python3_recursive_functions.php

class Fibonacci:

    def __init__( self, i1=0, i2=1 ):
        self.memo = { 0:i1, 1:i2 }

    def __call__( self, n ):
        if n not in self.memo:
            self.memo[ n ] = self.__call__( n - 1 ) + self.__call__( n - 2 )
        return self.memo[ n ]

fib = Fibonacci( )
lucas = Fibonacci( 2, 1 )

for i in range( 1, 16 ):
    print( i, fib( i ), lucas( i ) )

# dantopa@Lax-Millgram:recursion $ python class_fibonacci.py
# 1 1 1
# 2 1 3
# 3 2 4
# 4 3 7
# 5 5 11
# 6 8 18
# 7 13 29
# 8 21 47
# 9 34 76
# 10 55 123
# 11 89 199
# 12 144 322
# 13 233 521
# 14 377 843
# 15 610 1364

# dantopa@Lax-Millgram:recursion $ pwd
# /Users/dantopa/Documents/repos/GitHub/topa-development/python/recursion

# dantopa@Lax-Millgram:recursion $ date
# Sat Dec  1 22:48:03 MST 2018
