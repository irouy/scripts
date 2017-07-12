#!/bin/bash
CONFDIR="../dotfiles"

#Check if we are in the right directory.
if [ -e $PWD/dotfiles_bootstrap.sh ]
	then printf "\nValidated directory, continuing routine."; 
	else printf "\nYou must run this script from its directory!"
		printf "\nAborting!\n"
		exit
fi

printf "\nClean existing dotfiles in $HOME? [y/N]"
	read -n 1 CONTINUE
		if [ $CONTINUE == "y" ]; then
    printf "\n"
    rm $HOME/.bashrc
    rm $HOME/.alias
    rm $HOME/.screenrc
    rm $HOME/.vimrc
    rm $HOME/.guake.autostart
    rm $HOME/.conkyrc
    rm $HOME/.config/autostart/conky.desktop
fi

# Link dotfiles into home folder
printf "Soft-linking dotfiles in $PWD/$CONFDIR to $HOME\n" 

ln -s $PWD/../config/ssh_config $HOME/.ssh/config && "n\Linked ssh_config"
ln -s $PWD/$CONFDIR/.bashrc $HOME/.bashrc && printf "\nLinked .bashrc"
ln -s $PWD/$CONFDIR/.alias $HOME/.alias && sh $HOME/.bashrc && printf "\nLinked .alias and Sourced $HOME/.bashrc"
ln -s $PWD/$CONFDIR/.screenrc $HOME/.screenrc && printf "\nLinked .screenrc"
ln -s $PWD/$CONFDIR/.vimrc $HOME/.vimrc && printf "\nLinked .vimrc"
ln -s $PWD/$CONFDIR/.guake.autostart $HOME/.guake.autostart && chmod +x $HOME/.guake.autostart && printf "\n:Linked .guake.autostart"
mkdir $HOME/.config/autostart/ 
ln -s $PWD/../config/conky.desktop $HOME/.config/autostart/ && printf "\nLinked conky for autostart"
ln -s /usr/share/applications/guake.desktop $HOME/.config/autostart/ && printf "\nLinked guake for autostart"
ln -s $PWD/$CONFDIR/.conkyrc_gnome3 $HOME/.conkyrc && printf "\nInstalling Conky GNOME3 version"

cd $HOME
sh $HOME/.bashrc && printf "\Sourced $HOME/.bashrc"

printf "\nDotfiles succesfully deployed into $HOME"
printf "\nHave a lot of fun!\n"

exit
