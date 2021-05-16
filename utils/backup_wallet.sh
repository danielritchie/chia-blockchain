#!/bin/bash

appendage=$1

if (( $appendage == "" )); then
    echo "Must specify the suffix to uniquely identify the file"
	return 1
fi

#copy the wallet so we don't interrupt anything
cp ~/.chia/mainnet/wallet/blockchain_wallet_v1_mainnet_3782091020.sqlite ~/.chia/mainnet/wallet/blockchain_wallet_v1_mainnet_3782091020.sqlite_$appendage

#backup to s3
aws s3 mv ~/.chia/mainnet/wallet/blockchain_wallet_v1_mainnet_3782091020.sqlite_$appendage s3://lotsoplots


