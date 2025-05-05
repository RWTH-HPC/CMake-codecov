# This file is part of CMake-codecov.
#
# SPDX-FileCopyrightText: RWTH Aachen University, Federal Republic of Germany
# SPDX-FileContributor: Alexander Haase, alexander.haase@rwth-aachen.de
#
# SPDX-License-Identifier: BSD-3-Clause

add_executable(hello_fortran hello.f)
add_coverage(hello_fortran)
add_test(test_fortran hello_fortran)
