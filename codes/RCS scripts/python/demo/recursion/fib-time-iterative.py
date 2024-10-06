# https://www.python-course.eu/python3_recursive_functions.php

from timeit import Timer

t1 = Timer( "fibi( 10 )", "from fibonacci import fibi" )

for i in range( 1, 31 ):
	s = "fibi(" + str(i) + ")"
	t1 = Timer( s, "from fibonacci import fibi" )
	time1 = t1.timeit( 3 )
	s = "fibr(" + str( i ) + ")"
	t2 = Timer( s, "from fibonacci import fibr " )
	time2 = t2.timeit( 3 )
	print("n=%2d, fibi: %8.6f, fibr:  %7.6f, percent: %10.2f" % (i, time1, time2, time1/time2 ))

# dantopa@Lax-Millgram:recursion $ pwd
# /Users/dantopa/Documents/repos/GitHub/topa-development/python/recursion

# dantopa@Lax-Millgram:recursion $ date
# Sat Dec  1 21:41:43 MST 2018

# dantopa@Lax-Millgram:recursion $ python fib-time-iterative.py u
# n= 1, fibi: 0.000001, fibr:  0.000003, percent:       0.48
# n= 2, fibi: 0.000013, fibr:  0.000003, percent:       4.22
# n= 3, fibi: 0.000003, fibr:  0.000003, percent:       1.17
# n= 4, fibi: 0.000005, fibr:  0.000003, percent:       1.85
# n= 5, fibi: 0.000008, fibr:  0.000003, percent:       2.68
# n= 6, fibi: 0.000012, fibr:  0.000003, percent:       4.21
# n= 7, fibi: 0.000020, fibr:  0.000003, percent:       6.12
# n= 8, fibi: 0.000031, fibr:  0.000003, percent:       9.85
# n= 9, fibi: 0.000051, fibr:  0.000003, percent:      15.53
# n=10, fibi: 0.000091, fibr:  0.000003, percent:      26.85
# n=11, fibi: 0.000139, fibr:  0.000003, percent:      39.76
# n=12, fibi: 0.000218, fibr:  0.000004, percent:      59.16
# n=13, fibi: 0.000346, fibr:  0.000004, percent:      93.70
# n=14, fibi: 0.000553, fibr:  0.000004, percent:     144.16
# n=15, fibi: 0.000951, fibr:  0.000004, percent:     233.98
# n=16, fibi: 0.001428, fibr:  0.000004, percent:     332.89
# n=17, fibi: 0.002318, fibr:  0.000005, percent:     494.44
# n=18, fibi: 0.003809, fibr:  0.000005, percent:     803.26
# n=19, fibi: 0.007416, fibr:  0.000008, percent:     901.90
# n=20, fibi: 0.011701, fibr:  0.000005, percent:    2157.21
# n=21, fibi: 0.018341, fibr:  0.000008, percent:    2280.30
# n=22, fibi: 0.027822, fibr:  0.000007, percent:    3827.97
# n=23, fibi: 0.045430, fibr:  0.000009, percent:    5133.84
# n=24, fibi: 0.076444, fibr:  0.000008, percent:    9813.05
# n=25, fibi: 0.117433, fibr:  0.000008, percent:   14212.09
# n=26, fibi: 0.193527, fibr:  0.000008, percent:   22910.47
# n=27, fibi: 0.332173, fibr:  0.000011, percent:   31446.62
# n=28, fibi: 0.547914, fibr:  0.000012, percent:   46794.01
# n=29, fibi: 0.858952, fibr:  0.000008, percent:  104052.20
# n=30, fibi: 1.303756, fibr:  0.000008, percent:  153417.56
