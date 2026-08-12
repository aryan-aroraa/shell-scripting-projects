#!/bin/bash

FU=$(df -h | grep -vE "Filesystem|tmpfs" | grep "nvme0n1p13" | awk '{print $5}' | tr -d %)

if [ $FU -ge 80 ];
then
	echo "Warning: disk space is low - ${FU}%" 
else
	echo "All good"
fi

