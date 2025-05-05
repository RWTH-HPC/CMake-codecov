# This file is part of CMake-codecov.
#
# SPDX-FileCopyrightText: RWTH Aachen University, Federal Republic of Germany
# SPDX-FileContributor: Alexander Haase, alexander.haase@rwth-aachen.de
#
# SPDX-License-Identifier: BSD-3-Clause


include_directories(../libfoo ../libheader)
add_executable(bar bar.c)
target_link_libraries(bar foo)
target_link_libraries(bar header)

add_test(test1 ${CMAKE_CURRENT_BINARY_DIR}/bar 1)
add_test(test2 ${CMAKE_CURRENT_BINARY_DIR}/bar 2)
add_test(test3 ${CMAKE_CURRENT_BINARY_DIR}/bar 3)

find_package(codecov)
add_coverage(bar)
