#!/bin/bash
CONFDIR="../dotfiles"

#Check if we are in the right directory.
if [ -e $PWD/dotfiles_bootstrap.sh ]; then printf "\nValidated directory, continuing routine."; 
	else printf "\nYou must run this script from its directory!"
		printf "\nAborting!\n"
		exit
fi

printf "\nClean existing dotfiles in $HOME? [y/N]"
	read -n 1 CONTINUE
		if [ $CONTINUE == "y" ]; then
    printf "\n"
    rm -i $HOME/.bashrc
    rm -i $HOME/.alias
    rm -i $HOME/.screenrc
    rm -i $HOME/.vimrc
    rm -i $HOME/.guake.autostart
    rm -i $HOME/.conkyrc
    rm -i $HOME/.config/autostart/conky.desktop
fi

# Link dotfiles into home folder
printf "Soft-linking dotfiles in $PWD/$CONFDIR to $HOME\n" 

ln -s $PWD/$CONFDIR/.bashrc $HOME/.bashrc && printf "\nLinked .bashrc"
ln -s $PWD/$CONFDIR/.alias $HOME/.alias && sh $HOME/.bashrc && printf "\nLinked .alias and Sourced $HOME/.bashrc"
ln -s $PWD/$CONFDIR/.screenrc $HOME/.screenrc && printf "\nLinked .screenrc"
ln -s $PWD/$CONFDIR/.vimrc $HOME/.vimrc && printf "\nLinked .vimrc"
ln -s $PWD/$CONFDIR/.guake.autostart $HOME/.guake.autostart && chmod +x $HOME/.guake.autostart && printf "\n:Linked .guake.autostart"
mkdir $HOME/.config/autostart/ 
ln -s $PWD/../config/conky.desktop $HOME/.config/autostart/ && printf "\nLinked conky for autostart"
ln -s /usr/share/applications/guake.desktop $HOME/.config/autostart/ && printf "\nLinked guake for autostart"

printf "\nInstall Conky for GNOME3, XFCE or none? [g/x/N]"
	read -n 1 CONKYDE
	if [ $CONKYDE == "g" ]; then
		printf "\nInstalling GNOME3 version"
		ln -s $PWD/$CONFDIR/.conkyrc_gnome3 $HOME/.conkyrc
	elif [ $CONKYDE == "x" ]; then
		printf "\nInstalling XFCE version"
		ln -s $PWD/$CONFDIR/.conkyrc_xfce $HOME/.conkyrc
	else 
		printf "\nSkipping .conkyrc"
	fi

printf "\nDotfiles succesfully deployed into $HOME"
printf "\nHave a lot of fun!\n"


exit
