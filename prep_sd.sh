#!/bin/bash

if [ $(id -u) -ne 0 ]; then
	echo "Re-running script under sudo..."
	sudo "$0" "$@"
	exit
fi

sudo rm out/*.img

set -e
sudo ./build-kernel.sh friendlydesktop-arm64
sudo ./mk-sd-image.sh friendlydesktop-arm64

sudo dd status=progress if=`ls out/*.img` of=/dev/mmcblk0 bs=8192

sudo mount /dev/mmcblk0p1 /mnt
sudo cp ./rc.local /mnt/etc/
sudo umount /mnt
