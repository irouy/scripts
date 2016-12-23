#!/bin/bash
CONFDIR="../config"

# Link dotfiles into home folder
printf "Soft-linking dotfiles in $PWD/$CONFDIR to $HOME" 

ln -s $PWD/$CONFDIR/.bashrc $HOME/.bashrc && printf "\nLinked .bashrc"
ln -s $PWD/$CONFDIR/.alias $HOME/.alias && sh $HOME/.bashrc && printf "\nLinked .alias and Sourced $HOME/.bashrc"
ln -s $PWD/$CONFDIR/.screenrc $HOME/.screenrc && printf "\nLinked .screenrc"
ln -s $PWD/$CONFDIR/.vimrc $HOME/.vimrc && printf "\nLinked .vimrc"
ln -s $PWD/$CONFDIR/.guake.autostart $HOME/.guake.autostart && chmod +x $HOME/.guake.autostart && printf "\n:Linked .guake.autostart"

printf "\nInstall Conky for GNOME3, XFCE or none? [g/x/n]"
	read -n 1 CONKYDE
	if [ $CONKYDE == "g" ]; then
		printf "\nInstalling GNOME3 version"
		ln -s $PWD/$CONFDIR/.conkyrc_gnome3 $HOME/.conkyrc
		elif [ $CONKYDE == "x" ]; then
			printf "\nInstalling XFCE version"
			ln -s $PWD/$CONFDIR/.conkyrc_xfce3 $HOME/.conkyrc
	else 
		printf "\nSkipping .conkyrc"
fi

printf "\nDotfiles succesfully deployed into $HOME"
printf "\nHave a lot of fun!\n"


exit