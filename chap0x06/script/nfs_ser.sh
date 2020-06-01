# !/usr/bin/env bash

apt update

if [[ $? -ne 0 ]];then
   echo "apt update failed!"
   exit
fi

apt-get install -y nfs-kernel-server || echo "Installation NFS server side failed" 

ser_pr="/var/nfs/gen_r"
ser_prw="/var/nfs/gen_rw"

ser_no_rsquash="/home/no_rsquash"
ser_rsquash="/home/rsquash"

mkdir -p "$ser_pr"
chown nobody:nogroup "$ser_pr"

mkdir -p "$ser_prw"
chown nobody:nogroup "$ser_prw"

mkdir -p "$ser_no_rsquash"
mkdir -p "$ser_rsquash"

client_ip="192.168.56.101"
cl_prw_op="rw,sync,no_subtree_check"
cl_pr_op="ro,sync,no_subtree_check"
cl_prw_nors="rw,sync,no_subtree_check,no_root_squash"
cl_prw_rs="rw,sync,no_subtree_check"
conf="/etc/exports"

grep -q "$ser_pr" "$conf" && sed -i -e "#${ser_pr}#s#^[#]##g;#${ser_pr}#s#\ .*#${client_ip}($cl_pr_op)" "$conf" || echo "${ser_pr} ${client_ip}($cl_pr_op)" >> "$conf"

grep -q "$ser_prw" "$conf" && sed -i -e "#${ser_prw}#s#^[#]##g;#${ser_prw}#s#\ .*#${client_ip}($cl_prw_op)" "$conf" || echo "${ser_prw} ${client_ip}($cl_prw_op)" >> "$conf"

grep -q "$ser_no_rsquash" "$conf" && sed -i -e "#${ser_no_rsquash}#s#^[#]##g;#${ser_no_rsquash}#s#\ .*#${client_ip}  ($cl_prw_nors)" "$conf" || echo "${ser_no_rsquash} ${client_ip}($cl_prw_nors)" >> "$conf"

grep -q "$ser_rsquash" "$conf" && sed -i -e "#${ser_rsquash}#s#^[#]##g;#${ser_rsquash}#s#\ .*#${client_ip}  ($cl_prw_rs)" "$conf" || echo "${ser_rsquash} ${client_ip}($cl_prw_rs)" >> "$conf"

systemctl restart nfs-kernel-server
