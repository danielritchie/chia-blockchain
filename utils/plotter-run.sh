#!/bin/bash


###### MANUAL TODO BEFORE RUNNING THIS 
#
#    git clone https://github.com/danielritchie/chia-blockchain.git -b latest --recurse-submodules
#    ~/chia-blockchain/utils/plotter-run.sh
#    (at end:     aws configure     )
#





#CPU / Scheduling notes
#at 38x4 seems to be pegged CPU BUT also some blips of freedom and underutilized disk
#... may actually be OK since there will be heavy writes when the other ~10+ phases are going
# CPU pegged disk underutilized (have changed config to give first passess of ph1 some breathing room)


sudo apt-get update
sudo apt-get upgrade -y



#####################################
# Install Git
sudo apt install git -y

# INSTALL CHIA
git clone https://github.com/danielritchie/chia-blockchain.git -b latest --recurse-submodules
cd chia-blockchain

sh install.sh


#####################################
. ./activate

chia init


# INSTALL & CONFIG PLOTMAN 
sudo mkdir -p /home/chia/chia/logs
sudo chmod 777 /home/chia/chia/logs

pip install --force-reinstall git+https://github.com/ericaltendorf/plotman@main

######### CONFIG FILE 
#plotman config generate
mkdir -p /home/ubuntu/.config/plotman/
cp ~/chia-blockchain/utils/plotman.yaml /home/ubuntu/.config/plotman/plotman.yaml

## Other goodies 
sudo apt install nmon awscli -y

# Setup directories
sudo mkdir -p /mnt
sudo chmod 777 /mnt
mkdir /mnt/d1
mkdir /mnt/d2
mkdir /mnt/d3
mkdir /mnt/d4
mkdir /mnt/d5
mkdir /mnt/d6
mkdir /mnt/d7
mkdir /mnt/d8

sudo mkfs -t btrfs /dev/nvme0n1
sudo mount /dev/nvme0n1 /mnt/d1

sudo mkfs -t btrfs /dev/nvme1n1
sudo mount /dev/nvme1n1 /mnt/d1

sudo mkfs -t btrfs /dev/nvme2n1
sudo mount /dev/nvme2n1 /mnt/d2

sudo mkfs -t btrfs /dev/nvme3n1
sudo mount /dev/nvme3n1 /mnt/d3

sudo mkfs -t btrfs /dev/nvme4n1
sudo mount /dev/nvme4n1 /mnt/d4

sudo mkfs -t btrfs /dev/nvme5n1
sudo mount /dev/nvme5n1 /mnt/d5

sudo mkfs -t btrfs /dev/nvme6n1
sudo mount /dev/nvme6n1 /mnt/d6

sudo mkfs -t btrfs /dev/nvme7n1
sudo mount /dev/nvme7n1 /mnt/d7

sudo mkfs -t btrfs /dev/nvme8n1
sudo mount /dev/nvme8n1 /mnt/d8

sudo chmod 777 /mnt/* 







### LETS GO!
#tmux new -t plotwatch
nohup ~/chia-blockchain/utils/plotwatcher.sh &

#tmux new -t plotman
. ~/chia-blockchain/activate
#plotman interactive
plotman plot &


echo "Finee!

!!!NOTICE!!!  Must manually configure s3 access with: 

	aws configure
	
"	
###### MANUAL !

##################################################
#aws configure
	######################################### 
	# AWS Access Key ID [None]: *********
	# AWS Secret Access Key [None]: *********
	# Default region name [None]: us-west-2
	# Default output format [None]: text