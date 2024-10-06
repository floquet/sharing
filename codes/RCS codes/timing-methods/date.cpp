#include <ctime>      // date and time information
#include <cstdlib>    // EXIT_SUCCESS, EXIT_FAILURE
#include <iostream>

// http://www.cplusplus.com/reference/ctime/
//     Time manipulation
//         time get current time (function )
//    Conversion
//        asctime   Convert tm structure to string (function )
//        localtime Convert time_t to tm as local time (function )

// nullptr
// Keyword nullptr denotes the pointer literal, a prvalue of type std::nullptr_t.
// There are implicit conversions from nullptr to null pointer value of
// any pointer type and any pointer to member type.

int main(){

    std::time_t result = std::time( nullptr );
        std::cout << std::asctime( std::localtime ( &result ) );
        std::cout << result << " seconds since start of epoch\n";
    return EXIT_SUCCESS;
}

// dantopa@localhost.localdomain:zebra $ pwd
// /home/dantopa/scratch/repos/bitbucket/c/zebra

// dantopa@localhost.localdomain:zebra $ date
// Mon Dec  2 11:02:31 EST 2019

// santopa@localhost.localdomain:zebra $  g++ -o date.exe date.cpp $cppflags

// dantopa@localhost.localdomain:zebra $ ./date.exe
// Mon Dec  2 11:02:40 2019
// 1575302560 seconds since the Epoch

// dantopa@localhost.localdomain:zebra $ echo $cppflags
// -g -Wall -Wextra -Og -pedantic -fmax-errors=5 -fdiagnostics-color=auto
