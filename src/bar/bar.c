/* This file is part of CMake-codecov.
 *
 * Copyright (c)
 *  2015-2017 RWTH Aachen University, Federal Republic of Germany
 *
 * See the LICENSE file in the package base directory for details
 *
 * Written by Alexander Haase, alexander.haase@rwth-aachen.de
 */


#include <stdio.h>

#include "foo.h"
#include <header.h>

int
main (int argc, char** argv)
{
	if (*argv[1] == '1')
		printf("%d\n", foo());
	else if (*argv[1] == '2')
		printf("%d\n", bar());
	else if (*argv[1] == '3')
		header_func();

	return 0;
}
