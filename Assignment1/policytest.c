#include "types.h"
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
	int x;
	int y;
	int ret_of_child;
	printf(1, "started \n");
	x = fork();
	if (x == 0) {
		priority(0);
		sleep(1);
		return 3;
	}
	else {
		y = fork();
		if (y == 0)
			return 5;
		else {
			wait(&ret_of_child);
			printf(1, "ret of child : %d\n", ret_of_child);
		}
		wait(&ret_of_child);
		printf(1, "ret of child : %d\n", ret_of_child);
	}
	return 4;
}