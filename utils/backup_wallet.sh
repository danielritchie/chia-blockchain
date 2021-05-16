#!/bin/bash

appendage=$1

if (( $appendage == "" )); then
    echo "Must specify the suffix to uniquely identify the file"
	return 1
fi

#copy the wallet so we don't interrupt anything
cp blockchain_wallet_v1_mainnet_3782091020.sqlite blockchain_wallet_v1_mainnet_3782091020.sqlite_260k
aws s3 mv blockchain_wallet_v1_mainnet_3782091020.sqlite_287k s3://lotsoplots


