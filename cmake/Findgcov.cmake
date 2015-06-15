#
# include required modules
#
include(CheckCCompilerFlag)
include(CheckCXXCompilerFlag)
include(FindPackageHandleStandardArgs)


# search for gcov
find_program(GCOV_BIN gcov)

# check if compiler accepts
set(CMAKE_REQUIRED_FLAGS "-fprofile-arcs -ftest-coverage")

# check for C
check_c_compiler_flag("-fprofile-arcs -ftest-coverage" C_COMPILER_HAVE_GCOV)
if (C_COMPILER_HAVE_GCOV OR CXX_COMPILER_HAVE_GCOV)
	set(CMAKE_C_FLAGS ${CMAKE_C_FLAGS} "-fprofile-arcs -ftest-coverage")
endif ()

# check for CXX
check_cxx_compiler_flag("-fprofile-arcs -ftest-coverage" CXX_COMPILER_HAVE_GCOV)
if (CXX_COMPILER_HAVE_GCOV)
	set(CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS} "-fprofile-arcs -ftest-coverage")
endif ()

find_package_handle_standard_args(gcov REQUIRED_VARS GCOV_BIN)
