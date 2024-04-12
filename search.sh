#!/bin/bash
if [ -z "$1" ]
then
	exit 1
fi
apt search "$1" | grep -i "$1" | less
