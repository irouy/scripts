#!/bin/bash
#
# 2015-10-12 yourimatthys [at] gmail [dot] com

WORKVG="VGSYSTEM"
SOURCELV="LVHOME"
SNAPLV="LVHOME-SNAP1"
SNAPSIZE="5G"
MOUNTOPTS="-onouuid,ro" # << if FS == XFS
REMOTEHOST=""
REMOTEDIR=""

# Make sure only root can run our script
        if [ "$(id -u)" != "0" ]; then
                echo "This script must be run as root" 1>&2
                exit 1
        fi

# Check if SNAPLV exists
        if [[ $(lvs | grep $SNAPLV) ]]; then
                echo "$SNAPLV already exists! Aborting" 1>&2
                exit 1
        else
                lvcreate -L $SNAPSIZE -s /dev/$WORKVG/$SOURCELV -n $SNAPLV
        fi

# Make sure $DIRECTORY exists, if not then create directory!
        if [ -d /mnt/$SNAPLV ]
        then
                echo "Directory $SNAPLV exists."
        else
                mkdir /mnt/$SNAPLV
        fi


mount $MOUNTOPTS /dev/$WORKVG/$SNAPLV /mnt/$SNAPLV
rsync -av --delete-after /mnt/$SNAPLV/ $REMOTEHOST:$REMOTEDIR/

umount /mnt/$SNAPLV
rmdir /mnt/$SNAPLV
lvremove -f /dev/$WORKVG/$SNAPLV
