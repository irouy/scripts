#!/bin/bash
#
# 2015-10-12 miruoy
# Now using rsyncd for proper remote paths

WORKVG="VG_VMS01_DATA"
SOURCELV="LV_LIBVIRT"
SNAPLV="LV_LIBVIRT-SNAP1"
SNAPSIZE="10G"
MOUNTOPTS="-onouuid,ro" # << if FS == XFS -onouuid,ro
REMOTEHOST="NAS"
REMOTEDIR="BACKUP_VMS01/libvirt"

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
rsync -av --delete-after /mnt/$SNAPLV/ $REMOTEHOST::$REMOTEDIR
umount /mnt/$SNAPLV
rmdir /mnt/$SNAPLV
lvremove -f /dev/$WORKVG/$SNAPLV
