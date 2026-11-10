#!/bin/bash

user_id=$(id -u)

if [ $user_id -ne 0 ]; then
   echo "Please run the script with sudo access"
   exit 1
fi
echo "proceeding.."

dnf install nginx -y
if [ $? -ne 0 ]; then
    echo "Nginx Installation is failed"
    exit 1
else
    echo "Nginx Installation is success"
fi

dnf install mysqll -y
if [ $? -ne 0 ]; then
   echo "Mysql client installation is failed"
   exit 1
else
   echo "Mysql Client installation is success"
fi

echo "script executed successfully"
