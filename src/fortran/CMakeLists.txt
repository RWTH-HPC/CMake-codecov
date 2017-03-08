# This file is part of CMake-codecov.
#
# Copyright (c)
#   2015-2017 RWTH Aachen University, Federal Republic of Germany
#
# See the LICENSE file in the package base directory for details
#
# Written by Alexander Haase, alexander.haase@rwth-aachen.de
#

add_executable(hello_fortran hello.f)
add_coverage(hello_fortran)
add_test(test_fortran hello_fortran)
