# https://www.python-course.eu/python3_recursive_functions.php

# recursive
def fibr( n ):
    old, new = 0, 1
    if n == 0:
        return 0
    for i in range( n - 1 ):
        old, new = new, old + new
    return new

# iterative
def fibi( n ):
    if n == 0:
        return 0
    elif n == 1:
        return 1
    else:
        return fibi( n - 1 ) + fibi( n - 2 )

# save intermediates
memo = { 0:0, 1:1 }
def fibm( n ):
    if not n in memo:
        memo[ n ] = fibm( n-1 ) + fibm( n - 2 )
    return memo[ n ]
