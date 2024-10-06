// http://www.cplusplus.com/reference/ctime/time/

//  functions
//    clock
//      clock example

#include <cmath>     //
#include <ctime>     // time_t, struct tm, difftime, time, mktime */
#include <cstdlib>   // EXIT_SUCCESS, EXIT_FAILURE
#include <iostream>  // cout, endl, printf

//   asctime
//    char* asctime ( const struct tm * timeptr );

// Convert tm structure to string
// Interprets the contents of the tm structure pointed by timeptr as a calendar time and
// converts it to a C-string containing a human-readable version of the corresponding date
// and time.

// The returned string has the following format:

//    Www Mmm dd hh:mm:ss yyyy

// Where Www is the weekday, Mmm the month (in letters), dd the day of the month, hh:mm:ss
// the time, and yyyy the year.

// The string is followed by a new-line character ('\n') and terminated with a null-character.

// It is defined with a behavior equivalent to:
// char* asctime ( const struct tm *timeptr )
// {
//      static const char wday_name [] [ 4 ] =
//      {
//       "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"
//      };
//      static const char mon_name [ ] [ 4 ] =
//      {
//       "Jan", "Feb", "Mar", "Apr", "May", "Jun",
//       "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
//      };

//   static char result [ 26 ];

//   sprintf ( result, "%.3s %.3s%3d %.2d:%.2d:%.2d %d\n",
//     wday_name [ timeptr -> tm_wday ],
//     mon_name [ timeptr -> tm_mon ],
//     timeptr -> tm_mday, timeptr -> tm_hour,
//     timeptr -> tm_min,  timeptr -> tm_sec,
//     1900 + timeptr -> tm_year);
//   return result;
// }

// For an alternative with custom date formatting, see strftime.

// Parameters
//   timeptr
//     Pointer to a tm structure that contains a calendar time broken down into its
//     components (see struct tm).

// Return Value
// A C-string containing the date and time information in a human-readable format.

// The returned value points to an internal array whose validity or value may be altered by
// any subsequent call to asctime or ctime.

int frequency_of_primes ( int n )
{
  int amiprimeQ, testfactor;
  int freq = n - 1;

    for ( amiprimeQ = 2 ; amiprimeQ <= n ; ++amiprimeQ )
      for ( testfactor = sqrt ( amiprimeQ ); testfactor > 1; --testfactor )
        if ( amiprimeQ % testfactor == 0 ) { --freq; break; }

  return freq;
}

int main ( int argc, char *argv [ ] )  // p. 49 Guide to Scientific Computing in C++
{
  clock_t t;
  float sec;
  int f;

    t = clock ( ) ;
    printf ( "Calculating...\n" );

    f = frequency_of_primes ( 99999 );
    printf ( "The number of primes lower than 100,000 is: %d\n", f );

    t = clock ( ) - t;
    // printf ( "It took me %d clicks (%f seconds).\n", t, ( ( float ) t ) / CLOCKS_PER_SEC );

    sec = float ( t ) / CLOCKS_PER_SEC;
    std::cout << "cpu time = " << t << " clicks ( " << sec << " sec )" << std::endl;
    return EXIT_SUCCESS;
}

// macro  <ctime>
// CLOCKS_PER_SEC
// Clock ticks per second

// This macro expands to an expression representing the number of clock ticks per second.

// Clock ticks are units of time of a constant but system-specific length, as those returned
// by function clock.

// Dividing a count of clock ticks by this expression yields the number of seconds.

// C90 (C++98)
// The type of this macro is unspecified.

// C99 (C++11)
// This macro evaluates to an expression of type clock_t.

// CLK_TCK is an obsolete alias of this macro.

// See also
// clock    Clock program (function )
// clock_t  Clock type (type )

//  09:42 dan-topas-pro-2 rditldmt $ pwd
// /Users/rditldmt/SVN wd/c++/cplusplus/trunk/reference/functions/time
//  09:42 dan-topas-pro-2 rditldmt $ g++ -std=c++0x -Wall clock.cpp
//  09:42 dan-topas-pro-2 rditldmt $ ./a.out
// Calculating...
// The number of primes lower than 100,000 is: 9592
// cpu time = 56303 clicks ( 0.056303 sec )
//  09:42 dan-topas-pro-2 rditldmt $ g++ -Wall clock.cpp
//  09:42 dan-topas-pro-2 rditldmt $ ./a.out
// Calculating...
// The number of primes lower than 100,000 is: 9592
// cpu time = 57387 clicks ( 0.057387 sec )
// 09:42 dan-topas-pro-2 rditldmt $
