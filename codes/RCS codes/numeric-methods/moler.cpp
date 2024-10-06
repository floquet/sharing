#include <cstdlib>  // contains EXIT_SUCCESS, EXIT_FAILURE
#include <iostream> // cout
#include <sstream>  // hexfloat

int main ( int argc, char const *argv [ ] )
{
    double       a,  b,  c,  eps;
    long double la, lb, lc, leps;
    long double lfour = 4, lthree = 3;

        std::cout << std::endl;
        std::cout << "Machine epsilon using the Moler algorithm " << std::endl;
        std::cout << "Numerial Analysis: An introduction, W. Gautschi " << std::endl;
        std::cout << "Exercise 5, p. 42 " << std::endl;
        std::cout << std::endl;

//      Moler method
//      double precision
        a = 4. / 3;
        std::cout << "a hex value 4. / 3      = " << std::hexfloat << a << std::defaultfloat << std::endl;
        a = 4. / 3.;
        std::cout << "a hex value 4. / 3.     = " << std::hexfloat << a << std::defaultfloat << std::endl;
        b = a - 1;
        c = b + b + b;
        eps = c - 1;

//      output Moler results
        std::cout << "Moler machine epsilon, double:     " << eps << std::endl << std::endl;

//      long double precision
        la = 4. / 3;
        std::cout << "la hex value 4. / 3     = " << std::hexfloat << la << std::defaultfloat << std::endl;
        la = lfour / 3;
        std::cout << "la hex value lfour / 3  = " << std::hexfloat << la << std::defaultfloat << std::endl;
        la = 4 / lthree;
        std::cout << "la hex value 4 / lthree = " << std::hexfloat << la << std::defaultfloat << std::endl << std::endl;
        lb = la - 1;
        lc = lb + lb + lb;
        leps = lc - 1;

//      output Moler results
        std::cout << "Moler machine epsilon, long double:            " << leps << std::endl;

//      Bisection method

//      long double precision
        leps = 1;
        do
        {
            leps /= 2;
        }
        while ( leps + 1 > 1 );
        leps *= 2;

//      output bisection results
        std::cout << "Bisection machine epsilon, long double:        " << leps << std::endl;
//      Bisection method

//      long double precision
        leps = 1;
        do
        {
            leps /= 3;
        }
        while ( leps + 1 > 1 );
        leps *= 3;

//      output bisection results
        std::cout << "Trisection machine epsilon, long double:       " << leps << std::endl;

//      Decade reduction method

//      long double precision
        leps = 1;
        do
        {
            leps /= 10;
        }
        while ( leps + 1 > 1 );
        leps *= 10;

//      output bisection results
        std::cout << "Decade reduction machine epsilon, long double: " << leps << std::endl << std::endl;

    return EXIT_SUCCESS;
}

// dan-topas-pro-2:characterize rditldmt$ date
// Wed Jan 13 11:08:24 CST 2016
// dan-topas-pro-2:characterize rditldmt$ pwd
// /Users/rditldmt/Box Sync/c++/characterize
// dan-topas-pro-2:characterize rditldmt$ clang++ -std=c++1y -Wall -g -pedantic -fcheck=bounds -Wconversion moler.cpp
// clang: warning: argument unused during compilation: '-fcheck=bounds'
// dan-topas-pro-2:characterize rditldmt$ ./a.out
//
// Machine epsilon using the Moler algorithm
// Numerial Analysis: An introduction, W. Gautschi
// Exercise 5, p. 42
//
// a hex value 4. / 3      = 0x1.5555555555555p+0
// a hex value 4. / 3.     = 0x1.5555555555555p+0
// Moler machine epsilon, double:     -2.22045e-16
//
// la hex value 4. / 3     = 0xa.aaaaaaaaaaaa8p-3
// la hex value lfour / 3  = 0xa.aaaaaaaaaaaaaabp-3
// la hex value 4 / lthree = 0xa.aaaaaaaaaaaaaabp-3
//
// Moler machine epsilon, long double:            1.0842e-19
// Bisection machine epsilon, long double:        1.0842e-19
// Trisection machine epsilon, long double:       8.22526e-20
// Decade reduction machine epsilon, long double: 1e-19
