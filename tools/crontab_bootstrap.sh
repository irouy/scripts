#!/bin/bash
TMPFILE="/tmp/bootstrap_$USER.cronout"

#Check if we are in the right directory.
if [ -e $PWD/crontab_bootstrap.sh ]; then printf "\nValidated directory, continuing routine."; 
	else printf "\nYou must run this script from its directory!"
		printf "\nAborting!\n"
		exit
fi

printf "\nPlease input alerting email address [email@example.com]\n" && read ALERTMAILADDR
	ls -lah /var && printf "\nPlease input Backup Path [/var/backup]\n" && read BACKDIR
	printf "\nEmail address for alerting == $ALERTMAILADDR"
	printf "\nPath that will be used for storing backup files == $BACKDIR"
	printf "\nIs this correct? [y/N]\n"
		read -n 1 CONTINUE
			if [ $CONTINUE == "y" ]; then
			printf "Email and backup path validated, continuing routine."
			else
		printf "\nAborting!\n"
		exit
		fi  
	
# Setup CRON
crontab -l > $TMPFILE && printf "\nLoaded current crontab into $TMPFILE\n" && printf "\nOriginal Crontab\n" && cat $TMPFILE 
	echo "#DOTFILES.SH $(date)" >> $TMPFILE
	echo "0 * * * * $PWD/diskcheck.sh $ALERTMAILADDR >/dev/null 2>&1" >> $TMPFILE && chmod +x $PWD/diskcheck.sh
	echo "0 * * * * $PWD/loadmon.sh $ALERTMAILADDR >/dev/null 2>&1" >> $TMPFILE && chmod +x $PWD/loadmon.sh
	echo "10 0 * * * /bin/tar cvpf $BACKDIR/$HOSTNAME-$USER-daily.tar $HOME | mail -s '$HOSTNAME Daily $USER $HOME TAR' $ALERTMAILADDR" >> $TMPFILE
	echo "20 0 * * * /usr/bin/crontab -l > $BACKDIR/$HOSTNAME-crontab-$USER-daily.crontab | mail -s '$HOSTNAME Backup crontab $USER daily' $ALERTMAILADDR" >> $TMPFILE
	echo "30 0 * * * /bin/tar cvpf $BACKDIR/$HOSTNAME-etc-daily.tar /etc |mail -s '$HOSTNAME Backup etc' $ALERTMAILADDR" >> $TMPFILE

printf "\nInstall KVM_BACKUP_LVM scripts? [y/N]"
	read -n 1 CONTINUE
		if [ $CONTINUE == "y" ]; then
			       	
			       	if [[ $USER != "root" ]]; then 
                printf "\nThis script must be run as root!\n" 
                exit 1
        				fi
        		
        		vgs && printf "\nPlease input Volume Group Name\n" && read VOLGRP
				lvs && printf "\nPlease input Logical Volume Name\n" && read LVOLUME
				blkid && printf "\nPlease input additional options for mounting Snapshot [-onouuid,ro]\n" && read MOUNTOPTS
				printf "\nPlease input Snapshot size [16G]\n" && read SNAPSIZE
			
			printf "\n Will process $VOLGRP/$LVOLUME to $BACKDIR with Snapsize of $SNAPSIZE and mount options $MOUNTOPTS"
			printf "\nIs this correct? [y/N]\n"
				read -n 1 CONTINUE
						if [ $CONTINUE == "y" ]; then
							echo "15 2 * * * $PWD/../backup/KVM_BACKUP_LVM.sh $VOLGRP $LVOLUME $BACKDIR $MOUNTOPTS $SNAPSIZE |mail -s '$HOSTNAME Backup $VOLGRP/$LVOLUME to $BACKDIR' $ALERTMAILADDR " >> $TMPFILE
						fi
		else
		printf "\nSkipping KVM_BACKUP_LVM scripts."
		fi

crontab $TMPFILE && printf "\nInstalled new Crontab\n" && crontab -l
exit
