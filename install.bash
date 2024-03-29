###############################################################################
# SOME FUNCTION ###############################################################
###############################################################################
INSTALL_MINIMAL_ENV ()
{
	echo -e "\033[1;31m# INSTALL MINIMAL ENV #\033[0m"; sleep 2
	sudo su -c "apt-get install alsa-utils asciinema command-not-found curl git mdp modemmanager network-manager openssh-server openssh-client sshfs sudo vim zsh"
}

INSTALL_MINIMAL_ENV_CONTAINER ()
{
	echo -e "\033[1;31m# INSTALL MY MINIMAL ENV #\033[0m"; sleep 2
	sudo su -c "apt-get install asciinema command-not-found curl git openssh-server openssh-client sshfs sudo vim zsh"
}

INSTALL_DEV_ENV ()
{
	echo -e "\033[1;31m# INSTALL DEV ENV (build-essential or clang) #\033[0m"; sleep 2
	echo -e "\033[1;33mInstall build-essential? (yn)\033[0m"
	read CHOICE
	if [[ "$CHOICE" == "y" ]]
	then
		sudo su -c "apt-get install build-essential"
		echo -e "\033[1;33mInstall debugger gdb? (yn)\033[0m"
		read CHOICE
		if [[ "$CHOICE" == "y" ]]
		then
			sudo su -c "apt-get install gdb"
		fi
	fi
	echo -e "\033[1;33mInstall clang? (yn)\033[0m"
	read CHOICE
	if [[ "$CHOICE" == "y" ]]
	then
		sudo su -c "apt-get install clang"
		echo -e "\033[1;33mInstall debugger lldb? (yn)\033[0m"
		read CHOICE
		if [[ "$CHOICE" == "y" ]]
		then
			sudo su -c "apt-get install lldb"
		fi
	fi
}

INSTALL_EMACS ()
{
	echo -e "\033[1;31m# INSTALL EMACS EDITOR #\033[0m"; sleep 2
	echo -e "\033[1;33mInstall emacs? (yn)\033[0m"
	read CHOICE
	if [[ "$CHOICE" == "y" ]]
	then
		echo -e "\033[1;33mInstall emacs with gui? (yn)\033[0m"
		read CHOICE
		if [[ "$CHOICE" == "y" ]]
		then
			sudo su -c "apt-get install emacs"
   		else
			sudo su -c "apt-get install emacs-nox"
		fi
	fi
}

INSTALL_GUI ()
{
	echo -e "\033[1;31m# INSTALL GUI #\033[0m"; sleep 2
	echo -e "\033[1;33mInstall i3? (yn)\033[0m"
	read CHOICE
	if [[ "$CHOICE" == "y" ]]
	then
		sudo su -c "apt-get install bc feh i3 i3lock greybird-gtk-theme picom conky polybar rxvt-unicode scrot suckless-tools xorg"
  		sudo su -c "apt-get install xserver-xorg-video-intel"
		username=$(id -nu 1000)
		sudo su - ${username} -c 'crontab -l | { cat; echo "* * * * * /usr/local/bin/wallpaper"; } | crontab -'
	fi
	echo -e "\033[1;31m# INSTALL FILE MANAGER #\033[0m"; sleep 2
	echo -e "\033[1;33mInstall pcmanfm? (yn)\033[0m"
	read CHOICE
	if [[ "$CHOICE" == "y" ]]
	then
		sudo su -c "apt-get install pcmanfm"
		echo -e "\033[1;33mInstall lxappearance? (yn)\033[0m"
		read CHOICE
		if [[ "$CHOICE" == "y" ]]
		then
			sudo su -c "apt-get install lxappearance"
		fi
	fi
	echo -e "\033[1;31m# INSTALL BROWSER #\033[0m"; sleep 2
	echo -e "\033[1;33mInstall firefox? (yn)\033[0m"
	read CHOICE
	if [[ "$CHOICE" == "y" ]]
	then
		sudo su -c "apt-get install firefox-esr"
	fi
	echo -e "\033[1;31m# INSTALL MEDIA PLAYER #\033[0m"; sleep 2
	echo -e "\033[1;33mInstall vlc? (yn)\033[0m"
	read CHOICE
	if [[ "$CHOICE" == "y" ]]
	then
		sudo su -c "apt-get install vlc"
	fi
}

