#!/bin/bash

if [ "$#" -ne "1" ]; then
	echo "Usage: $0 domain_name"
	exit 1
fi

DOMAIN=$1

host "$DOMAIN" > /dev/null
if [ "$?" -eq "1" ]; then
	echo "[-] Invalid domain name. Retry."
	exit 1
fi

for PREFIX in `cat name.txt`; do
	host "$PREFIX.$DOMAIN" > /dev/null
	if [ "$?" -eq "0" ]; then
		echo "$PREFIX.$DOMAIN"
	fi
done
