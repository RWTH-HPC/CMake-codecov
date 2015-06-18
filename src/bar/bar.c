#include <stdio.h>

#include "foo.h"


int
main (int argc, char** argv)
{
	if (argc == 1)
		printf("%d\n", foo());
	else
		printf("%d\n", bar());

	return 0;
}
