# This file is part of CMake-codecov.
#
# Copyright (c)
#   2015-2020 RWTH Aachen University, Federal Republic of Germany
#
# See the LICENSE file in the package base directory for details
#
# Written by Alexander Haase, alexander.haase@rwth-aachen.de
#


add_library(foo SHARED foo.c bar.c)
add_coverage(foo)
