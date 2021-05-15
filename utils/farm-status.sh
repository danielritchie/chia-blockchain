#########################################
#			STATUS & DEBUG
#########################################

#TBD - auto update connections if low
#TBD - check log for time and errors 

ISACT=`chia -h`
if (( "$ISACT" == "128" ))
	echo "looks like chia isn't active... activating"
	~/chia-blockchain/activate
fi

AOK=true
MSG=""
chia show -s | grep "Full Node Synced"
	RC=$?
	if(( "$RC" != "0" )); then
		AOK=false
		MSG="${MSG}FAIL: Node Not Sync'd! \n    chia show -s\n"
	fi
chia farm summary | grep "Farming status: Farming"
	RC=$?
	if(( "$RC" != "0" )); then
		AOK=false
		MSG="${MSG}FAIL: Not Farming! \n    chia farm summary\n"
	fi
chia farm summary | grep "Plot count: 0" 
	RC=$?
	if(( "$RC" == "0" )); then
		AOK=false
		MSG="${MSG}FAIL: No Plots on Farm! \n    chia farm summary\n"
	fi
chia farm summary | grep "Plot count:"
	RC=$?
	if(( "$RC" != "0" )); then
		AOK=false
		MSG="${MSG}FAIL: Can't Count Farm Plots! \n    chia farm summary\n"
	fi
	#GOAL: greater than 0 (ideally based on / equal to # plots available:
	echo "Saved plots: `ls /lotsoplots/*.plot  | wc -l`"
chia wallet show | grep "Sync status: Synced"
	RC=$?
	if(( "$RC" != "0" )); then
		AOK=false
		MSG="${MSG}FAIL: Wallet Not Synd'd! \n    chia wallet show\n"
	fi
chia wallet show | grep "fingerprint: 3782091020"
	RC=$?
	if(( "$RC" != "0" )); then
		AOK=false
		MSG="${MSG}FAIL: Wrong Wallet Fingerprint! \n    chia wallet show\n"
	fi
PEER_NODE_COUNT=`chia show -c | grep FULL_NODE | wc -l`
	if(( $PEER_NODE_COUNT < 5 )); then
		AOK=false
		MSG="${MSG}FAIL: Not Enough Peers! \n    chia show -c\n"
	fi
PEER_INTRODUCER_COUNT=`chia show -c | grep INTRODUCER | wc -l`
	if(( $PEER_INTRODUCER_COUNT == 0 )); then
		AOK=false
		MSG="${MSG}FAIL: Not connected to any Introducers! \n    chia show -c\n"
	fi

if(( ! $AOK )); then
	echo ""
	echo "------- UH OH! -------"
	echo -e "$MSG"
fi




