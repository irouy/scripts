#!/bin/bash
#
# 2015-10-12 yourimatthys [at] gmail [dot] com

WORKVG="VGSYSTEM"
SOURCELV="LVHOME"
SNAPLV="LVHOME-SNAP1"
SNAPSIZE="5G"
MOUNTOPTS="-onouuid,ro"
REMOTEHOST="y_matthys@vmos01"
REMOTEDIR="/mnt/BACKUP/HOME/CORSICA01/"

# Make sure only root can run our script
	if [ "$(id -u)" != "0" ]; then
		echo "This script must be run as root" 1>&2
		exit 1
	fi

lvcreate -L $SNAPSIZE -s /dev/$WORKVG/$SOURCELV -n $SNAPLV
mkdir /mnt/$SNAPLV
mount $MOUNTOPTS /dev/$WORKVG/$SNAPLV /mnt/$SNAPLV

rsync -av --delete-after /mnt/$SNAPLV/ $REMOTEHOST:$REMOTEDIR/

umount /mnt/$SNAPLV
rmdir /mnt/$SNAPLV
lvremove -f /dev/$WORKVG/$SNAPLV
