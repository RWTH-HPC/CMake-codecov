# This file is part of CMake-codecov.
#
# Copyright (c)
#   2015-2020 RWTH Aachen University, Federal Republic of Germany
#
# See the LICENSE file in the package base directory for details
#
# Written by Alexander Haase, alexander.haase@rwth-aachen.de
#


# minimum required cmake version
cmake_minimum_required(VERSION 3.10)

#
# project information
#
project("test" LANGUAGES C)

#
# check for Fortran support
#
include(CheckLanguage)
check_language(Fortran)
if(CMAKE_Fortran_COMPILER)
  enable_language(Fortran)


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
