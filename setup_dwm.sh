##### PACKAGES
gxmessage
sxiv 

terminus-font
ttf-mononoki-nerd

lightdm
lightdm-gtk-greeter 

openssh
firefox
qutebrowser
mousepad
figlet
sxhkd

##### wallpapers -- Make sure wallpapers directory exists or add wallpapers if it doesn't exist
[ ! -d ~/wallpapers ] && mkdir -p ~/wallpapers 2>&1 | tee -a $LOG
cp $INSTALL_PATH/wallpapers/* ~/wallpapers/ 2>&1 | tee -a $LOG

##### xsessions -- Make sure xsessions directory exists and add dwm.desktop file
##### This file allows users to select DWM as a session option when logging into their system through a display manager.
[ ! -d /usr/share/xsessions ] && sudo mkdir -p /usr/share/xsessions 2>&1 | tee -a $LOG
sudo cp $INSTALL_PATH/dotfiles/dwm.desktop /usr/share/xsessions/ 2>&1 | tee -a $LOG


##### openssh -- Enable and start openssh
echo "Enabling and starting openssh..."
sleep 5
sudo systemctl enable sshd
sudo systemctl start sshd
sudo ufw allow ssh
sleep 5

