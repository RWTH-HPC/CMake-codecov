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
	endforeach()

	# add target for gcov evaluation of <TNAME>
	add_custom_target(${TNAME}-gcov DEPENDS ${BUFFER})

	# add evaluation target to the global gcov target.
	add_dependencies(gcov ${TNAME}-gcov)
endfunction (add_gcov_target)
