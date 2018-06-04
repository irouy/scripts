#!/bin/bash
TMPFILE="/tmp/bootstrap_$USER.cronout"

#Check if we are in the right directory.
if [ -e $PWD/crontab_bootstrap.sh ]; then 
                printf "\nValidated directory, continuing routine."; 
        else 
                printf "\nYou must run this script from its directory!"
                printf "\nAborting!\n"
        exit
fi

        read -e -p "Please input alerting Mail: " -i "email@example.com" ALERTMAILADDR
        read -e -p "Please input Backup Destination: " -i "/var/backup" BACKDIR

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

if [ ! -f /root/bin/vm-backup.sh ]; then
        cp ../backup/vm-backup.sh /root/bin/vm-backup.sh && chmod +x /root/bin/vm-backup.sh
                printf "\nCopied vm-backup.sh to /root/bin\n"
        else
                printf "\nvm-backup.sh already exists in /root/bin\n"
        fi
  
# Setup CRON

crontab -l > $TMPFILE
    printf "\nLoaded current crontab into $TMPFILE\n"

crontab -r
    printf "\nRemoving current crontab\n"

cat $TMPFILE
    printf "\nOriginal Crontab\n"

        echo "#DOTFILES.SH $(date)" >> $TMPFILE
        echo "#=================" >> $TMPFILE
        echo "# set VARIABLES  #" >> $TMPFILE
        echo "#=================" >> $TMPFILE
        echo "PATH=/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin" >> $TMPFILE
        echo "MAILTO="$ALERTMAILADDR"" >> $TMPFILE
        echo "#=================" >> $TMPFILE
        echo "# Examples        #" >> $TMPFILE
        echo "#=================" >> $TMPFILE
        echo "# .---------------- minute (0 - 59)" >> $TMPFILE
        echo "# |  .------------- hour (0 - 23)" >> $TMPFILE
        echo "# |  |  .---------- day of month (1 - 31)" >> $TMPFILE
        echo "# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ..." >> $TMPFILE
        echo "# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7)  OR sun,mon,tue,wed,thu,fri,sat" >> $TMPFILE
        echo "# |  |  |  |  |" >> $TMPFILE
        echo "# *  *  *  *  *  command to be executed" >> $TMPFILE
        echo "# *  *  *  *  *  command --arg1 --arg2 file1 file2 2>&1" >> $TMPFILE
        echo "#=================" >> $TMPFILE
        echo "# HW Checks       #" >> $TMPFILE
        echo "#=================" >> $TMPFILE
        echo "0 * * * * $PWD/diskcheck.sh $ALERTMAILADDR >/dev/null 2>&1" >> $TMPFILE && chmod +x $PWD/diskcheck.sh
        echo "0 * * * * $PWD/loadmon.sh $ALERTMAILADDR >/dev/null 2>&1" >> $TMPFILE && chmod +x $PWD/loadmon.sh
        echo "#=================" >> $TMPFILE
        echo "# Config Backup   #" >> $TMPFILE
        echo "#=================" >> $TMPFILE
        echo "0 0 * * * /bin/tar cvzpf $BACKDIR/$HOSTNAME-config-\$(date +\%A).tar.gz /etc /var/spool /root" >> $TMPFILE
        echo "#=================" >> $TMPFILE
        echo "# VM-Backups      #" >> $TMPFILE
        echo "#=================" >> $TMPFILE
        echo "#30 0 * * * /root/bin/vm-backup.sh $BACKDIR DAVO-BOOSTER 2" >> $TMPFILE

crontab $TMPFILE
        printf "\nInstalled new Crontab\n" && crontab -l
rm $TMPFILE
        printf "\nCleaned $TMPFILE\n" 

exit
