#!/bin/bash
CONFDIR="../config"

# Link dotfiles into home folder
printf "Soft-linking dotfiles in $PWD/$CONFDIR to $HOME" 

ln -s $PWD/$CONFDIR/.bashrc $HOME/.bashrc
ln -s $PWD/$CONFDIR/.alias $HOME/.alias && sh $HOME/.bashrc
ln -s $PWD/$CONFDIR/.screenrc $HOME/.screenrc
ln -s $PWD/$CONFDIR/.vimrc $HOME/.vimrc
ln -s $PWD/$CONFDIR/.guake.autostart $HOME/.guake.autostart && chmod +x $HOME/.guake.autostart

printf "\nInstall Conky for GNOME3, XFCE or none? [g/x/n]"
	read -n 1 CONKYDE
	if [ $CONKYDE == "g" ]; then
		printf "\nInstalling GNOME3 version"
		ln -s $PWD/$CONFDIR/.conkyrc_gnome3 $HOME/.conkyrc
		elif [ $CONKYDE == "x" ]; then
			printf "\nInstalling XFCE version"
			ln -s $PWD/$CONFDIR/.conkyrc_xfce3 $HOME/.conkyrc
		elif [ $CONKYDE == "n" ]; then
			printf "\nSkipping .conkyrc"
	else 
		printf "\nSkipping .conkyrc"
fi

# Setup CRON

if [ $(ls /tmp/miruoy.dotfiles.bootstrap.cronout) != 1 ]; then
	printf "cronfile exists"
	exit
	else
	printf "cronfile does exist"
	exit
	fi

#crontab -l > /tmp/bootstrap.cronout
printf "\nPlease input alerting email address [email@example.com]"
	read ALERTMAILADDR
	echo "\n mail addr for alerting == $ALERTMAILADDR"


exit