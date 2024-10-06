/*
 * Characterize C++ compiler
 *
 * http://en.wikipedia.org/wiki/C_data_types#stddef.h
 *
 * Created  Feb 04, 2015
 * Modified Jan 05, 2015
 */

// preprocessor directives
#include <cstdlib>  // contains EXIT_SUCCESS, EXIT_FAILURE
#include <iostream> // cout
#include <cmath>    // fabs, M_PI, M_E
#include <sstream>  // hexfloat
#include <climits>  // macros for integer types
#include <cfloat>   // macros for floating-point types

int epsilon();      // find machine epsilon using bisection and the Moler algorithm
int headers();      // stroll through header files
int header_cmath();
int header_climits();

int main()
{
  int success_epsilon = EXIT_FAILURE;
  int success_headers = EXIT_FAILURE;

    // find machine epsilon via the Moler method and via bisection
    success_epsilon = epsilon();
    if ( success_epsilon != EXIT_SUCCESS )
    {
       std::cout << std::endl << "Error in routine 'epsilon'" << std::endl << std::endl;
    }

    // header files
    success_headers = headers();
    if ( success_headers != EXIT_SUCCESS )
    {
       std::cout << std::endl << "Error in routine 'headers'" << std::endl << std::endl;
    }

    return EXIT_SUCCESS;
}

int headers()  // interrogate header files
{
  int success_headers = EXIT_SUCCESS;

    success_headers += header_cmath();
    success_headers += header_climits();

    return success_headers;
}

int header_cmath()  // http://en.wikipedia.org/wiki/C_mathematical_functions
                    // http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/math.h.html
{
    // predefined constants
    std::cout << "* * * header file 'cmath'" << std::endl;
    std::cout << "M_PI        = " << M_PI        << ": hex value = " << std::hexfloat << M_PI        << std::defaultfloat << std::endl;
    std::cout << "acos( -1 )  = " << acos( -1 )  << ": hex value = " << std::hexfloat << acos( -1 )  << std::defaultfloat << std::endl;

    std::cout << "cos( pi )   = " << cos( M_PI ) << ": hex value = " << std::hexfloat << cos( M_PI ) << std::defaultfloat << std::endl;
    std::cout << "sin( pi )   = " << sin( M_PI ) << ": hex value = " << std::hexfloat << sin( M_PI ) << std::defaultfloat << std::endl;

    std::cout << "M_E         = " << M_E         << ": hex value = " << std::hexfloat << M_E         << std::defaultfloat << std::endl;
    std::cout << "e           = " << exp( 1 )    << ": hex value = " << std::hexfloat << exp( 1 )    << std::defaultfloat << std::endl;
    std::cout << "ln ( 1 )    = " << log( 1 )    << ": hex value = " << std::hexfloat << log( 1 )    << std::defaultfloat << std::endl;
    std::cout << "Gamma ( 4 ) = " << tgamma( 4 ) << ": hex value = " << std::hexfloat << tgamma( 4 ) << std::defaultfloat << std::endl;

    std::cout << std::endl;

    return EXIT_SUCCESS;  // pass back to headers
}

int header_climits()  // http://en.wikipedia.org/wiki/C_data_types#stddef.h
{
    // predefined constants
    std::cout << "* * * header file 'climits'" << std::endl;
    std::cout << "FLT_MAX  = " << FLT_MAX <<  " maximum finite value of float" << std::endl;
    std::cout << "DBL_MAX  = " << DBL_MAX <<  " maximum finite value of double" << std::endl;
    std::cout << "LDBL_MAX = " << LDBL_MAX << " maximum finite value of long double" << std::endl << std::endl;

    std::cout << "FLT_MIN  = " << FLT_MIN <<  " minimum normalized positive value of float" << std::endl;
    std::cout << "DBL_MIN  = " << DBL_MIN <<  " minimum normalized positive value of double" << std::endl;
    std::cout << "LDBL_MIN = " << LDBL_MIN << " minimum normalized positive value of long double" << std::endl << std::endl;

    std::cout << "FLT_TRUE_MIN  = " << FLT_TRUE_MIN << " minimum positive value of float (C11)" << std::endl;
    std::cout << "DBL_TRUE_MIN  = " << DBL_TRUE_MIN << " minimum positive value of double  (C11)" << std::endl;
    std::cout << "LDBL_TRUE_MIN = " << LDBL_TRUE_MIN << " minimum positive value of long double  (C11)" << std::endl << std::endl;

    std::cout << "FLT_ROUNDS = " << FLT_ROUNDS << " rounding mode for floating-point operations" << std::endl;
    std::cout << "FLT_EVAL_METHOD = " << FLT_EVAL_METHOD << " evaluation method of expressions involving different" << std::endl;
    std::cout << "                    floating-point types (C99)" << std::endl;
    std::cout << "DECIMAL_DIG = " << DECIMAL_DIG << " minimum number of decimal digits such that any number of the" << std::endl;
    std::cout << "                 widest supported floating-point type can be represented in decimal with a" << std::endl;
    std::cout << "                 precision of DECIMAL_DIG digits and read back in the original floating-point" << std::endl;
    std::cout << "                 type without changing its value (C99)" << std::endl;
    std::cout << std::endl;

    return EXIT_SUCCESS;  // pass back to headers
}

