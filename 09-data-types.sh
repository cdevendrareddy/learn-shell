#!/bin/bash

var1=10
var2=20
var3=dev

echo "$var1+$var2+$var3"
echo "$(var1+var2+var3)"
echo "$((var1+var2+var3))"
echo "$(($var1+$var2+$var3))"

declare -i COUNT=5
COUNT=COUNT+1
echo "count is :: $COUNT"
echo "count is :: COUNT"