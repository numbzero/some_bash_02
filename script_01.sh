#!/bin/bash

if [ "$#" -ne "2" ]; then
	echo "Usage: $0 ip_addr netmask"
	echo -e "\t ip_addr  - x.x.x.x (0 <= x <= 255)"
	echo -e "\t netmask  - y.y.y.y (0 <= n <= 255)" 
	exit 1
fi

IP_ADDR="$1"
NETMASK="$2"

check_format ()
{
	ADDR="$1"
	TYPE="$2"
	if [[ $ADDR =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
		ADDR_SPLIT=(`echo $ADDR | tr "." " "`)
		for i in "${ADDR_SPLIT[@]}"; do
			if ! [[ "$i" -ge "0"  && "$i" -le "255" ]]; then
				echo "[!] $ADDR - bad $TYPE"
				exit 1
			fi
		done
		echo "[+] $ADDR - $TYPE ok"
	else
		echo "[!] $ADDR - invalid format."
		exit 1
	fi
}

echo "___Checking arguments ..."
check_format $IP_ADDR "ip address"
check_format $NETMASK "netmask"
echo "_______________________________"

IP_ADDR_SPLIT=(`echo "$IP_ADDR" | tr "." " "`)
NETMASK_SPLIT=(`echo "$NETMASK" | tr "." " "`)

IP_RANGE=()
for (( i = 0; i < 4; i++)); do
	net_addr=$[${IP_ADDR_SPLIT[$i]} & ${NETMASK_SPLIT[$i]}]
	IP_RANGE[$i]="seq  $[$net_addr] $[$net_addr + 255 - ${NETMASK_SPLIT[$i]}]"
done

trap "exit 1" SIGINT SIGTERM
count="0"
for a in `${IP_RANGE[0]}`; do
	for b in `${IP_RANGE[1]}`; do
		for c in `${IP_RANGE[2]}`; do
			for d in `${IP_RANGE[3]}`; do
				ping -c 1 -w 1 "$a.$b.$c.$d" > /dev/null
				if [ "$?" -eq "0" ]; then
					echo "$a.$b.$c.$d - up"
					((count++))
				fi
			done
		done
	done
done

if [ $count -eq "0" ]; then
	echo "The network connection seems to be down."
fi
