#!/bin/bash
	
cd /home/ubuntu/chia-blockchain/
. ./activate

#SET some params 

PLOT_BYTES=4096
PLOT_THREADS=4
PLOTS_IN_PARALLEL=6
PLOT_STAGGER_TIME=20

#Collect some info
PUBLIC_IP=`curl http://169.254.169.254/latest/meta-data/public-ipv4`
LOCAL_HOSTNAME=`curl http://169.254.169.254/latest/meta-data/local-hostname`
INSTANCE_TYPE=`curl http://169.254.169.254/latest/meta-data/instance-type`
INSTANCE_ID=`curl http://169.254.169.254/latest/meta-data/instance-id`
TMP_DIR="/mnt"
OUTPUT_DIR="/mnt"


CURRENT_PLOT=0

while [[ $CURRENT_PLOT -lt $PLOTS_IN_PARALLEL ]]; do

	#increment
	CURRENT_PLOT=$((++CURRENT_PLOT))
	
	echo "Current Plot: $CURRENT_PLOT of $PLOTS_IN_PARALLEL"
		
	DATE_PREFIX=`date '+%Y-%m-%d_%H-%M-%S-%N'`
	PLOT_DIR="${TMP_DIR}/plotlogs"
	mkdir -p $PLOT_DIR
	PLOT_LOGFILE="${PLOT_DIR}/${DATE_PREFIX}_${INSTANCE_ID}.log"


	###DEBUG
	echo "Now Plotting...
	PUBLIC_IP: $PUBLIC_IP
	LOCAL_HOSTNAME: $LOCAL_HOSTNAME
	INSTANCE_TYPE: $INSTANCE_TYPE
	INSTANCE_ID: $INSTANCE_ID
	PLOT_BYTES: $PLOT_BYTES
	PLOT_THREADS: $PLOT_THREADS
	DATE_PREFIX: $DATE_PREFIX
	PLOT_LOGFILE: $PLOT_LOGFILE
	"

	#Create Log file w/Header
	echo "################ PLOT KING 9000 ###################
	
	PUBLIC_IP: $PUBLIC_IP
	LOCAL_HOSTNAME: $LOCAL_HOSTNAME
	INSTANCE_TYPE: $INSTANCE_TYPE
	INSTANCE_ID: $INSTANCE_ID

	" > $PLOT_LOGFILE

	# Run the whole thing in the background (has to be a better way!)
	{ time chia plots create -k 32 -b $PLOT_BYTES -r $PLOT_THREADS -u 128 -n 1 -t ${TMP_DIR} -d ${OUTPUT_DIR} -f a4ab1f8213ebc06cbce49bf56b923467cf3263fdf587efff5ef0b71635f7c5b51d239046586354db24dfab188071d978 -p 96cbc06eb710bb3c43e8a64208dd49bce37cf440ca1c2bd6ee3c99124818c8ad0520d0b3f401151148a3a0e3c97f9f03;echo "**************** PLOTTING COMPLETE ****************" &>> $PLOT_LOGFILE ;aws s3 mv ${OUTPUT_DIR} s3://lotsoplots --recursive --exclude "*" --include "*.plot" --exclude "*/*"; aws s3 cp $PLOT_LOGFILE s3:/lotsoplots/plotlogs/; } &
	
	
	echo "Finished starting: $CURRENT_PLOT"
	echo "Waiting $PLOT_STAGGER_TIME minutes before starting next plot..."
	sleep "${PLOT_STAGGER_TIME}m"
done

echo "
DONE!  Make sure to check for processes and ${OUTPUT_DIR} dir for plots before shutting down!
"