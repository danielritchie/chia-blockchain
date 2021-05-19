######################################################
### PLOTTER SETUP
######################################################
#
#IAM Role
#Security Group 
#######################################################



exit "not ready for prime time... need to cleanup and new AMI before running"

# Setup
#sudo apt install awscli -y
#sudo mkdir /tmpdisk
#sudo chmod 777 /tmpdisk
#sudo vi /etc/fstab

	#for h1.2xlarge: /dev/xvdb       /tmpdisk        auto    defaults,nofail,x-systemd.requires=cloud-init.service,comment=cloudconfig       0       2
	
	#for m5n:
	#/dev/nvme1n1 /tmpdisk              ext4    defaults                0 0


#TBD other fs types (theoretically btrfs looks like best balance of quality/speed, also need to check plots from it)
sudo mkfs -t btrfs /dev/xvdc
#sudo cfdisk /dev/xvdb
sudo mount -a
sudo chmod 777 /mnt



#// TBD for current image: sudo resize2fs /dev/nvme1n1




### PLOT 

tmux new -s plot

cd /home/ubuntu/chia-blockchain/
. ./activate


# Threads in parallel
#time chia plots create -k 32 -b 5120 -r 2 -u 128 -n 5 -t /tmpdisk -d /tmpdisk -f a4ab1f8213ebc06cbce49bf56b923467cf3263fdf587efff5ef0b71635f7c5b51d239046586354db24dfab188071d978 -p 96cbc06eb710bb3c43e8a64208dd49bce37cf440ca1c2bd6ee3c99124818c8ad0520d0b3f401151148a3a0e3c97f9f03

#SET & Collect some info to be used later 
PLOT_BYTES=4096
PLOT_THREADS=4
PLOTS_IN_PARALLEL=6
PLOT_STAGGER_TIME=20
PUBLIC_IP=`curl http://169.254.169.254/latest/meta-data/public-ipv4`
LOCAL_HOSTNAME=`curl http://169.254.169.254/latest/meta-data/local-hostname`
INSTANCE_TYPE=`curl http://169.254.169.254/latest/meta-data/instance-type`
INSTANCE_ID=`curl http://169.254.169.254/latest/meta-data/instance-id`
DATE_PREFIX=`date '+%Y-%m-%d_%H-%M-%S-%N'`
PLOT_LOGFILE="/mnt/plotlogs/${DATE_PREFIX}_${INSTANCE_ID}"

###DEBUG
echo "PUBLIC_IP: $PUBLIC_IP
LOCAL_HOSTNAME: $LOCAL_HOSTNAME
INSTANCE_TYPE: $INSTANCE_TYPE
INSTANCE_ID: $INSTANCE_ID
PLOT_BYTES: $PLOT_BYTES
PLOT_THREADS: $PLOT_THREADS
DATE_PREFIX: $DATE_PREFIX
PLOT_LOGFILE: $PLOT_LOGFILE"


#Create Log file w/Header
echo "################ PLOT KING 9000 ###################
PUBLIC_IP: $PUBLIC_IP
LOCAL_HOSTNAME: $LOCAL_HOSTNAME
INSTANCE_TYPE: $INSTANCE_TYPE
INSTANCE_ID: $INSTANCE_ID

" > $PLOT_LOGFILE

#One thread, plenty of overhead w/leftover GB's
# IS TMPDISK THE RIGHT OUTPUT?
time chia plots create -k 32 -b $PLOT_BYTES -r $PLOT_THREADS -u 128 -n 1 -t /mnt -d /mnt -f a4ab1f8213ebc06cbce49bf56b923467cf3263fdf587efff5ef0b71635f7c5b51d239046586354db24dfab188071d978 -p 96cbc06eb710bb3c43e8a64208dd49bce37cf440ca1c2bd6ee3c99124818c8ad0520d0b3f401151148a3a0e3c97f9f03;echo "**************** PLOTTING COMPLETE ****************" >> $PLOT_LOGFILE;aws s3 mv /mnt s3://lotsoplots --recursive --exclude "*" --include "*.plot" --exclude "*/*"; aws s3 cp $PLOT_LOGFILE s3:/lotsoplots/plotlogs/ ; echo "CHECK for processes and /mnt dir for plots before shutting down!"

#TBD: rm -rf /tmpdisk???? - can't remove all because it's too large, what's left???

### No need to spend money on the instnace if done plotting
sudo shutdown









