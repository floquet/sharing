/* 
 * Characterize C++ compiler
 * 
 * Created on Feb 04, 2015
 */

// preprocessor directives
#include <cstdlib>  // contains EXIT_SUCCESS, EXIT_FAILURE
#include <iostream> // cout
#include <math.h>   // fabs

int main() 
{
  float       fa, fb, fc, feps;
  double      da, db, dc, deps;
  long double la, lb, lc, leps;

    std::cout << std::endl;
    std::cout << "Machine epsilon using the Moler algorithm " << std::endl;
    std::cout << "Numerial Analysis: An introduction, W. Gautschi " << std::endl;
    std::cout << "Exercise 5, p. 42 " << std::endl;
    std::cout << std::endl;

//  Moler method
//  single precision
    fa = 4. / 3.;
    fb = fa - 1;
    fc = fb + fb + fb;
    feps = fabs( fc - 1 );

// double precision
    da = 4. / 3.;
    db = da - 1;
    dc = db + db + db;
    deps = fabs( dc - 1 );

// long double precision
    la = 4. / 3.;
    lb = la - 1;
    lc = lb + lb + lb;
    leps = fabs( lc - 1 );

//  output Moler results
    std::cout << "Moler machine epsilon, float:       " << feps << std::endl;
    std::cout << "Moler machine epsilon, double:      " << deps << std::endl;
    std::cout << "Moler machine epsilon, long double: " << leps << std::endl << std::endl;

//  Bisection method
//  single precision
    feps = 1;
    do
    {
       feps /= 2;
    }
    while ( feps + 1 > 1 );
    feps *= 2;

//  double precision
    deps = 1;
    do
    {
       deps /= 2;
    }
    while ( deps + 1 > 1 );
    deps *= 2;

//  long double precision
    leps = 1;
    do
    {
       leps /= 2;
    }
    while ( leps + 1 > 1 );
    leps *= 2;

//  output bisection results
    std::cout << "Bisection machine epsilon, float:       " << feps << std::endl;
    std::cout << "Bisection machine epsilon, double:      " << deps << std::endl;
    std::cout << "Bisection machine epsilon, long double: " << leps << std::endl << std::endl;

    return EXIT_SUCCESS;
}