// https://stackoverflow.com/questions/25705287/floats-smaller-than-flt-min-why-flt-true-min

#include <stdio.h>
#include <stdlib.h>
#include <float.h>

int main( int argc, const char * argv[ ] )
{
    float underflow = FLT_MIN * 0.0000004;

    printf("Float min is %f or %e.\nUnderflow is %f or %e\nMin float exp is %d.\n", FLT_MIN, FLT_MIN, underflow, underflow, FLT_MIN_10_EXP);

    return 0;
}
