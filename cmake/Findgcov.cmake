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
if (C_COMPILER_HAVE_GCOV)
	set(CMAKE_C_FLAGS ${CMAKE_C_FLAGS} "-fprofile-arcs -ftest-coverage")
endif ()

# check for CXX
check_cxx_compiler_flag("-fprofile-arcs -ftest-coverage" CXX_COMPILER_HAVE_GCOV)
if (CXX_COMPILER_HAVE_GCOV)
	set(CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS} "-fprofile-arcs -ftest-coverage")
endif ()

find_package_handle_standard_args(gcov REQUIRED_VARS GCOV_BIN)




#
# collect gcov information for target
#
function(add_coverage TARGET)
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

	add_custom_target(${TARGET}-coverage
		DEPENDS ${BUFFER}
	)
endfunction(add_coverage)