int epsilon()
{
  float       fa, fb, fc, feps;
  double      da, db, dc, deps;
  long double la, lb, lc, leps;
  long double lfour = 4, lthree = 3, lone = 1;

    std::cout << std::endl;
    std::cout << "Machine epsilon using the Moler algorithm " << std::endl;
    std::cout << "Numerial Analysis: An introduction, W. Gautschi " << std::endl;
    std::cout << "Exercise 5, p. 42 " << std::endl;
    std::cout << std::endl;

//  Moler method
//  single precision
    fa = 4. / 3.;
    fb = fa - 1.;
    fc = fb + fb + fb;
    feps = fabs( fc - 1. );

// double precision
    da = 4. / 3;
    db = da - 1.;
    dc = db + db + db;
    deps = fabs( dc - 1. );

// long double precision
    // la = 4. / 3.;
    // lb = la - 1.;
    // lc = lb + lb + lb;
    // leps = lc - 1.;
    la = lfour / lthree;
    lb = la - lone;
    lc = lb + lb + lb;
    leps = lc - lone;

//  output Moler results
    std::cout << "Moler machine epsilon, float:       " << feps << std::endl;
    std::cout << "Moler machine epsilon, double:      " << deps << std::endl;
    std::cout << "Moler machine epsilon, long double: " << leps << std::endl << std::endl;

//  Bisection method
//  single precision
    feps = 1;
    do { feps /= 2; } while ( feps + 1 > 1 );
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

// dan-topas-pro-2:characterize rditldmt$ date
// Tue Jan  5 16:07:10 CST 2016
// dan-topas-pro-2:characterize rditldmt$ pwd
// /Users/rditldmt/Box Sync/c++/characterize
// dan-topas-pro-2:characterize rditldmt$ clang++ -Wall -g characterize.cpp
// dan-topas-pro-2:characterize rditldmt$ ./a.out
//
// Machine epsilon using the Moler algorithm
// Numerial Analysis: An introduction, W. Gautschi
// Exercise 5, p. 42
//
// Moler machine epsilon, float:       1.19209e-07
// Moler machine epsilon, double:      2.22045e-16
// Moler machine epsilon, long double: 1.0842e-19
//
// Bisection machine epsilon, float:       1.19209e-07
// Bisection machine epsilon, double:      2.22045e-16
// Bisection machine epsilon, long double: 1.0842e-19
//
// * * * header file 'cmath'
// M_PI        = 3.14159: hex value = 0x1.921fb54442d18p+1
// acos( -1 )  = 3.14159: hex value = 0x1.921fb54442d18p+1
// cos( pi )   = -1: hex value = -0x1p+0
// sin( pi )   = 1.22465e-16: hex value = 0x1.1a62633145c07p-53
// M_E         = 2.71828: hex value = 0x1.5bf0a8b145769p+1
// e           = 2.71828: hex value = 0x1.5bf0a8b145769p+1
// ln ( 1 )    = 0: hex value = 0x0p+0
// Gamma ( 4 ) = 6: hex value = 0x1.8p+2
//
// * * * header file 'climits'
// FLT_MAX  = 3.40282e+38 maximum finite value of float
// DBL_MAX  = 1.79769e+308 maximum finite value of double
// LDBL_MAX = 1.18973e+4932 maximum finite value of long double
//
// FLT_MIN  = 1.17549e-38 minimum normalized positive value of float
// DBL_MIN  = 2.22507e-308 minimum normalized positive value of double
// LDBL_MIN = 3.3621e-4932 minimum normalized positive value of long double
//
// FLT_TRUE_MIN  = 1.4013e-45 minimum positive value of float (C11)
// DBL_TRUE_MIN  = 4.94066e-324 minimum positive value of double  (C11)
// LDBL_TRUE_MIN = 3.6452e-4951 minimum positive value of long double  (C11)
//
// FLT_ROUNDS = 1 rounding mode for floating-point operations
// FLT_EVAL_METHOD = 0 evaluation method of expressions involving different
//                     floating-point types (C99)
// DECIMAL_DIG = 21 minimum number of decimal digits such that any number of the
//                  widest supported floating-point type can be represented in decimal with a
//                  precision of DECIMAL_DIG digits and read back in the original floating-point
//                  type without changing its value (C99)
//
