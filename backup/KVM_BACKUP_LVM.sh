#!/bin/bash

WORKVG="$1"
SOURCELV="$2"
SNAPLV="$2-SNAP1"
BACKUPDIR="$3"
MOUNTOPTS="$4" # << if FS == XFS -onouuid,ro
SNAPSIZE="$5"

display_usage() { 
        echo "You need to input WORKVG SOURCELV BACKUPDIR MOUNTOPTS SNAPSIZE" 
        echo "if FS == XFS then MOUNTOPTS should read -onouuid,ro"
        echo -e "\nUsage:\n$0 VG_HOSTNAME LV_LIBVIRT /var/backup/HOSTNAME/ -onouuid,ro 16G \n" 
        } 

# if less than two arguments supplied, display usage 
        if [  $# -le 1 ] 
        then 
                display_usage
                exit 1
        fi 
 
# check whether user had supplied -h or --help . If yes display usage 
        if [[ ( $# == "--help") ||  $# == "-h" ]] 
        then 
                display_usage
                exit 0
        fi 
 
# display usage if the script is not run as root user 
        if [[ $USER != "root" ]]; then 
                echo "This script must be run as root!" 
                exit 1
        fi

# Make sure only root can run our script
        if [ "$(id -u)" != "0" ]; then
                echo "This script must be run as root" 1>&2
                exit 1
        fi
                echo "====== Starting Backup ======"

# Check if SNAPLV exists
        if [[ $(/sbin/lvs | grep -q $SNAPLV) ]]; then
                echo "====== Backup failed: $SNAPLV already exists! Aborting ======"
                exit 1
        else
                /sbin/lvcreate -L $SNAPSIZE -s /dev/$WORKVG/$SOURCELV -n $SNAPLV
        fi

# Make sure $DIRECTORY exists, if not then create directory!
        if [ -d /mnt/$SNAPLV ]
        then
                echo "Directory $SNAPLV exists."
        else
                /usr/bin/mkdir /mnt/$SNAPLV
        fi

# check whether mount point is in use
        if (mount -l | grep -q $SNAPLV)
        then
                echo "[X] Error: Mount point already in use"
                echo "Removing $SNAPLV"
                        /sbin/lvremove -f /dev/$WORKVG/$SNAPVL
                echo "====== Backup failed: Error: Mount point already in use !!!PLEASE CLEAN UP MANUALLY!!! ======"
                exit 1
        fi

# Mount SNAPVOL
        if (/usr/bin/mount --read-only $MOUNTOPTS /dev/$WORKVG/$SNAPLV /mnt/$SNAPLV)
        then
                echo "Mounted /dev/$WORKVG/$SNAPLV on /mnt/$SNAPLV"
        else
                rmdir /mnt/$SNAPLV
                /sbin/lvremove -f /dev/$WORKVG/$SNAPLV
                echo "====== Backup failed: [X] Error: Could not mount /dev/$WORKVG/$SNAPLV to /mnt/$SNAPLV ======"
                exit 1
        fi

# Do the Backup
                echo "Backing up Disk Images $WORKVG/$SNAPLV/* to $BACKUPDIR"
                        /usr/bin/ionice -c 3 /usr/bin/lzop --force /mnt/$SNAPLV/*  --path=$BACKUPDIR
                        /usr/bin/ionice -c 3 /usr/bin/lzop --force /mnt/$SNAPLV/brick01/*  --path=$BACKUPDIR
                echo "Dumping config files from /etc/libvirt/qemu"
                        /bin/cp -a /etc/libvirt/qemu/*.xml $BACKUPDIR
# CLeaning up                
                echo "Cleaning up"
                                        /usr/bin/umount /mnt/$SNAPLV
                                        /usr/bin/rmdir /mnt/$SNAPLV
                                        /sbin/lvremove -f /dev/$WORKVG/$SNAPLV
                echo "Backup of $WORKVG/$SNAPLV to $BACKUPDIR finished succesfully!"
                echo "====== Backup finished ======"
exit
