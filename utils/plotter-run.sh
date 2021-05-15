######################################################
### PLOTTER SETUP
######################################################
#2cpu/8gb/2 threads m5n.large - too slow + disk bound
#2cpu/8gb/1 thread m5n.large
#2cpu/8gb?/1 thread - OK, time TBD
#4cpu/8gb/2 threds

#st1 HDD (gp3 vs. st1 TBD... maybe both are too slow, at least thread contention)

#IAM Role
#Security Group 
#######################################################

# Setup
sudo apt install awscli -y
sudo mkdir /tmpdisk
sudo vi /etc/fstab
	/dev/nvme1n1 /tmpdisk              ext4    defaults                0 0
sudo mount -a

// TBD: sudo resize2fs /dev/nvme1n1




### PLOT 

tmux new -s plot

cd /home/ubuntu/chia-blockchain/
. ./activate

time chia plots create -k 32 -b 5120 -r 2 -u 128 -n 5 -t /tmpdisk -d /tmpdisk -f a4ab1f8213ebc06cbce49bf56b923467cf3263fdf587efff5ef0b71635f7c5b51d239046586354db24dfab188071d978 -p 96cbc06eb710bb3c43e8a64208dd49bce37cf440ca1c2bd6ee3c99124818c8ad0520d0b3f401151148a3a0e3c97f9f03

#exit session while plotting
Ctrl+b >>> d

#re-attach to session 
tmux attach -t plot

#kill the session 
tmux kill-session -t plot

########## save plots and cleanup 
/// TBD - need to first move to sub-directory, then move to main directory
aws s3 cp /tmpdisk --recursive --exclude "*" --include "*.plot" --exclude "*/*"  
#rm -rf /tmpdisk???? - can't remove all because it's too large, what's left???


### No need to spend money on the instnace if done plotting
sudo shutdown


