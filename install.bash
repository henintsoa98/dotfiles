################################################################################
# CHECK ROOT ###################################################################
################################################################################
if [[ $UID -eq 0 ]]
then
	echo "don't run as root"
	exit
fi

################################################################################
# GET SUDO PRIVILEGE ###########################################################
################################################################################
sudo echo -e "\033[1;31m# HELLO, SETUP BEGIN #\033[0m"; sleep 2

################################################################################
# COPY MY CUSTOM BINARY ########################################################
################################################################################
if [[ "$1" == "setup" || "$1" == "update" ]]
then
	echo -e "\033[1;31m# COPY CUSTOM BINARY #\033[0m"; sleep 2
	sudo su -c "cp bin/* /usr/local/bin/"
	sudo su -c "chmod +x /usr/local/bin/*"
fi

################################################################################
# CHECK ARGUMENT ###############################################################
################################################################################
if [[ "$1" == "setup" || "$1" == "update" || "$1" == "container" ]]
then
	echo -e "\033[1;31m# CHECKING IF EVERYTHING IS COOL #\033[0m"; sleep 2
else
	echo "usage : $0 setup|update|container"
	exit
fi

################################################################################
# INSTALL PACKAGE ##############################################################
################################################################################
if [[ "$1" == "setup" ]]
then
	echo -e "\033[1;31m# INSTALL PACKAGE #\033[0m"
	echo -e "\033[1;31m# INSTALL MINIMAL ENV #\033[0m"; sleep 2
	sudo su -c "apt install alsa-utils command-not-found curl git network-manager openssh-server openssh-client sshfs sudo vim zsh"
	echo -e "\033[1;31m# INSTALL DEV ENV (build-essential or clang) #\033[0m"; sleep 2
	echo -e "\033[1;33mInstall build-essential? (yn)\033[0m"
	read CHOICE
	if [[ "$CHOICE" == "y" ]]
	then
		sudo su -c "apt install build-essential"
	fi
	echo -e "\033[1;33mInstall clang? (yn)\033[0m"
	read CHOICE
	if [[ "$CHOICE" == "y" ]]
	then
		sudo su -c "apt install clang"
	fi
	echo -e "\033[1;31m# INSTALL GUI #\033[0m"; sleep 2
	echo -e "\033[1;33mInstall i3? (yn)\033[0m"
	read CHOICE
	if [[ "$CHOICE" == "y" ]]
	then
		sudo su -c "apt install bc feh i3 picom polybar rxvt-unicode xorg xserver-xorg-video-intel"
	fi
	echo -e "\033[1;31m# INSTALL FILE MANAGER #\033[0m"; sleep 2
	echo -e "\033[1;33mInstall pcmanfm? (yn)\033[0m"
	read CHOICE
	if [[ "$CHOICE" == "y" ]]
	then
		sudo su -c "apt install pcmanfm"
		echo -e "\033[1;33mInstall lxappearance? (yn)\033[0m"
		read CHOICE
		if [[ "$CHOICE" == "y" ]]
		then
			sudo su -c "apt install lxappearance"
		fi
	fi
	echo -e "\033[1;31m# INSTALL BROWSER #\033[0m"; sleep 2
	echo -e "\033[1;33mInstall firefox? (yn)\033[0m"
	read CHOICE
	if [[ "$CHOICE" == "y" ]]
	then
		sudo su -c "apt install firefox-esr"
	fi
	echo -e "\033[1;31m# INSTALL MEDIA PLAYER #\033[0m"; sleep 2
	echo -e "\033[1;33mInstall vlc? (yn)\033[0m"
	read CHOICE
	if [[ "$CHOICE" == "y" ]]
	then
		sudo su -c "apt install vlc"
	fi
	echo -e "\033[1;31m# INSTALL EMACS EDITOR #\033[0m"; sleep 2
	echo -e "\033[1;33mInstall emacs? (yn)\033[0m"
	read CHOICE
	if [[ "$CHOICE" == "y" ]]
	then
		sudo su -c "apt install emacs-nox"
		echo -e "\033[1;33mInstall emacs with gui? (yn)\033[0m"
		read CHOICE
		if [[ "$CHOICE" == "y"]]
		then
			sudo su -c "apt install emacs"
		fi
	fi
	echo -e "\033[1;31m# INSTALL CONTAINER (lxd or docker) #\033[0m"; sleep 2
	echo -e "\033[1;33mInstall lxd? (yn)\033[0m"
	read CHOICE
	if [[ "$CHOICE" == "y" ]]
	then
		sudo su -c "apt install lxd usbutils"
	fi
	echo -e "\033[1;33mInstall docker? (yn)\033[0m"
	read CHOICE
	if [[ "$CHOICE" == "y" ]]
	then
		sudo su -c "apt install docker.io"
	fi


	sudo su -c "/usr/sbin/usermod -aG sudo,lxd $USER"
	echo -e "\033[1;33mAutologin : PC(y) / other[orangepi, raspberry, ...](n) ?\033[0m"
	read CHOICE
	if [[ "$CHOICE" == "y" ]]
	then
		sudo su -c "sed -i \"s#^ExecStart#ExecStart=-/sbin/agetty -a $USER --noclear %I \$TERM\n\#ExecStart#\" /etc/systemd/system/getty.target.wants/getty@tty1.service"
	fi
