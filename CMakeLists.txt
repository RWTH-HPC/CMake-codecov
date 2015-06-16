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
project("test")

#
# cmake configuration
#
set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake" ${CMAKE_MODULE_PATH})

enable_testing()

#
# recurse into subdirectories
#
add_subdirectory(src)
