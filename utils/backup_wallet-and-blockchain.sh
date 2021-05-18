#!/bin/bash

#WALLET_AND_BLOCKCHAIN

BLOCK_SYNC_STATUS=`chia show -s | grep -q "Current Blockchain Status: Full Node Synced" ; echo $?`
if [[ "$BLOCK_SYNC_STATUS" != "0" ]]; then
	echo "OH NO!  Can only backup if block sync'd"
	exit 1
fi

BLOCK_TOP=`chia show -s | grep "Height" | grep -v '|' | awk '{print $NF}'`

BLOCK_DIR="/home/ubuntu/.chia/mainnet/db"
BLOCK_FILE="blockchain_v1_mainnet.sqlite"
TMP_BLOCK_FILE="${BLOCK_DIR}/${BLOCK_FILE}_${BLOCK_TOP}"

cp "${BLOCK_DIR}/${BLOCK_FILE}" "${TMP_BLOCK_FILE}"
aws s3 mv "${TMP_BLOCK_FILE}" "s3://lotsoplots/"

WALLET_SYNC_STATUS=`chia wallet show | grep -q "Sync status: Synced" ; echo $?`
if [[ "$WALLET_SYNC_STATUS" != "0" ]]; then
	echo "OH NO!  Can only backup if wallet sync'd"
	exit 1
fi

WALLET_DIR="/home/ubuntu/.chia/mainnet/wallet/db"
WALLET_FILE="blockchain_wallet_v1_mainnet_3782091020.sqlite"
TMP_WALLET_FILE="${WALLET_DIR}/${WALLET_FILE}_${BLOCK_TOP}"

cp "${WALLET_DIR}/${WALLET_FILE}" "${TMP_WALLET_FILE}"
aws s3 mv "${TMP_WALLET_FILE}" "s3://lotsoplots/"






