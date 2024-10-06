def five_powers( n ):
    five_powers( 1 ) = 5,
    five_powers( n ) = five_powers( n - 1 ) * 5

k = 5
print( "five_powers( %d ) = %d" % ( k, five_powers( k ) ) )
