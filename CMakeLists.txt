# This file is part of CMake-codecov.
#
# Copyright (c)
#   2015-2017 RWTH Aachen University, Federal Republic of Germany
#
# See the LICENSE file in the package base directory for details
#
# Written by Alexander Haase, alexander.haase@rwth-aachen.de
#


# minimum required cmake version
cmake_minimum_required(VERSION 2.8)


# choose new behaviour for CMP0042
# see http://www.cmake.org/cmake/help/v3.0/policy/CMP0042.html for more details
if (POLICY CMP0042)
	cmake_policy(SET CMP0042 NEW)
endif (POLICY CMP0042)


#
# project information
#
if (${CMAKE_MAJOR_VERSION} EQUAL 3)
	project("test" LANGUAGES C Fortran)
else ()
	project("test" C Fortran)
endif ()


#
# cmake configuration
#
set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake" ${CMAKE_MODULE_PATH})

enable_testing()


# enable code coverage
find_package(codecov)


#
# recurse into subdirectories
#
add_subdirectory(src)


# evaluate coverage
coverage_evaluate()
