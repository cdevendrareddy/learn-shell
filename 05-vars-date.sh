#!/bin/bash

START_TIME=$(date +%s)
echo "script started execution at: $START_TIME seconds"

sleep 10

END_TIME=$(date +%s)
echo "script completed execution at: $END_TIME seconds"

TOTAL_TIME=$(($END_TIME-$START_TIME))
echo "total time taken: $TOTAL_TIME seconds"