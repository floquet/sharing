// http://www.cplusplus.com/reference/ctime/time/

//  functions
//    time
//      time example

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

int main ( int argc, char *argv [ ] )  // p. 49 Guide to Scientific Computing in C++
{
    time_t rawtime;
    struct tm * timeinfo;

        time ( &rawtime );
        timeinfo = localtime ( &rawtime );
        printf ( "Current date and time is: %s", asctime ( timeinfo ) );

    return EXIT_SUCCESS;
}

// Data races
// The function accesses the object pointed by timeptr.
// The function also accesses and modifies a shared internal buffer, which may cause data 
// races on concurrent calls to asctime or ctime. Some libraries provide an alternative 
// function that avoids this data race: asctime_r (non-portable).

// Exceptions (C++)
// No-throw guarantee: this function never throws exceptions.

// See also
// ctime       Convert time_t value to string (function )
// gmtime      Convert time_t to tm as UTC time (function )
// localtime   Convert time_t to tm as local time (function )
// time        4Get current time (function )


//  17:38 dan-topas-pro-2 rditldmt $ pwd
// /Users/rditldmt/SVN wd/c++/cplusplus/trunk/reference/functions/time
//  17:38 dan-topas-pro-2 rditldmt $ g++ asctime.cpp 
//  17:38 dan-topas-pro-2 rditldmt $ ./a.out
// Current date and time is: Mon Mar 30 17:38:44 2015
//  17:38 dan-topas-pro-2 rditldmt $ 