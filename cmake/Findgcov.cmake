#
# include required modules
#
include(CheckCCompilerFlag)
include(CheckCXXCompilerFlag)
include(FindPackageHandleStandardArgs)


#
# check for coverage compiler flags
#
set(CMAKE_REQUIRED_FLAGS "--coverage")

# check for compile flags
foreach (LANG C CXX)
	if (CMAKE_${LANG}_COMPILER_LOADED)
		if (${LANG} STREQUAL C)
			check_c_compiler_flag("-g -O0 --coverage" HAVE_COVERAGE_C)
		elseif (${LANG} STREQUAL CXX)
			check_cxx_compiler_flag("-g -O0 --coverage" HAVE_COVERAGE_CXX)
		endif()

		if (HAVE_COVERAGE_${LANG})
			set(CMAKE_${LANG}_FLAGS_COVERAGE
				"-g -O0 --coverage"
				CACHE
				STRING "Flags used by the ${LANG} compiler during coverage builds."
			)
			mark_as_advanced(CMAKE_${LANG}_FLAGS_COVERAGE)
		endif (HAVE_COVERAGE_${LANG})
	endif (CMAKE_${LANG}_COMPILER_LOADED)
endforeach()

# set linker flags
if (HAVE_COVERAGE_C OR HAVE_COVERAGE_CXX)
	set(CMAKE_EXE_LINKER_FLAGS_COVERAGE
		"--coverage"
		CACHE
		STRING "Flags used for linking binaries during coverage builds."
	)

	set(CMAKE_MODULE_LINKER_FLAGS_COVERAGE
		"--coverage"
		CACHE
		STRING "Flags used for linking modules during coverage builds."
	)

	set(CMAKE_SHARED_LINKER_FLAGS_COVERAGE
		"--coverage"
		CACHE
		STRING "Flags used for linking shared libraries during coverage builds."
	)

	set(CMAKE_STATIC_LINKER_FLAGS_COVERAGE
		"--coverage"
		CACHE
		STRING "Flags used for linking static libraries during coverage builds."
	)

	mark_as_advanced(
		CMAKE_EXE_LINKER_FLAGS_COVERAGE
		CMAKE_MODULE_LINKER_FLAGS_COVERAGE
		CMAKE_SHARED_LINKER_FLAGS_COVERAGE
		CMAKE_STATIC_LINKER_FLAGS_COVERAGE
	)
endif ()



#
# collect gcov information for target
#
find_program(GCOV_BIN gcov)
find_package_handle_standard_args(gcov REQUIRED_VARS GCOV_BIN)


if (NOT TARGET gcov AND GCOV_FOUND)
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
				COMMAND ${GCOV_BIN} ${TARGET_DIR}/${FILE}.gcno > /dev/null
				DEPENDS ${TARGET}
					${TARGET_DIR}/${FILE}.gcda
					${TARGET_DIR}/${FILE}.gcno
				WORKING_DIRECTORY ${FILE_PATH}
			)

			list(APPEND BUFFER ${TARGET_DIR}/${FILE}.gcov)
		endforeach()

		add_custom_target(${TARGET}-gcov
			DEPENDS ${BUFFER}
		)

		add_dependencies(gcov ${TARGET}-gcov)
	endfunction (add_gcov_target)
endif (GCOV_FOUND)



#
# add coverage to target and register target for gcov
#
function(add_coverage TARGET)
	# enable coverage for target
	set_target_properties(${TARGET} PROPERTIES
		COMPILE_FLAGS "-g -O0 --coverage"
		LINK_FLAGS "--coverage"
	)

	if (GCOV_FOUND)
		add_gcov_target(${TARGET})
	endif (GCOV_FOUND)
endfunction(add_coverage)
