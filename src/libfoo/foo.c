/* This file is part of CMake-codecov.
 *
 * SPDX-FileCopyrightText: RWTH Aachen University, Federal Republic of Germany
 * SPDX-FileContributor: Alexander Haase, alexander.haase@rwth-aachen.de
 *
 * SPDX-License-Identifier: BSD-3-Clause
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
