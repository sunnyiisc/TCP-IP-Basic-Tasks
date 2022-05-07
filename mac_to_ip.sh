#!/bin/bash
my_ip=$(ifconfig | grep broadcast | awk '{print $6}')					#Find my current ip broadcast address
my_ip=${my_ip%.255*}									#Discard the octet which has 255 in the ip address
nmap -sn $my_ip.0/24									#identify all the host ip connected to the subnet
echo Enter a mac address :								#User enters the mac address whose ip address need to be found
read mac_addr
ip_addr=$(arp -n | grep $mac_addr | awk '{print $1}')					#ip address is saved to the variable "ip_addr" from arp table
if [ -z "$ip_addr"]									#if the entered mac address doesnot matches with any in the arp table then it shows no device found
then
	echo No Device Found with MAC address of $mac_addr
else
	echo IP address corresponding to the MAC address of $mac_addr is $ip_addr	#if mac address matchen then it prints the corresponding value saved in the the variable "ip_addr"
fi
