#!/bin/bash -e

## Simple wrapper around SMCIPMITool which waits for it to finish.

/opt/SMCIPMITool/SMCIPMITool "$@" || :

sleep 1

while pkill -0 java;
do \
	sleep 1
done

echo "Finishing..."

exit 0

