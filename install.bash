if [[ $UID -eq 0 ]]
then
	echo "don't run as root"
	exit
fi

sudo echo "cool"
if [[ "$1" == "setup" || "$1" == "update" ]]
then
	sudo su -c "cp bin/* /usr/local/bin/"
	sudo su -c "chmod +x /usr/local/bin/*"
fi

if [[ "$1" == "setup" || "$1" == "update" || "$1" == "container" ]]
then
	echo "install begin"
else
	echo "usage : $0 setup|update|container"
	exit
fi

if [[ "$1" == "setup" ]]
then
	sudo su -c "apt install sudo vim zsh build-essential git curl network-manager alsa-utils sshfs"
	sudo su -c "apt install xorg xserver-xorg-video-intel fonts-hack i3 feh  picom bc polybar"
 	sudo su -c "apt install firefox-esr vlc"
  	sudo su -c "apt install lxd"
   	sudo su -c "apt install docker.io"
 
	sudo su -c "/usr/sbin/usermod -aG sudo,lxd $USER"
	sudo su -c "sed -i \"s#^ExecStart#ExecStart=-/sbin/agetty -a $USER --noclear %I \$TERM\n\#ExecStart#\" /etc/systemd/system/getty.target.wants/getty@tty1.service"
fi

if [[ "$1" == "container" ]]
then
	sudo su -c "apt install zsh git curl sshfs openssh-server openssh-client"
 	sudo su -c "build-essential"
	rm -rf $HOME/.oh-my-zsh
	echo "After entering into zsh shell (with oh-my-zsh) : 'exit' zsh to finish installation"
	sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions
	git clone --depth 1 https://github.com/zsh-users/zsh-completions $HOME/.oh-my-zsh/custom/plugins/zsh-completions
	git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

	cp config/bureau_mod.zsh-theme $HOME/.oh-my-zsh/custom/themes/

	sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="bureau_mod"/' $HOME/.zshrc
	sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-completions zsh-syntax-highlighting web-search)/' $HOME/.zshrc
	touch $HOME/.henintsoarc
	echo "source \$HOME/.henintsoarc" | tee -a $HOME/.zshrc
	
	echo ""
	echo "Hello :D"
	exit
fi

if [[ "$1" == "setup" || "$1" == "update" ]]
then
	mkdir -p $HOME/Pictures
	mkdir -p $HOME/Documents
	mkdir -p $HOME/.config
	mkdir -p $HOME/.config/i3
	mkdir -p $HOME/.config/picom
	mkdir -p $HOME/.config/polybar

	cp wallpaper/rx7c.jpg $HOME/Pictures
	cp documents/lxc_gui $HOME/Documents

	cp config/feh $HOME/.fehbg
	chmod 754 $HOME/.fehbg

	cp config/xinitrc $HOME/.xinitrc
	cp config/xresource $HOME/.Xresource
	cp config/henintsoarc $HOME/.henintsoarc

	cp config/i3 $HOME/.config/i3/config
	cp config/picom $HOME/.config/picom/picom.conf
	cp config/polybar $HOME/.config/polybar/config.ini
fi

if [[ "$1" == "setup" ]]
then
	rm -rf $HOME/.oh-my-zsh
	echo "After entering into zsh shell (with oh-my-zsh) : 'exit' zsh to finish installation"
	sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions
	git clone --depth 1 https://github.com/zsh-users/zsh-completions $HOME/.oh-my-zsh/custom/plugins/zsh-completions
	git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

	cp config/bureau_mod.zsh-theme $HOME/.oh-my-zsh/custom/themes/

	sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="bureau_mod"/' $HOME/.zshrc
	sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-completions zsh-syntax-highlighting web-search)/' $HOME/.zshrc
	echo "source \$HOME/.henintsoarc" | tee -a $HOME/.zshrc
	
	echo ""
	echo "Hello :D"
fi

if [[ "$1" == "update" ]]
then
	rm -rf $HOME/.oh-my-zsh/custom/plugins/BACKUP
	mkdir $HOME/.oh-my-zsh/custom/plugins/BACKUP
	mv $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions $HOME/.oh-my-zsh/custom/plugins/zsh-completions $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting $HOME/.oh-my-zsh/custom/plugins/BACKUP
	git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions
	git clone --depth 1 https://github.com/zsh-users/zsh-completions $HOME/.oh-my-zsh/custom/plugins/zsh-completions
	git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
	cp config/bureau_mod.zsh-theme $HOME/.oh-my-zsh/custom/themes/
fi
