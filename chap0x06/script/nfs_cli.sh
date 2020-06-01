# !/usr/bin/env bash

apt update



if [[ $? -ne 0 ]];then

   echo "apt update failed!"

   exit

fi



apt install nfs-common || echo "install nfs-common failed!"



#if [[ $? -gt 0 ]];

#then

#		echo "install nfs-common failed!"

#		exit

#fi



ser_ip="192.168.56.102"

cli_prw="/nfs/gen_rw"
ser_prw="/var/nfs/gen_rw"

cli_pr="/nfs/gen_r"
ser_pr="/var/nfs/gen_r"

cli_prw_nors="/nfs/no_rsquash"
ser_prw_nors="/home/no_rsquash"

cli_prw_rs="/nfs/rsquash"
ser_prw_rs="/home/rsquash"

mkdir -p "$cli_prw"
mkdir -p "$cli_pr"
mkdir -p "$cli_prw_nors"
mkdir -p "$cli_prw_rs"

mount "$ser_ip":"$ser_prw" "$cli_prw"
mount "$ser_ip":"$ser_pr" "$cli_pr"
mount "$ser_ip":"$ser_prw_nors" "$cli_prw_nors"
mount "$ser_ip":"$ser_prw_rs" "$cli_prw_rs"
