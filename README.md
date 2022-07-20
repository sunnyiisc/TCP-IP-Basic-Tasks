# TCP-IP-Basic-Tasks

## 1.	Display network interface details using ifconfig and iproute2.
### Ans:
###	ifconfig:
	
ifconfig is a command line interface tool used to configure kernel-resident network interface.
It displays the status of the currently active interfaces.

The output of the command is given as follows:
***************************************************************************
```bash
enp3s0: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500
        ether 18:db:f2:07:9e:ce  txqueuelen 1000  (Ethernet)
        RX packets 5953  bytes 3896109 (3.8 MB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 4938  bytes 579054 (579.0 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 2360  bytes 237572 (237.5 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 2360  bytes 237572 (237.5 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

wlp2s0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.114.240.164  netmask 255.255.255.0  broadcast 10.114.240.255
        inet6 fe80::3566:f725:a4d2:747a  prefixlen 64  scopeid 0x20<link>
        ether 84:ef:18:16:bd:8b  txqueuelen 1000  (Ethernet)
        RX packets 13716  bytes 12708701 (12.7 MB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 7464  bytes 1196301 (1.1 MB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```
****************************************************************************

#### Explanation:
These are the 3 networks that are available in my laptop.
enp3s0 is the ethernet network, lo is the loopback network and wlp2s0 is the 
wireless network.


###	iproute2:
	
It is the collection of utilities for controlling, monitoring and
debugging various networking aspects in Linux. For example ip, ss, bridge,
rtacct, rtmon, tc, ctstat, lnstat, nstat, routef, routel, rtstat, tipc, arpd
and devlink. 
iproute2 has several command-line utilities that communicate with the linux 
kernel using "netlink" protocol.
These utilities can be used to monitor different networking aspects.


------------------------------------------------------------------------------

## 2.	A host in a wired network with net-id 10.114.x.x and 16bit subnet mask needs to communicate with a host in a wireless network with net-id 10.114.240.x and 24 bit subnet mask. Do you need any additional entry in the default routing table?
### Ans:
- 1st host (wired)    : net-id - 10.114.x.x and 16bit subnetmask 
					(i.e 255.255.0.0)
- 2nd host (wireless) : net-id - 10.114.240.x and 24bit subnetmask 
					(i.e 255.255.255.0)

For communication when the destination is ANDed with the subnet mask,
it must match with the net-id.

Hence, when we are in 1st host(10.114.0.0), the routing
table will consist of the subnet mask 255.255.0.0, which when ANDed with the
2nd host i.e 10.114.240.x, we get 10.114.0.0 matching the 1st host
net-id, which consist of the 2nd host net-id, hence successful communication.
	
When we are in 2nd host, the routing table will consist of the subnet
mask 255.255.255.0, which when ANDed with the 1st host i.e 10.114.x.x, we get
10.114.x.0 which dosent match any destination except 10.114.240.x.

Hence, for communication we need to add the entry with subnet mask 255.255.0.0
so that after ANDing get 1st host net-id, when we are in the 2nd host.

------------------------------------------------------------------------------

## 3. Write a bash script to find the IP address of a machine given its MAC address
### Ans:
The file "[mac_to_ip.sh](mac_to_ip.sh)" contains the bash code for finding ip address 
corresponding to the mac address given by the user.

-----------------------------------------------------------------------------

## 4.	(Use any tool) send a gratuitous ARP with a spoofed IP and MAC address to some destination address in your subnet.

### Ans:	
###	'arping' is a tool that pings a given host:

```bash
$arping -U -i enp3s0 <dst_addr> -S <spoof_ip_addr>
```

-U is used for Unsolicited ARP is used to update the neighbours’ ARP caches
-I sets the interface to the to the desired interface
-S sets the spoof source ip address to any desired spoof-ip
By this command we can set the spoof ip address corresponding to source mac address in the "dst_addr"'s arp table.
This sends the gratious arp reply to "dst_addr".

###	Note:
enable "ip_nonlocalbind" and "ip_forward" by the following commands:

```bash
$echo 1>/proc/sys/net/ipv4/ip_nonlocalbind
$echo 1>/proc/sys/net/ipv4/ip_forward
```

-----------------------------------------------------------------------------

## 5.	Send an IP packet with the predefined identification number (12345) and design a precise tcpdump rule to capture only that packet.

### Ans: 
###	Sending an IP packet with predefined identification number (12345):
"-N 12345" sends the ip packet with identification number 12345

```bash
$sudo hping3 -c 1 10.114.240.171 -N 12345
```

###	Receiving the ip packet with the predefined identification number:
Identification number is defined at the 4th byte if packet and of length 2 byte

```bash
$sudo tcpdump -i wlp2s0 'ip[4:2] == 12345'		
```

-----------------------------------------------------------------------------

## 6.	Send an IP packet with 10000 bytes payload to a chosen destination and design a precise tcpdump rule to capture all fragments of that particular IP packet.

### Ans:	
###	Sending an IP packet with data-size of 10000:
setting '-d' to 10000 to set the data-size and setting the id to 54321 to capture the packet by tcpdump	

```bash
$sudo hping3 -c 1 10.114.240.171 -N 54321 -d 10000
```

###	Receiving the ip packet with the predefined identification number:
Since, MTU of the wlan interface is 1500 hence the payload will be distributed among 
"10000/(1500-40)" i.e 7 fragments.
Identification number is defined at the 4th byte if packet and of length 2 byte which will remain same
for every fragment that will be created
hence, we can capture all the fragments by the identification number.

```bash
$sudo tcpdump -i wlp2s0 'ip[4:2] == 54321'		
```
