# Header guard.
# This module must only be included once (via find_package or include). If it
# will be included more than once, there may be problems. The user should not be
# forced to include it in top directory, so this header guard will prevent them
# that this module is only loaded once, even if they include this module in
# every CMake file.
if (DEFINED COVERAGE_HEADER_GUARD)
	return()
endif ()
set(COVERAGE_HEADER_GUARD true)



#
# configuration
#
set(COVERAGE_CFLAGS "-g -O0 --coverage")
set(COVERAGE_LINKER_FLAGS "--coverage")



#
# options
#

# Add an option to choose, if coverage should be enabled or not. If enabled
# marked targets will be build with coverage support and appropriate targets
# will be added. If disabled coverage will be ignored for *ALL* targets.
option(ENABLE_COVERAGE "Enable coverage build." OFF)

# Add an option to choose, if coverage should be enabled for all targets, even
# those which are not explictly marked as coverage targets. If disabled, only
# targets added by add_coverage will be marked for coverage build. This option
# is only available, if coverage was enabled.
if (ENABLE_COVERAGE)
	option(ENABLE_COVERAGE_ALL "Enable coverage build for all targets." OFF)
endif ()



# Add coverage support for target ${TARGET} and register target for gcov. If
# coverage is disabled or not supported, this function will simply do nothing.
#
# Note: This function is defined at the top of this module to explictly define
# add_coverage, even if there is no support for coverage, to not break build-
# scripts.
#
function(add_coverage TNAME)
	# If coverage is disabled, or coverage is already enabled for this target,
	# we can skip the execution of this function.
	if (NOT ENABLE_COVERAGE OR TARGET ${TNAME}-coverage)
		return()
	endif ()

	# create coverage target for this target
	add_custom_target(${TNAME}-coverage DEPENDS ${TNAME})

	# enable coverage for target
	set_target_properties(${TNAME} PROPERTIES
		COMPILE_FLAGS "${COVERAGE_CFLAGS}"
		LINK_FLAGS "${COVERAGE_LINKER_FLAGS}"
	)

	# add gcov execution target
	if (GCOV_FOUND)
		add_gcov_target(${TNAME})
	endif (GCOV_FOUND)
endfunction(add_coverage)



# Exit this module, if coverage is disabled. add_coverage is defined before this
# return, so this module can be exited now safely without breaking any build-
# scripts.
if (NOT ENABLE_COVERAGE)
	return()
endif ()



# Check for coverage compiler flags in C and CXX, if one of those languages is
# enabled. At least one language must pass this test to continue processing this
# module.
include(CheckCCompilerFlag)
include(CheckCXXCompilerFlag)

set(COVERAGE_FOUND false)
get_property(LANGUAGES GLOBAL PROPERTY ENABLED_LANGUAGES)
foreach (LANG ${LANGUAGES})
	# check compiler for coverage support.
	if (${LANG} STREQUAL C)
		set(CMAKE_REQUIRED_FLAGS "${COVERAGE_LINKER_FLAGS}")
		check_c_compiler_flag("${COVERAGE_CFLAGS}" HAVE_COVERAGE_C)
		unset(CMAKE_REQUIRED_FLAGS)

	elseif (${LANG} STREQUAL CXX)
		set(CMAKE_REQUIRED_FLAGS "${COVERAGE_LINKER_FLAGS}")
		check_cxx_compiler_flag("${COVERAGE_CFLAGS}" HAVE_COVERAGE_CXX)
		unset(CMAKE_REQUIRED_FLAGS)
	endif()

	# If compiler supports coverage, announce that we have found a compiler with
	# coverage support.
	if (HAVE_COVERAGE_${LANG})
		set(COVERAGE_FOUND true)
	endif ()
endforeach()

# abort, if no coverage support by compiler. Disable coverage for further
# processing, so add_coverage will ignore it.
if (NOT COVERAGE_FOUND)
	message(WARNING "No compiler supports coverage.")
	set(ENABLE_COVERAGE OFF)
	return()
endif()



# If ENABLE_COVERAGE_ALL is enabled, overload add_executable and add_library
# functions, to add coverage support for *ALL* targets. The functions will call
# the overloaded functions first and then add_coverage.
if (ENABLE_COVERAGE_ALL)
	function(add_executable ARGV)
		_add_executable(${ARGV})
		add_coverage(${ARGV0})
	endfunction(add_executable)

	function(add_library ARGV)
		_add_library(${ARGV})
		add_coverage(${ARGV0})
	endfunction(add_library)
endif ()





#
# Modules for parsing the collected data and output it in a readable format
# (like gcov).
#
include(FindPackageHandleStandardArgs)



#
# gcov
#

# Search for gcov binary.
find_program(GCOV_BIN gcov)
find_package_handle_standard_args(gcov REQUIRED_VARS GCOV_BIN)


# Add a new global target for all gcov targets. This target could be used to
# generate the gcov files for the whole project instead of calling <TARGET>-gcov
# for each target.
if (GCOV_FOUND AND NOT TARGET gcov)
	add_custom_target(gcov)
endif ()


if (GCOV_FOUND)
	# This function will add gcov evaluation for target <TNAME>. Only sources of
	# this target will be evaluated and no dependencies will be added. It will
	# call gcov on any source file of <TNAME> once and store the gcov file in
	# the same directory.
	function (add_gcov_target TNAME)
		set(TDIR ${CMAKE_CURRENT_BINARY_DIR}/CMakeFiles/${TNAME}.dir)

		get_target_property(TSOURCES ${TNAME} SOURCES)
		set(BUFFER "")
		foreach(FILE ${TSOURCES})
			get_filename_component(FILE_PATH "${TDIR}/${FILE}" PATH)

			# call gcov
			add_custom_command(OUTPUT ${TDIR}/${FILE}.gcov
				COMMAND ${GCOV_BIN} ${TDIR}/${FILE}.gcda > /dev/null
				DEPENDS ${TNAME} ${TDIR}/${FILE}.gcda
				WORKING_DIRECTORY ${FILE_PATH}
			)

			list(APPEND BUFFER ${TDIR}/${FILE}.gcov)
		endforeach()

		# add target for gcov evaluation of <TNAME>
		add_custom_target(${TNAME}-gcov DEPENDS ${BUFFER})

		# add evaluation target to <TNAME>-coverage and the global gcov target.
		add_dependencies(${TNAME}-coverage ${TNAME}-gcov)
		add_dependencies(gcov ${TNAME}-gcov)
	endfunction (add_gcov_target)
endif (GCOV_FOUND)
