#!/bin/bash

### Special Variables ###

echo "All args passed to the script: $@"
echo "All args passed to the script as word: $*"
echo "Number of args passed to the script: $#"
echo "First variable passed: $1"
echo "Script name: $0"
echo "Realpath: $(realpath $0)"
echo "Who is running the current script: $USER"
echo "Directory of the current script: $PWD"
echo "Home directory of the current script: $HOME"
echo "PID of the current script: $$"
sleep 10 &
echo "PID of the command running in the background: $!"
wait $! # here script will wait until $! command complete
echo "Line number: $LINENO"
echo "Previous command exit status: $?"
echo "Total time executed for the script:$SECONDS"
