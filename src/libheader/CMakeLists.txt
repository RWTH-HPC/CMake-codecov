# This file is part of CMake-codecov.
#
# Copyright (c)
#   2015-2020 RWTH Aachen University, Federal Republic of Germany
#
# See the LICENSE file in the package base directory for details
#
# Written by Alexander Haase, alexander.haase@rwth-aachen.de
#

if ("${CMAKE_VERSION}" VERSION_GREATER "3.0.2")
	add_library(header INTERFACE)
	target_include_directories(header INTERFACE ${CMAKE_CURRENT_SOURCE_DIR})
endif ()
