! https://en.wikibooks.org/wiki/Fortran/Fortran_procedures_and_functions

 function func(i) result(j)
    integer, intent(in) :: i ! input
    integer             :: j ! output
    j = i**2 + i**3
 end function func

 program xfunc
    implicit none
    integer :: i
    integer :: func
    i = 3
    print*,"sum of the square and cube of",i," is",func(i)
 end program xfunc
