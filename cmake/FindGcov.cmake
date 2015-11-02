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


# include required Modules
include(FindPackageHandleStandardArgs)


# Search for gcov binary.
find_program(GCOV_BIN gcov)
find_package_handle_standard_args(gcov REQUIRED_VARS GCOV_BIN)


# If Gcov was not found, exit module now.
if (NOT GCOV_FOUND)
	return()
endif (NOT GCOV_FOUND)



# Add a new global target for all gcov targets. This target could be used to
# generate the gcov files for the whole project instead of calling <TARGET>-gcov
# for each target.
if (NOT TARGET gcov)
	add_custom_target(gcov)
endif (NOT TARGET gcov)



# This function will add gcov evaluation for target <TNAME>. Only sources of
# this target will be evaluated and no dependencies will be added. It will call
# Gcov on any source file of <TNAME> once and store the gcov file in the same
# directory.
function (add_gcov_target TNAME)
	set(TDIR ${CMAKE_CURRENT_BINARY_DIR}/CMakeFiles/${TNAME}.dir)

	get_target_property(TSOURCES ${TNAME} SOURCES)
	set(BUFFER "")
	foreach(FILENAME ${TSOURCES})
		string(REGEX MATCH "TARGET_OBJECTS:([^ >]+)" _source ${FILENAME})

		# If expression was found, FILENAME is a generator-expression for an
		# object library. Currently we found no way to call this function
		# automatic for the referenced target, so it must be called in the
		# directoryso of the object library definition.
		if ("${_source}" STREQUAL "")
			# get the right path for file
			string(REPLACE ".." "__" FILE "${FILENAME}")

			get_filename_component(FILE_PATH "${TDIR}/${FILE}" PATH)

			# call gcov
			add_custom_command(OUTPUT ${TDIR}/${FILE}.gcov
				COMMAND ${GCOV_BIN} ${TDIR}/${FILE}.gcno > /dev/null
				DEPENDS ${TNAME} ${TDIR}/${FILE}.gcno
				WORKING_DIRECTORY ${FILE_PATH}
			)

			list(APPEND BUFFER ${TDIR}/${FILE}.gcov)
		endif()
	endforeach()

	# add target for gcov evaluation of <TNAME>
	add_custom_target(${TNAME}-gcov DEPENDS ${BUFFER})

	# add evaluation target to the global gcov target.
	add_dependencies(gcov ${TNAME}-gcov)
endfunction (add_gcov_target)
