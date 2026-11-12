#!/bin/bash

user_id=$(id -u)
logs_folder="/var/log/shell-practice"
logs_file="${logs_folder}/${0}.log"
if [ $user_id -ne 0 ]; then #ne means not equal to
   echo "Please run the script with sudo access"
   exit 1
fi

mkdir -p $logs_folder
echo "Script execution started at $(date  +"%F %T")" | tee -a $logs_file
validate(){
    if [ $1 -ne 0 ]; then
        echo "$2 is failed.." | tee -a $logs_file
        exit 1
    else
         echo "$2 is success.." | tee -a $logs_file
fi

}

for package in $@
do 
    dnf list installed $package
    if [ $? -ne 0 ]; then
       echo "$package is not installed, going to install it"
    else
       echo "$package is already installed, skipping it"
    fi 
    dnf install $package -y &>> $logs_file
    validate $? "$package installation"
done