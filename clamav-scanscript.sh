#!/bin/sh

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
 
SCANDIRS="/home /etc /opt /usr/local"
SCANLOG="/var/log/clamav-scanscript.log"

# Update Signatures
freshclam

# emtpy the old scanlog and do a virus scan
mv $SCANLOG $SCANLOG.old
touch $SCANLOG
clamdscan $SCANDIRS --fdpass --log=$SCANLOG --infected --multiscan
 
### Send the email
if grep -rl 'Infected files: 0' $SCANLOG
then echo "No virus found"
else cat $SCANLOG | mail -s "Virus Found!" root
fi