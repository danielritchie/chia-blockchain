######################################################
### FARMER SETUP
######################################################

#//// Instance Notes
#t3a.medium, probably 
#	fast farmer (for initial sync): t3.2xlarge
#IAM Role
#Security Group 
#gp3 (st1 TBD, may be OK after fast farmer)



#/// TBD
#sudo apt  install awscli -y
#chia config??
#(.chia dir / chia's user home would be nice)



#startup.sh 
#	########### S3FS INSTALL 
#	sudo apt-get update -y
#	sudo apt-get install s3fs -y
#	echo *************:***** > passfile
#	sudo mv passfile /etc/passwd-s3fs
#	chmod 640 /etc/passwd-s3fs
#	sudo mkdir /lotsoplots
#	sudo chmod 777 /lotsoplots
#	cd /
#	s3fs lotsoplots /lotsoplots


############# CHIA 
#cd /home/ubuntu/chia-blockchain/
#. ./activate
#chia configure -upnp f 
#chia start farmer
#echo "FINEE"



# USER SETUP
#chmod 777 start.sh
#./start.sh
cd ~/chia-blockchain/
git pull
. ./activate
chia start farmer



# latch for startup
starting=true
while [ "$starting" = true ]
do
	chia show -c | grep "Connection error."
	RC=$?
	if (( "$RC" == "0" )); then
		sleep 60
		echo "Waiting for service to start..."
	else
		starting=false
		echo "chia ready!"
	fi
done

# try setting up some initial connectoins
~/chia-blockchain/utils/fertilize-peers.sh

# make sure things look OK
~/chia-blockchain/utils/farm-status.sh

echo "graph: ~/chiaharvestgraph/chiaharvestgraph ~/.chia/mainnet/log"
echo "FINEE! Startup complete."




#chia configure --set-node-introducer introducer-va.chia.net:8444


#backup daily?