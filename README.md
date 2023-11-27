# NOTICE
WORK PERFECT ON DEBIAN 12,
ON OTHER DISTRO, OTHER PACKAGE MAY HAVE DIFFERENT NAME (NOT TESTED)

# USAGE
Firstly :
```
cd
mkdir INSTALL
cd INSTALL
git clone --depth 1 https://github.com/henintsoa98/dotfiles
cd dotfiles
```
For installation on normal system, with GUI or without GUI, use **setup**, to update a previous installation use **update**\
For container setup, use **container**, to update container, also use **container**, not **update**\
\
Setup sudo firstly, the user need to be in group sudo\
then
```
bash install.bash setup
```
or
```
bash install.bash update
```
or
```
bash install.bash container
```


## WHAT'S APPEND?
# default :
    add or update all my script in /usr/local/bin

# setup :
    install graphical environment with i3, zsh, firefox, vlc, lxd
    setup all config file

# update :
    update all config file    

# container :
    setup zsh
    (don't update container, use container to update container)
