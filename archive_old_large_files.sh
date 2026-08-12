#!/bin/bash
#$Revision:001
#Sun Aug  9 15:03:02 UTC 2026

# check command line arguments
if [ $# -eq 0 ];
then
	echo "Missing filepath as an argument"
	echo "USAGE: $0 FILE_PATH"
	exit 1
elif [ $# -gt 1 ];
then
	echo "Too many argument: Only filepath is required as an argument"
	echo "USAGE: $0 FILE_PATH"
	exit 1
fi

filepath=$1

# check if user entered valid filepath
if [ ! -d "$filepath" ];
then
	echo "Filepath doesn't exist"
	exit 1
else
	# check if archive doesn't exist, create one
	if [ ! -d "${filepath}/archive/" ];
	then
		mkdir "${filepath}/archive"
	fi
fi

# Find the list of files larger than 20MB or older than 9 days
for i in $(find "$filepath" -maxdepth 1 -type f -size +20M -o -mtime +9) 
do
	echo "Archiving $(basename $i) ==> ${filepath}archive/"
	gzip "$i" || exit 1
	mv "${i}.gz" "${filepath}/archive/" || exit 1
done


