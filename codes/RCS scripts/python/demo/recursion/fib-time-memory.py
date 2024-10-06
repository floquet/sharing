from timeit import Timer
from fibonacci import fibr

t1 = Timer( "fibr( 10 )", "from fibonacci import fibr" )

for i in range( 1, 41 ):
	s = "fibm(" + str( i ) + ")"
	t1 = Timer( s, "from fibonacci import fibm" )
	time1 = t1.timeit( 3 )
	s = "fibr(" + str( i ) + ")"
	t2 = Timer( s, "from fibonacci import fibr" )
	time2 = t2.timeit( 3 )
	print( "n=%2d, fibm: %8.6f, fibr:  %7.6f, percent: %10.2f" % ( i, time1, time2, time1/time2 ) )

# dantopa@Lax-Millgram:recursion $ date
# Sat Dec  1 22:42:00 MST 2018

# dantopa@Lax-Millgram:recursion $ pwd
# /Users/dantopa/Documents/repos/GitHub/topa-development/python/recursion

# dantopa@Lax-Millgram:recursion $ python fib-time-memory.py
# n= 1, fibm: 0.000001, fibr:  0.000002, percent:       0.62
# n= 2, fibm: 0.000002, fibr:  0.000003, percent:       0.69
# n= 3, fibm: 0.000011, fibr:  0.000003, percent:       3.98
# n= 4, fibm: 0.000002, fibr:  0.000003, percent:       0.66
# n= 5, fibm: 0.000002, fibr:  0.000003, percent:       0.73
# n= 6, fibm: 0.000002, fibr:  0.000003, percent:       0.61
# n= 7, fibm: 0.000002, fibr:  0.000003, percent:       0.62
# n= 8, fibm: 0.000002, fibr:  0.000003, percent:       0.57
# n= 9, fibm: 0.000002, fibr:  0.000004, percent:       0.48
# n=10, fibm: 0.000003, fibr:  0.000004, percent:       0.77
# n=11, fibm: 0.000002, fibr:  0.000004, percent:       0.60
# n=12, fibm: 0.000002, fibr:  0.000004, percent:       0.55
# n=13, fibm: 0.000002, fibr:  0.000004, percent:       0.54
# n=14, fibm: 0.000002, fibr:  0.000004, percent:       0.50
# n=15, fibm: 0.000002, fibr:  0.000005, percent:       0.41
# n=16, fibm: 0.000002, fibr:  0.000005, percent:       0.45
# n=17, fibm: 0.000002, fibr:  0.000005, percent:       0.45
# n=18, fibm: 0.000002, fibr:  0.000005, percent:       0.49
# n=19, fibm: 0.000012, fibr:  0.000005, percent:       2.40
# n=20, fibm: 0.000012, fibr:  0.000005, percent:       2.37
# n=21, fibm: 0.000012, fibr:  0.000005, percent:       2.35
# n=22, fibm: 0.000002, fibr:  0.000005, percent:       0.38
# n=23, fibm: 0.000002, fibr:  0.000005, percent:       0.34
# n=24, fibm: 0.000002, fibr:  0.000006, percent:       0.32
# n=25, fibm: 0.000002, fibr:  0.000006, percent:       0.34
# n=26, fibm: 0.000002, fibr:  0.000006, percent:       0.32
# n=27, fibm: 0.000002, fibr:  0.000006, percent:       0.30
# n=28, fibm: 0.000002, fibr:  0.000006, percent:       0.32
# n=29, fibm: 0.000002, fibr:  0.000006, percent:       0.30
# n=30, fibm: 0.000002, fibr:  0.000006, percent:       0.29
# n=31, fibm: 0.000002, fibr:  0.000007, percent:       0.29
# n=32, fibm: 0.000002, fibr:  0.000007, percent:       0.29
# n=33, fibm: 0.000002, fibr:  0.000007, percent:       0.26
# n=34, fibm: 0.000002, fibr:  0.000007, percent:       0.27
# n=35, fibm: 0.000002, fibr:  0.000008, percent:       0.26
# n=36, fibm: 0.000002, fibr:  0.000007, percent:       0.27
# n=37, fibm: 0.000002, fibr:  0.000007, percent:       0.27
# n=38, fibm: 0.000002, fibr:  0.000007, percent:       0.26
# n=39, fibm: 0.000002, fibr:  0.000008, percent:       0.25
# n=40, fibm: 0.000002, fibr:  0.000008, percent:       0.23
