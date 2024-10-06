#! /bin/bash
printf "%s\n" "$(tput bold)$(date) ${BASH_SOURCE[0]}$(tput sgr0)"

# counts steps in batch process
export counter=0
export SECONDS=0
function new_step(){
    export counter=$((counter+1))
    export subcounter=0
    echo ""; echo ""
    echo "Step ${counter}: ${1}"
}

new_step './facimusFacet ../obj/sphere-010-01.obj'
          ./facimusFacet ../obj/sphere-010-01.obj

new_step './facimusFacet ../obj/sphere-010-02.obj'
          ./facimusFacet ../obj/sphere-010-02.obj

new_step './facimusFacet ../obj/sphere-010-03.obj'
          ./facimusFacet ../obj/sphere-010-03.obj

new_step './facimusFacet ../obj/sphere-010-04.obj'
          ./facimusFacet ../obj/sphere-010-04.obj

new_step './facimusFacet ../obj/sphere-010-05.obj'
          ./facimusFacet ../obj/sphere-010-05.obj

new_step './facimusFacet ../obj/sphere-010-06.obj'
          ./facimusFacet ../obj/sphere-010-06.obj

new_step './facimusFacet ../obj/sphere-010-07.obj'
          ./facimusFacet ../obj/sphere-010-07.obj

new_step './facimusFacet ../obj/sphere-100-01.obj'
          ./facimusFacet ../obj/sphere-100-01.obj

new_step './facimusFacet ../obj/sphere-100-02.obj'
          ./facimusFacet ../obj/sphere-100-02.obj

new_step './facimusFacet ../obj/sphere-100-03.obj'
          ./facimusFacet ../obj/sphere-100-03.obj

new_step './facimusFacet ../obj/sphere-100-04.obj'
          ./facimusFacet ../obj/sphere-100-04.obj

new_step './facimusFacet ../obj/sphere-100-05.obj'
          ./facimusFacet ../obj/sphere-100-05.obj

new_step './facimusFacet ../obj/sphere-100-06.obj'
          ./facimusFacet ../obj/sphere-100-06.obj

new_step './facimusFacet ../obj/sphere-100-07.obj'
          ./facimusFacet ../obj/sphere-100-07.obj

echo ""
echo "time used = ${SECONDS} s"
date

