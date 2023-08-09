#!/bin/bash

# clean the inventory file
echo "" > inventory

# Extract values from JSON output
bastion_ip=$(terraform output -json | jq -r '.bastion_ip.value')
private_ip=$(terraform output -json | jq -r '.private_ip.value')

# update bastion
bastion="bastion_host ansible_host={bastion_ip} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/ansible"
bastion=$(echo "$bastion" | sed "s/{bastion_ip}/$bastion_ip/g")

# update private
private="private_host ansible_host={private_ip} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/ansible ansible_ssh_common_args='-o ProxyJump=ubuntu@{bastion_ip}'"
private=$(echo "$private" | sed "s/{bastion_ip}/$bastion_ip/g")
private=$(echo "$private" | sed "s/{private_ip}/$private_ip/g")

# write to inventory
echo "[bastion]" >> inventory
echo $bastion >> inventory

echo "[private]" >> inventory
echo $private >> inventory


# update vpn_client
vpn_client_ip=$(terraform output -json | jq -r '.vpn_client_ip.value')
vpn_client="vpn_client ansible_host={vpn_client_ip} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/ansible"
vpn_client=$(echo "$vpn_client" | sed "s/{vpn_client_ip}/$vpn_client_ip/g")

echo "[client]" >> inventory
echo $vpn_client >> inventory

