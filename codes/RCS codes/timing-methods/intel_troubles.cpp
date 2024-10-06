// https://www.reddit.com/comments/2is4nj

#include <cstdlib>  // contains EXIT_SUCCESS, EXIT_FAILURE
#include <sstream>  // hexfloat
#include <iostream> // cout
#include <cmath>    // M_PI
#include <stdio.h>
#include <string.h>

long double fsin ( long double x )
{
    long double y;
        asm ( "fsin" : "=t" (y) : "0" (x) );
    return y;
}

int main ( int argc, char const *argv [ ] )
{
    int k;
    unsigned char buf [ sizeof ( long double ) ];
    long double x        = 2646693125139304345ULL;
    long double reduced  = x;
    long double twopi    = 2 * M_PI;
    long double numPis   = x / twopi;
    long double minus    = numPis - floorl ( numPis );
    long double w        = minus * twopi;
    // long double t        = long double floor ( long double ( x / M_PI / 2 ) )
    long int t           = floorl ( x / M_PI / 2 );
    long double z        = x - t * 2 * M_PI;
    const long double mm = 1.188488579586842482197671275324864157187e-20L;

        std::cout << std::endl;
        std::cout << "argument (hex)     = " << std::hexfloat << x << std::defaultfloat << std::endl;
        std::cout << "argument (decimal) = " << x << std::endl << std::endl;

        std::cout << "expected (hex)     = " << std::hexfloat << mm << std::defaultfloat << std::endl;
        std::cout << "expected (decimal) = " << mm << std::endl << std::endl;

        std::cout << "computed (hex)     = " << std::hexfloat << fsin( x ) << std::defaultfloat << std::endl;
        std::cout << "computed (decimal) = " << fsin( x ) << std::endl << std::endl;

        std::cout << "language (hex)     = " << std::hexfloat << sin( x ) << std::defaultfloat << std::endl;
        std::cout << "language (decimal) = " << sin( x ) << std::endl << std::endl;

        std::cout << "numPis             = " << std::hexfloat << numPis << std::defaultfloat << std::endl;
        std::cout << "numPis             = " << numPis << std::defaultfloat << std::endl << std::endl;

        std::cout << "reduced x          = " << std::hexfloat << w << std::defaultfloat << std::endl;
        std::cout << "reduced x          = " << w << std::defaultfloat << std::endl << std::endl;

        std::cout << "fixed (hex)        = " << std::hexfloat << sin( w ) << std::defaultfloat << std::endl;
        std::cout << "fixed (decimal)    = " << sin( w ) << std::endl << std::endl;

        std::cout << "reduced (hex)      = " << std::hexfloat << reduced << std::defaultfloat << std::endl;
        std::cout << "reduced (decimal)  = " << reduced << std::endl << std::endl;

        printf ( "%Le = %La\n", x, x );
        memcpy ( buf, &x, sizeof( buf ) );
        printf ( "bytes:" );

        for ( k = 0 ; k < sizeof( buf ) ; k++ )
        printf( " %#04x", buf[ k ] );
        printf ( "\n" );

        long double y = fsin( x );
        printf ( "%Le = %La\n", y, y );
        memcpy( buf, &y, sizeof ( buf ) );
        printf ( "bytes:" );

        for ( k = 0 ; k < sizeof( buf ) ; k++ )
        printf ( " %#04x", buf[ k ] ) ;
        printf ( "\n" );

        y = M_PI;
        printf ( "%Le = %La\n", y, y );
        memcpy( buf, &y, sizeof ( buf ) );
        printf ( "bytes:" );

        for ( k = 0 ; k < sizeof( buf ) ; k++ )
        printf ( " %#04x", buf[ k ] ) ;
        printf ( "\n" );

    return EXIT_SUCCESS;
}

// dan-topas-pro-2:numerics rditldmt$ date
// Thu Jan  7 17:08:05 CST 2016
// dan-topas-pro-2:numerics rditldmt$ pwd
// /Users/rditldmt/Box Sync/c++/demos/numerics
// dan-topas-pro-2:numerics rditldmt$ clang++ -std=c++1y -Wall -g -pedantic -fcheck=bounds -Wconversion intel_troubles.cpp
// clang: warning: argument unused during compilation: '-fcheck=bounds'
// dan-topas-pro-2:numerics rditldmt$ ./a.out
//
// argument (hex)     = 0x9.2ebc57f85963e64p+58
// argument (decimal) = 2.64669e+18
//
// expected (hex)     = 0xe.07fc7fd31b3447ap-70
// expected (decimal) = 1.18849e-20
//
// computed (hex)     = -0xd.f4e6f150a65fdf3p-12
// computed (decimal) = -0.00340738
//
// fixed (hex)        = 0x8.5dc1a37b32126e6p-4
// fixed (decimal)    = 0.52289
//
// 2.646693e+18 = 0x9.2ebc57f85963e64p+58
// bytes: 0x64 0x3e 0x96 0x85 0x7f 0xc5 0xeb 0x92 0x3c 0x40 0000 0000 0000 0000 0000 0000
// -3.407385e-03 = -0xd.f4e6f150a65fdf3p-12
// bytes: 0xf3 0xfd 0x65 0x0a 0x15 0x6f 0x4e 0xdf 0xf6 0xbf 0000 0000 0000 0000 0000 0000
// 3.141593e+00 = 0xc.90fdaa22168cp-2
// bytes: 0000 0xc0 0x68 0x21 0xa2 0xda 0x0f 0xc9 0000 0x40 0000 0000 0000 0000 0000 0000