INSTALL_CONTAINER ()
{
	echo -e "\033[1;31m# INSTALL CONTAINER (lxd or docker) #\033[0m"; sleep 2
	echo -e "\033[1;33mInstall lxd? (yn)\033[0m"
	read CHOICE
	if [[ "$CHOICE" == "y" ]]
	then
		sudo su -c "apt-get install lxd usbutils"
	fi
	echo -e "\033[1;33mInstall docker? (yn)\033[0m"
	read CHOICE
	if [[ "$CHOICE" == "y" ]]
	then
		sudo su -c "apt-get install ca-certificates curl gnupg"
		sudo su -c "install -m 0755 -d /etc/apt/keyrings"
		curl -fsSL https://download.docker.com/linux/debian/gpg | sudo su -c "gpg --dearmor -o /etc/apt/keyrings/docker.gpg"
		sudo su -c "chmod a+r /etc/apt/keyrings/docker.gpg"

  		echo \
			"deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
			"$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
			sudo su -c "tee /etc/apt/sources.list.d/docker.list" > /dev/null
		sudo su -c "apt-get update"
  		sudo su -c "apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin"
	fi
}

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
# CHECK ARGUMENT ###############################################################
################################################################################
if [[ "$1" == "setup" || "$1" == "update" || "$1" == "container" ]]
then
	echo -e "\033[1;31m# CHECKING IF EVERYTHING IS COOL #\033[0m"; sleep 2
	sudo su -c "apt-get update"
else
	echo "usage : $0 setup|update|container"
	exit
fi

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
# INSTALL PACKAGE ##############################################################
################################################################################
if [[ "$1" == "setup" ]]
then
	echo -e "\033[1;31m# INSTALL PACKAGE #\033[0m"
	INSTALL_MINIMAL_ENV
	INSTALL_DEV_ENV
	INSTALL_GUI
 	INSTALL_EMACS
	INSTALL_CONTAINER

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
	INSTALL_MINIMAL_ENV_CONTAINER
	INSTALL_DEV_ENV
	INSTALL_EMACS
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
	sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-completions zsh-syntax-highlighting web-search command-not-found dirhistory)/' $HOME/.zshrc
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
	mkdir -p $HOME/.config/conky
	mkdir -p $HOME/.config/i3
	mkdir -p $HOME/.config/picom
	mkdir -p $HOME/.config/polybar

	cp wallpaper/Wallpaper.png $HOME/Pictures

	cp config/feh $HOME/.fehbg
	chmod 754 $HOME/.fehbg

	cp config/xinitrc $HOME/.xinitrc
	cp config/xresource $HOME/.Xresources

	cp config/i3 $HOME/.config/i3/config
	cp config/conky $HOME/.config/conky/conky.conf
	cp config/picom $HOME/.config/picom/picom.conf
	cp config/polybar $HOME/.config/polybar/config.ini

	CPU=$(lscpu |grep "^CPU(s):" |awk '{print $2}')
	for I in $(seq 1 1 $CPU)
	do
		if [[ $((($I-1)%4)) -eq 0 ]]
		then
			if [[ $I -eq 1 ]]
			then
				CPU_CONKY="\$alignc-"
			else
				CPU_CONKY="$CPU_CONKY\n\$alignc-"
			fi
		fi
		CPU_CONKY="$CPU_CONKY \${cpu cpu$I}% -"
	done
	sed -i "s#CPU_NUMBER#$CPU_CONKY#" $HOME/.config/conky/conky.conf

	INTERFACES=$(nmcli device status |grep "wifi \| ethernet" |awk '{print $1}')
	I=0
	echo "Select (number) interface to show on conky"
	for INTERFACE in $INTERFACES
	do
		I=$(($I+1))
		echo "$I -> $INTERFACE"
	done
	read INT
	I=0
	for INTERFACE in $INTERFACES
	do
		I=$(($I+1))
		if [[ $I -eq $INT ]]
		then
			sed -i "s#NETWORK_INTERFACE#$INTERFACE#g" $HOME/.config/conky/conky.conf
		fi
	done

	MONITORS=$(ls /sys/class/hwmon)
	echo "Select (number) temperature to show on conky"
	for MONITOR in $MONITORS
	do
		CMD=$(cat /sys/class/hwmon/$MONITOR/name)
		HWMON=$(echo $MONITOR | sed "s#hwmon##")
		echo "$HWMON -> $CMD"
	done
	read TEMP
	I=0
	for MONITOR in $MONITORS
	do
		CMD=$(cat /sys/class/hwmon/$MONITOR/name)
		HWMON=$(echo $MONITOR | sed "s#hwmon##")
		if [[ $HWMON -eq $TEMP ]]
		then
			sed -i "s#hwmon 0#hwmon $HWMON#g" $HOME/.config/conky/conky.conf
		fi
	done
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