fi

if [[ "$1" == "container" ]]
then
	echo -e "\033[1;31m# INSTALL PACKAGE #\033[0m"
	echo -e "\033[1;31m# INSTALL MY MINIMAL ENV #\033[0m"; sleep 2
	sudo su -c "apt install command-not-found curl git openssh-server openssh-client sshfs sudo vim zsh"
	echo -e "\033[1;31m# INSTALL DEV ENV (build-essential or clang) #\033[0m"; sleep 2
	echo -e "\033[1;33mInstall build-essential? (yn)\033[0m"
	read CHOICE
	if [[ "$CHOICE" == "y" ]]
	then
		sudo su -c "apt install build-essential"
	fi
	echo -e "\033[1;33mInstall clang? (yn)\033[0m"
	read CHOICE
	if [[ "$CHOICE" == "y" ]]
	then
		sudo su -c "apt install clang"
	fi
	echo -e "\033[1;31m# INSTALL EMACS EDITOR #\033[0m"; sleep 2
	echo -e "\033[1;33mInstall emacs? (yn)\033[0m"
	read CHOICE
	if [[ "$CHOICE" == "y" ]]
	then
		sudo su -c "apt install emacs-nox"
		echo -e "\033[1;33mInstall emacs with gui? (yn)\033[0m"
		read CHOICE
		if [[ "$CHOICE" == "y"]]
		then
			sudo su -c "apt install emacs"
		fi
	fi
fi

################################################################################
# SETUP ZSH ####################################################################
################################################################################
if [[ "$1" == "setup" || "$1" == "update" || "$1" == "container" ]]
then
	echo -e "\033[1;31m# SETUP ZSH #\033[0m"; sleep 2
	rm -rf $HOME/.oh-my-zsh
	echo -e "\033[1;33mAccept zsh to be your default shell,\033[0m"
	echo -e "\033[1;33mAfter entering into zsh shell (with oh-my-zsh) : 'exit' zsh to finish installation\033[0m"
	sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions
	git clone --depth 1 https://github.com/zsh-users/zsh-completions $HOME/.oh-my-zsh/custom/plugins/zsh-completions
	git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

	cp config/bureau_mod.zsh-theme $HOME/.oh-my-zsh/custom/themes/

	sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="bureau_mod"/' $HOME/.zshrc
	sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-completions zsh-syntax-highlighting web-search lxd command-not-found)/' $HOME/.zshrc
	echo "source \$HOME/.henintsoarc" | tee -a $HOME/.zshrc
	echo -e "\033[1;33mCOMMENT <IF> BLOCK THAT CONTAIN <STARTX> OR <XHOST> ON ~/.henintsoarc if you are not in PC like orangepi, raspberry,... \033[0m";sleep 2
	echo ""
	echo -e "\033[1;33mHello 😋\033[0m"
	echo -e "\033[1;33mYou can enter to zsh now\033[0m"
fi

################################################################################
# SETUP GUI ####################################################################
################################################################################
if [[ "$1" == "setup" || "$1" == "update" ]]
then
	mkdir -p $HOME/Pictures
	mkdir -p $HOME/.config
	mkdir -p $HOME/.config/i3
	mkdir -p $HOME/.config/picom
	mkdir -p $HOME/.config/polybar

	cp wallpaper/Wallpaper.png $HOME/Pictures

	cp config/feh $HOME/.fehbg
	chmod 754 $HOME/.fehbg

	cp config/xinitrc $HOME/.xinitrc
	cp config/xresource $HOME/.Xresources

	cp config/i3 $HOME/.config/i3/config
	cp config/picom $HOME/.config/picom/picom.conf
	cp config/polybar $HOME/.config/polybar/config.ini
fi

################################################################################
# SETUP LAST CONFIG ############################################################
################################################################################
if [[ "$1" == "setup" || "$1" == "update" || "$1" == "container" ]]
then
	mkdir -p $HOME/Documents
	mkdir -p $HOME/.fonts
	mkdir -p $HOME/.emacs.snippets

	cd fonts
	tar -xJf SauceCodeProNerdFontMono.tar.xz
	mv *.ttf $HOME/.fonts
	cd ..

	cp config/henintsoarc $HOME/.henintsoarc
	cp documents/lxc_gui $HOME/Documents
	cp config/emacs $HOME/.emacs
	cp -r config/emacs.snippets/* $HOME/.emacs.snippets

	echo -e "\033[1;31m# SETUP FINISHED #\033[0m"; sleep 2
fi
