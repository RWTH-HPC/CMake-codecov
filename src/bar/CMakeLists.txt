# This file is part of CMake-codecov.
#
# CMake-codecov is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful,but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
# more details.
#
# You should have received a copy of the GNU General Public License and GNU
# Lesser General Public License along with this program. If not, see
#
#  http://www.gnu.org/licenses/
#
#
# Copyright (c)
#   2015 RWTH Aachen University, Federal Republic of Germany
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
