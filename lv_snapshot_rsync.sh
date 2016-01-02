#!/bin/sh +x

WORKVG="VG_VMS01_SYS"
SOURCELV="LV_ROOT"
SNAPLV="LVROOT-SNAP1"
SNAPSIZE="10G"
MOUNTOPTS="" # << if FS == XFS -onouuid,ro
REMOTEHOST="NAS"
REMOTEDIR="BACKUP_VMS01/rootfs"
LOGFILE="/var/log/$WORKVG-$SOURCELV-backup.log"

# Make sure only root can run our script
        if [ "$(id -u)" != "0" ]; then
                echo "This script must be run as root" 1>&2
                exit 1
        fi

# write first parameter $1 to logfile
function write_to_log 
{
  # get current date and time
  bkp_date=$(date +%Y-%m-%d@%H:%M:%S)
  echo -e "$bkp_date : $1" >> $LOGFILE
}

# Append log entry
write_to_log "====== Starting Backup ======"

# Check if SNAPLV exists
        if [[ $(lvs | grep $SNAPLV) ]]; then
                echo "$SNAPLV already exists! Aborting" 1>&2
                exit 1
        else
                /sbin/lvcreate -L $SNAPSIZE -s /dev/$WORKVG/$SOURCELV -n $SNAPLV >> $LOGFILE
        fi

# Make sure $DIRECTORY exists, if not then create directory!
        if [ -d /mnt/$SNAPLV ]
        then
                echo "Directory $SNAPLV exists." >> $LOGFILE
        else
                /usr/bin/mkdir /mnt/$SNAPLV
        fi

# check whether mount point is in use
	if [ ! -z "$(mount -l | grep $SNAPLV)" ]; then 
  		write_to_log "[X] Error: Mount point already in use"
  		write_to_log "====== Backup failed ======"
  		exit 1
	fi

# Mount SNAPVOL
/usr/bin/mount --verbose --read-only $MOUNTOPTS /dev/$WORKVG/$SNAPLV /mnt/$SNAPLV >> $LOGFILE 
	if [ $? -ne 0 ]; then
		rmdir /mnt/$SNAPLV
		/sbin/lvremove -f /dev/$WORKVG/$SNAPLV >> $LOGFILE
  		write_to_log "[X] Error: Could not mount /dev/$WORKVG/$SNAPLV to /mnt/$SNAPLV"
  		write_to_log "====== Backup failed ======"
  		exit 1
	fi
write_to_log "Starting rsync of $WORKVG/$SNAPVOL to $REMOTEHOST::$REMOTEDIR"
/usr/bin/rsync --archive --delete-before /mnt/$SNAPLV/ $REMOTEHOST::$REMOTEDIR 
write_to_log "Unmounting /mnt/$SNAPLV"
/usr/bin/umount /mnt/$SNAPLV
write_to_log "Removing temp dir /mnt/$SNAPLV"
/usr/bin/rmdir /mnt/$SNAPLV
/sbin/lvremove -f /dev/$WORKVG/$SNAPLV >> $LOGFILE
write_to_log "Backup of $WORKVG/$SNAPLV to $REMOTEHOST::$REMOTEDIR finished succesfully"
  		write_to_log "====== Backup finished ======"
