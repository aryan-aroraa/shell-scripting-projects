#!/bin/bash

FREE_SPACE=$(free -mt | grep Total | awk '{print $4}')

threshold=500

if [ $FREE_SPACE -lt $threshold ];
then
	echo "WARNING, RAM is LOW - $FREE_SPACE M"
else
	echo "RAM is SUFFICIENT - $FREE_SPACE M"
fi

