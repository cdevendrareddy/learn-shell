#!/bin/bash

var1=10
var2=20
var3=dev

echo "$var1+$var2+$var3"
echo "$(var1+var2+var3)"
echo "$((var1+var2+var3))"
echo "$(($var1+$var2+$var3))"

declare -i COUNT=5 #I'm declaring as Integer
COUNT=COUNT+1
echo "count is :: $COUNT"

FRUITS=("Apple" "Banana" "Papaya")
echo "ALL FRUITS: ${FRUITS[@]}"
echo "First Fruit: ${FRUITS[0]}"