# dantopa:facimusFacet/genesis % source sweep-facets.sh                                                                                                                                        (master)tertius
# Fri Jun 12 08:35:14 MDT 2020
#
#
# Step 1: ./facimusFacet ../obj/sphere-010-01.obj
# There are 42 vertices and 80 faces.
#
# Opening ../obj/sphere-010-01.facet for writing.
#
# CPU time used =      0.161E-02 seconds.
#
# completed at 2020-06-12  8:35:14
#
# compiler version: GCC version 9.3.0.
#
# compiler options: -fdiagnostics-color=auto -fPIC -feliminate-unused-debug-symbols -mmacosx-version-min=10.15.0 -mtune=core2 -auxbase-strip facimusFacet.o -g -Og -Wpedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -finit-derived.
#
# STOP Successful run for "facimusFacet.f08."
#
#
# Step 2: ./facimusFacet ../obj/sphere-010-02.obj
# There are 162 vertices and 320 faces.
#
# Opening ../obj/sphere-010-02.facet for writing.
#
# CPU time used =      0.507E-02 seconds.
#
# completed at 2020-06-12  8:35:14
#
# compiler version: GCC version 9.3.0.
#
# compiler options: -fdiagnostics-color=auto -fPIC -feliminate-unused-debug-symbols -mmacosx-version-min=10.15.0 -mtune=core2 -auxbase-strip facimusFacet.o -g -Og -Wpedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -finit-derived.
#
# STOP Successful run for "facimusFacet.f08."
#
#
# Step 3: ./facimusFacet ../obj/sphere-010-03.obj
# There are 642 vertices and 1280 faces.
#
# Opening ../obj/sphere-010-03.facet for writing.
#
# CPU time used =      0.100E-01 seconds.
#
# completed at 2020-06-12  8:35:14
#
# compiler version: GCC version 9.3.0.
#
# compiler options: -fdiagnostics-color=auto -fPIC -feliminate-unused-debug-symbols -mmacosx-version-min=10.15.0 -mtune=core2 -auxbase-strip facimusFacet.o -g -Og -Wpedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -finit-derived.
#
# STOP Successful run for "facimusFacet.f08."
#
#
# Step 4: ./facimusFacet ../obj/sphere-010-04.obj
# There are 2562 vertices and 5120 faces.
#
# Opening ../obj/sphere-010-04.facet for writing.
#
# CPU time used =      0.455E-01 seconds.
#
# completed at 2020-06-12  8:35:14
#
# compiler version: GCC version 9.3.0.
#
# compiler options: -fdiagnostics-color=auto -fPIC -feliminate-unused-debug-symbols -mmacosx-version-min=10.15.0 -mtune=core2 -auxbase-strip facimusFacet.o -g -Og -Wpedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -finit-derived.
#
# STOP Successful run for "facimusFacet.f08."
#
#
# Step 5: ./facimusFacet ../obj/sphere-010-05.obj
# There are 10242 vertices and 20480 faces.
#
# Opening ../obj/sphere-010-05.facet for writing.
#
# CPU time used =      0.168E+00 seconds.
#
# completed at 2020-06-12  8:35:14
#
# compiler version: GCC version 9.3.0.
#
# compiler options: -fdiagnostics-color=auto -fPIC -feliminate-unused-debug-symbols -mmacosx-version-min=10.15.0 -mtune=core2 -auxbase-strip facimusFacet.o -g -Og -Wpedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -finit-derived.
#
# STOP Successful run for "facimusFacet.f08."
#
#
# Step 6: ./facimusFacet ../obj/sphere-010-06.obj
# There are 40962 vertices and 81920 faces.
#
# Opening ../obj/sphere-010-06.facet for writing.
#
# CPU time used =      0.540E+00 seconds.
#
# completed at 2020-06-12  8:35:15
#
# compiler version: GCC version 9.3.0.
#
# compiler options: -fdiagnostics-color=auto -fPIC -feliminate-unused-debug-symbols -mmacosx-version-min=10.15.0 -mtune=core2 -auxbase-strip facimusFacet.o -g -Og -Wpedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -finit-derived.
#
# STOP Successful run for "facimusFacet.f08."
#
#
# Step 7: ./facimusFacet ../obj/sphere-010-07.obj
# There are 163842 vertices and 327680 faces.
#
# Opening ../obj/sphere-010-07.facet for writing.
#
# CPU time used =      0.218E+01 seconds.
#
# completed at 2020-06-12  8:35:17
#
# compiler version: GCC version 9.3.0.
#
# compiler options: -fdiagnostics-color=auto -fPIC -feliminate-unused-debug-symbols -mmacosx-version-min=10.15.0 -mtune=core2 -auxbase-strip facimusFacet.o -g -Og -Wpedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -finit-derived.
#
# STOP Successful run for "facimusFacet.f08."
#
#
# Step 8: ./facimusFacet ../obj/sphere-100-01.obj
# There are 2562 vertices and 5120 faces.
#
# Opening ../obj/sphere-100-01.facet for writing.
#
# CPU time used =      0.429E-01 seconds.
#
# completed at 2020-06-12  8:35:17
#
# compiler version: GCC version 9.3.0.
#
# compiler options: -fdiagnostics-color=auto -fPIC -feliminate-unused-debug-symbols -mmacosx-version-min=10.15.0 -mtune=core2 -auxbase-strip facimusFacet.o -g -Og -Wpedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -finit-derived.
#
# STOP Successful run for "facimusFacet.f08."
#
#
# Step 9: ./facimusFacet ../obj/sphere-100-02.obj
# There are 10242 vertices and 20480 faces.
#
# Opening ../obj/sphere-100-02.facet for writing.
#
# CPU time used =      0.174E+00 seconds.
#
# completed at 2020-06-12  8:35:17
#
# compiler version: GCC version 9.3.0.
#
# compiler options: -fdiagnostics-color=auto -fPIC -feliminate-unused-debug-symbols -mmacosx-version-min=10.15.0 -mtune=core2 -auxbase-strip facimusFacet.o -g -Og -Wpedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -finit-derived.
#
# STOP Successful run for "facimusFacet.f08."
#
#
# Step 10: ./facimusFacet ../obj/sphere-100-03.obj
# There are 40962 vertices and 81920 faces.
#
# Opening ../obj/sphere-100-03.facet for writing.
#
# CPU time used =      0.597E+00 seconds.
#
# completed at 2020-06-12  8:35:18
#
# compiler version: GCC version 9.3.0.
#
# compiler options: -fdiagnostics-color=auto -fPIC -feliminate-unused-debug-symbols -mmacosx-version-min=10.15.0 -mtune=core2 -auxbase-strip facimusFacet.o -g -Og -Wpedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -finit-derived.
#
# STOP Successful run for "facimusFacet.f08."
#
#
# Step 11: ./facimusFacet ../obj/sphere-100-04.obj
# There are 163842 vertices and 327680 faces.
#
# Opening ../obj/sphere-100-04.facet for writing.
#
# CPU time used =      0.220E+01 seconds.
#
# completed at 2020-06-12  8:35:20
#
# compiler version: GCC version 9.3.0.
#
# compiler options: -fdiagnostics-color=auto -fPIC -feliminate-unused-debug-symbols -mmacosx-version-min=10.15.0 -mtune=core2 -auxbase-strip facimusFacet.o -g -Og -Wpedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -finit-derived.
#
# STOP Successful run for "facimusFacet.f08."
#
#
# Step 12: ./facimusFacet ../obj/sphere-100-05.obj
# There are 655362 vertices and 1310720 faces.
#
# Opening ../obj/sphere-100-05.facet for writing.
#
# CPU time used =      0.849E+01 seconds.
#
# completed at 2020-06-12  8:35:29
#
# compiler version: GCC version 9.3.0.
#
# compiler options: -fdiagnostics-color=auto -fPIC -feliminate-unused-debug-symbols -mmacosx-version-min=10.15.0 -mtune=core2 -auxbase-strip facimusFacet.o -g -Og -Wpedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -finit-derived.
#
# STOP Successful run for "facimusFacet.f08."
#
#
# Step 13: ./facimusFacet ../obj/sphere-100-06.obj
# There are 2621442 vertices and 5242880 faces.
#
# Opening ../obj/sphere-100-06.facet for writing.
#
# CPU time used =      0.356E+02 seconds.
#
# completed at 2020-06-12  8:36:06
#
# compiler version: GCC version 9.3.0.
#
# compiler options: -fdiagnostics-color=auto -fPIC -feliminate-unused-debug-symbols -mmacosx-version-min=10.15.0 -mtune=core2 -auxbase-strip facimusFacet.o -g -Og -Wpedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -finit-derived.
#
# STOP Successful run for "facimusFacet.f08."
#
#
# Step 14: ./facimusFacet ../obj/sphere-100-07.obj
# ERROR: Could not open ../obj/sphere-100-07.obj for reading; file doesn't exist.
# STOP Program termination in module 'mFileHandling', function 'safeopen_readonly'.
#
# time used = 52 s
# Fri Jun 12 08:36:06 MDT 2020
