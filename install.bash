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
	echo -e "\033[1;31m# INSTALL MY MINIMAL ENV #\033[0m"; sleep 2
	sudo su -c "apt install alsa-utils command-not-found curl git network-manager openssh-server openssh-client sshfs sudo vim zsh"
	echo -e "\033[1;31m# INSTALL DEV ENV (build-essential || clang) #\033[0m"; sleep 2
 	sudo su -c "apt install build-essential"
	sudo su -c "apt install clang"
 	echo -e "\033[1;31m# INSTALL GUI (i3) #\033[0m"; sleep 2
 	sudo su -c "apt install bc feh i3 picom polybar rxvt-unicode xorg xserver-xorg-video-intel"
  	echo -e "\033[1;31m# INSTALL BROWSER (firefox) #\033[0m"; sleep 2
 	sudo su -c "apt install firefox-esr"
    	echo -e "\033[1;31m# INSTALL MEDIA PLAYER (vlc) #\033[0m"; sleep 2
 	sudo su -c "apt install vlc"
  	echo -e "\033[1;31m# INSTALL EMACS EDITOR (emacs) #\033[0m"; sleep 2
 	sudo su -c "apt install emacs-nox"
  	sudo su -c "apt install emacs"
  	echo -e "\033[1;31m# INSTALL CONTAINER (lxd || docker) #\033[0m"; sleep 2
  	sudo su -c "apt install lxd usbutils"
   	sudo su -c "apt install docker.io"

 
	sudo su -c "/usr/sbin/usermod -aG sudo,lxd $USER"
	sudo su -c "sed -i \"s#^ExecStart#ExecStart=-/sbin/agetty -a $USER --noclear %I \$TERM\n\#ExecStart#\" /etc/systemd/system/getty.target.wants/getty@tty1.service"
fi

if [[ "$1" == "container" ]]
then
	echo -e "\033[1;31m# INSTALL PACKAGE #\033[0m"
	echo -e "\033[1;31m# INSTALL MY MINIMAL ENV #\033[0m"; sleep 2
	sudo su -c "apt install command-not-found curl git openssh-server openssh-client sshfs sudo vim zsh"
	echo -e "\033[1;31m# INSTALL DEV ENV (build-essential || clang) #\033[0m"; sleep 2
 	sudo su -c "apt install build-essential"
	sudo su -c "apt install clang"
  	echo -e "\033[1;31m# INSTALL EMACS EDITOR (emacs) #\033[0m"; sleep 2
 	sudo su -c "apt install emacs-nox"
  	sudo su -c "apt install emacs"
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
	echo ""
	echo -e "\033[1;33mHello :D\033[0m"
 	echo -e "\033[1;33mEnter to zsh now\033[0m"
fi

if [[ "$1" == "setup" || "$1" == "update" ]]
then
	mkdir -p $HOME/Pictures
	mkdir -p $HOME/Documents
 	mkdir -p $HOME/.fonts
	mkdir -p $HOME/.config
	mkdir -p $HOME/.config/i3
	mkdir -p $HOME/.config/picom
	mkdir -p $HOME/.config/polybar

	cp wallpaper/Wallpaper.png $HOME/Pictures
	cp documents/lxc_gui $HOME/Documents

 	cd fonts
  	tar -xJf SauceCodeProNerdFontMono.tar.xz
   	mv *.ttf $HOME/.fonts
  	cd ..

	cp config/feh $HOME/.fehbg
	chmod 754 $HOME/.fehbg

	cp config/xinitrc $HOME/.xinitrc
	cp config/xresource $HOME/.Xresource
	cp config/henintsoarc $HOME/.henintsoarc

	cp config/i3 $HOME/.config/i3/config
	cp config/picom $HOME/.config/picom/picom.conf
	cp config/polybar $HOME/.config/polybar/config.ini	
fi
