#include "types.h"
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
	if (argc == 2) {
		setp(atoi(argv[1]));
	}
	else {
		printf(1, "Error!");
	}

	return 0;
}