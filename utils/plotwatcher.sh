#!/bin/bash

#nohup plotwatcher.sh &

DIRCHECK=`ls -d /mnt/*/ | grep -v lost+found > /dev/null ; echo $?`
if [[ "$DIRCHECK" == "0" ]]; then 
	# There are sub-dirs
	OUTDIRS=`ls -d /mnt/*/`
else
	# there is only the /mnt dir 
	OUTDIRS="/mnt/"
fi 

echo "OUTDIRS: $OUTDIRS"

SEEK_PLOTS=true
while [[ $SEEK_PLOTS ]]; do

    for WORKDIR in $OUTDIRS ; do

        echo "Checking: ${WORKDIR}"
		PLOT_CHECK=`ls ${WORKDIR}/*.plot &> /dev/null; echo $?`
		
		if [[ "$PLOT_CHECK" == "0" ]]; then
		
			echo "Found plot in ${WORKDIR}! Moving..."
		
			# Plots found, let's move them!
			aws s3 mv ${WORKDIR} s3://lotsoplots --recursive --exclude "*" --include "*.plot" --exclude "*/*"
		fi 	
	done
	echo "   Waiting a minute before checking for plots ..."
	sleep 60
	
done