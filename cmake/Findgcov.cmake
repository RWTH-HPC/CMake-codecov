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
function(add_coverage TARGET)
	if (ENABLE_COVERAGE)
		# enable coverage for target
		set_target_properties(${TARGET} PROPERTIES
			COMPILE_FLAGS "${COVERAGE_CFLAGS}"
			LINK_FLAGS "${COVERAGE_LINKER_FLAGS}"
		)

		if (GCOV_FOUND)
			add_gcov_target(${TARGET})
		endif (GCOV_FOUND)
	endif(ENABLE_COVERAGE)
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



#
# collect gcov information for target
#
include(FindPackageHandleStandardArgs)

find_program(GCOV_BIN gcov)
find_package_handle_standard_args(gcov REQUIRED_VARS GCOV_BIN)


# Add a new global target for all gcov targets. This target could be used to
# generate the gcov files for the whole project.
if (GCOV_FOUND AND NOT TARGET gcov)
	add_custom_target(gcov)
endif ()

if (GCOV_FOUND)
	function (add_gcov_target TARGET)
		set(TARGET_DIR ${CMAKE_CURRENT_BINARY_DIR}/CMakeFiles/${TARGET}.dir)

		get_target_property(TARGET_SOURCES ${TARGET} SOURCES)
		set(BUFFER "")
		foreach(FILE ${TARGET_SOURCES})
			get_filename_component(FILE_PATH "${TARGET_DIR}/${FILE}" PATH)

			add_custom_command(OUTPUT ${TARGET_DIR}/${FILE}.gcov
				COMMAND ${GCOV_BIN} ${TARGET_DIR}/${FILE}.gcda > /dev/null
				DEPENDS ${TARGET} ${TARGET_DIR}/${FILE}.gcda
				WORKING_DIRECTORY ${FILE_PATH}
			)

			list(APPEND BUFFER ${TARGET_DIR}/${FILE}.gcov)
		endforeach()

		add_custom_target(${TARGET}-gcov DEPENDS ${BUFFER})
		add_dependencies(gcov ${TARGET}-gcov)
	endfunction (add_gcov_target)
endif (GCOV_FOUND)
