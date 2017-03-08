/* This file is part of CMake-codecov.
 *
 * Copyright (c)
 *  2015-2017 RWTH Aachen University, Federal Republic of Germany
 *
 * See the LICENSE file in the package base directory for details
 *
 * Written by Alexander Haase, alexander.haase@rwth-aachen.de
 */


#include "foo.h"

int
foo ()
{
	int i = 0;
	while (i < 10)
		i++;

	return i;
}
