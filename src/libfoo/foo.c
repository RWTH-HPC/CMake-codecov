/* This file is part of CMake-codecov.
 *
 * CMake-codecov is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the Free
 * Software Foundation, either version 3 of the License, or (at your option) any
 * later version.
 *
 * This program is distributed in the hope that it will be useful,but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License and GNU
 * Lesser General Public License along with this program. If not, see
 *
 *  http://www.gnu.org/licenses/
 *
 *
 * Copyright (c)
 *  2015 RWTH Aachen University, Federal Republic of Germany
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
