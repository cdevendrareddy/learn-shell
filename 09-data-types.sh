#!/bin/bash

var1=10
var2=20
var3=dev

echo "$var1+$var2"
echo "$(var1+var2)"
echo "$($var1+$var2)"
echo "$(($var1+$var2))"