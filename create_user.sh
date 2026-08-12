#!/bin/bash

# check if user is root
if [ "$UID" -ne 0 ];
then
	echo "Requires root access"
	exit 1
fi

# check if user provided command line arguments, if not guide him
if [ $# -eq 0 ];
then
	echo "Usage: ./$(basename $0) USER_NAME [COMMENT]"
	exit 1
fi

# Assign variables to username and comment
USER_NAME="$1"
shift 
COMMENT="$@"

# generate a password
PASSWORD=$(openssl rand -base64 18)

# add user
useradd -c "$COMMENT" -m "$USER_NAME"

# check if user created successfully
if [ $? -ne 0 ];
then
	echo "ERROR: User creation unsuccessful!"
	exit 1
fi

# assign generated password to user
echo "$USER_NAME:$PASSWORD" | chpasswd

# check if password assigning failed
if [ $? -ne 0 ];
then
	echo "ERROR: Failed at password creation"
	exit 1
fi

# Force user to change password on  next login
passwd -e "$USER_NAME"

# Display Info
echo "------------------"
echo "User added: $USER_NAME"
echo "Password: $PASSWORD"
echo "Hostname: $(hostname)"
echo "------------------"
