/* This file is part of CMake-codecov.
 *
 * SPDX-FileCopyrightText: RWTH Aachen University, Federal Republic of Germany
 * SPDX-FileContributor: Alexander Haase, alexander.haase@rwth-aachen.de
 *
 * SPDX-License-Identifier: BSD-3-Clause
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
