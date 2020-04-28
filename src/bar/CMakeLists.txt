# This file is part of CMake-codecov.
#
# Copyright (c)
#   2015-2020 RWTH Aachen University, Federal Republic of Germany
#
# See the LICENSE file in the package base directory for details
#
# Written by Alexander Haase, alexander.haase@rwth-aachen.de
#


include_directories(../libfoo ../libheader)
if ("${CMAKE_VERSION}" VERSION_LESS "3.0.2")
	include_directories(../libheader)
endif ()

add_executable(bar bar.c)

target_link_libraries(bar foo)
if ("${CMAKE_VERSION}" VERSION_GREATER "3.0.2")
	target_link_libraries(bar header)
endif()


add_test(test1 ${CMAKE_CURRENT_BINARY_DIR}/bar 1)
add_test(test2 ${CMAKE_CURRENT_BINARY_DIR}/bar 2)
add_test(test3 ${CMAKE_CURRENT_BINARY_DIR}/bar 3)

find_package(codecov)
add_coverage(bar)
