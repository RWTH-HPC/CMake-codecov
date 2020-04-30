# This file is part of CMake-codecov.
#
# Copyright (c)
#   2015-2019 RWTH Aachen University, Federal Republic of Germany
#
# See the LICENSE file in the package base directory for details
#
# Written by Alexander Haase, alexander.haase@rwth-aachen.de
#


# configuration
set(GCOVR_HTML_PATH "${CMAKE_BINARY_DIR}/gcovr/html")
set(GCOVR_SONAR_PATH "${CMAKE_BINARY_DIR}/gcovr/sonar")


# Search for Gcov which is used by Gcovr.
find_package(Gcov)

# include required Modules
include(FindPackageHandleStandardArgs)

# Search for required gcovr binaries.
find_program(GCOVR_BIN gcovr)
find_package_handle_standard_args(Gcovr
	REQUIRED_VARS GCOVR_BIN
)

# If Gcovr was not found, exit module now.
if (NOT GCOVR_FOUND)
	return()
endif (NOT GCOVR_FOUND)

# Add a new global target for all gcovr targets. This target could be used to
# generate the gcovr files for the whole project instead of calling <TARGET>-gcovr
# for each target.
if (NOT TARGET gcovr)
	add_custom_target(gcovr)
endif (NOT TARGET gcovr)

include(ProcessorCount)

# This function will add gcovr evaluation for target <TNAME>. All Sources in
# this target's SOURCE_DIR  will be evaluated and no dependencies will be added. It will call
# Gcovr on <TNAME> once and generate HTML & SONARQUBE file.
function (add_gcovr_target TNAME)
	if (NOT GCOVR_FOUND)
		return()
	endif()
	get_target_property(TBIN_DIR ${TNAME} BINARY_DIR)
	set(TDIR ${TBIN_DIR}/CMakeFiles/${TNAME}.dir)
	
	# We don't have to check, if the target has support for coverage, thus this
	# will be checked by add_coverage_target in Findcoverage.cmake. Instead we
	# have to determine which gcov binary to use.
	get_target_property(TSOURCES ${TNAME} SOURCES)
	set(TCOMPILER "")
	foreach (FILE ${TSOURCES})
		codecov_path_of_source(${FILE} FILE)
		if (NOT "${FILE}" STREQUAL "")
			codecov_lang_of_source(${FILE} LANG)
			if (NOT "${LANG}" STREQUAL "")
				set(TCOMPILER ${CMAKE_${LANG}_COMPILER_ID})
			endif ()
		endif ()
	endforeach ()

	# If no gcov binary was found, coverage data can't be evaluated.
	if (NOT GCOV_${TCOMPILER}_BIN)
		message(WARNING "No coverage evaluation binary found for ${TCOMPILER}.")
		return()
	endif ()

	ProcessorCount(N)
	if(N EQUAL 0)
		set(N 1)
	endif()

	get_target_property(TSRC_DIR ${TNAME} SOURCE_DIR)
	file(MAKE_DIRECTORY ${GCOVR_HTML_PATH}/${TNAME})
	file(MAKE_DIRECTORY ${GCOVR_SONAR_PATH}/${TNAME})
	set(OUTPUT_HTML_FILE ${GCOVR_HTML_PATH}/${TNAME}/index.html)
	set(OUTPUT_SONAR_FILE ${GCOVR_SONAR_PATH}/${TNAME}/coverage.xml)
	add_custom_command(OUTPUT ${OUTPUT_HTML_FILE} ${OUTPUT_SONAR_FILE}
					COMMAND ${GCOVR_BIN} -r ${TSRC_DIR} -p -j ${N} --html-details ${OUTPUT_HTML_FILE} --sonarqube ${OUTPUT_SONAR_FILE}
					DEPENDS ${TNAME}
					WORKING_DIRECTORY ${TBIN_DIR})


	# add target for gcovr evaluation of <TNAME>
	add_custom_target(${TNAME}-gcovr DEPENDS ${OUTPUT_HTML_FILE} ${OUTPUT_SONAR_FILE})

	# add evaluation target to the global gcovr target.
	add_dependencies(gcovr ${TNAME}-gcovr)
endfunction (add_gcovr_target)
