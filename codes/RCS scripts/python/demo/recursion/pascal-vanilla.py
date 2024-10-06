# https://www.python-course.eu/python3_recursive_functions.php

def pascal( n ):
    if n == 1:
        return [ 1 ]
    else:
        line = [ 1 ]
        previous_line = pascal( n - 1 )
        for i in range( len( previous_line ) - 1 ):
            line.append( previous_line[ i ] + previous_line[ i+1 ] )
        line += [ 1 ]
    return line

k = 6
print( "pascal(%d) = %s" % ( k, pascal( k ) ) )

# dantopa@Lax-Millgram:recursion $ python pascal-vanilla.py
# pascal(6) = [1, 5, 10, 10, 5, 1]

# dantopa@Lax-Millgram:recursion $ pwd
# /Users/dantopa/Documents/repos/GitHub/topa-development/python/recursion

# dantopa@Lax-Millgram:recursion $ date
# Sat Dec  1 22:57:29 MST 2018
