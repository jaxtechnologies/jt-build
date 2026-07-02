clear

echo -ne "
   ████████╗  █████╗  ██╗   ██╗  ████████╗ ███████╗  ██████╗ ██╗  ██╗
   ╚══██╔══╝ ██╔══██╗  ██╗ ██╔╝  ╚══██╔══╝ ██╔════╝ ██╔════╝ ██║  ██║
      ██║    ███████║   ████╔╝      ██║    ███████╗ ██║      ███████║
   ██ ██║    ██╔══██║  ██╔╝██╗      ██║    ██╔════╝ ██║      ██╔══██║
   ╚███╔╝    ██║  ██║ ██╔╝  ██╗     ██║    ███████╗ ╚██████╗ ██║  ██║
    ╚══╝     ╚═╝  ╚═╝ ╚═╝   ╚═╝     ╚═╝    ╚══════╝  ╚═════╝ ╚═╝  ╚═╝

"
echo " Windows XP Themes script will launch in 5 seconds..."

sleep 5


##########################################
###  BASE CONFIG INSTALLATION SECTION  ###
##########################################
install_path=$(pwd)
[ ! -d ~/.icons ] && mkdir -p ~/.icons
[ ! -d ~/.themes ] && mkdir -p ~/.themes
[ ! -d /usr/share/backgrounds/windows-xp ] && sudo mkdir -p /usr/share/backgrounds/windows-xp

sudo cp $install_path/theme-winxp/Win-XP-1920x1200.jpg /usr/share/backgrounds/windows-xp/

unzip -q $install_path/theme-winxp/Win-XP-Cursors-S.zip -d ~/.icons/
unzip -q $install_path/theme-winxp/Win-XP-Icons.zip -d ~/.icons/
unzip -q $install_path/theme-winxp/Win-XP-Theme.zip -d ~/.themes/
unzip -q $install_path/theme-winxp/Win-7-Menu-Applet.zip -d ~/.local/share/cinnamon/applets/
unzip -q $install_path/theme-winxp/Win-7-Menu-Config.zip -d ~/.config/cinnamon/spices/
sleep 2

##### To get current gsettings from command line
##### gsettings list-recursively | grep -i <current_setting>
gsettings set org.cinnamon.desktop.background picture-uri 'file:///usr/share/backgrounds/windows-xp/Win-XP-1920x1200.jpg'
gsettings set org.cinnamon.desktop.interface cursor-theme 'Win-XP-Cursors-S'
gsettings set org.cinnamon.desktop.interface gtk-theme 'Windows XP Luna'
gsettings set org.cinnamon.desktop.interface icon-theme 'Win-XP-Icons'
gsettings set org.cinnamon.theme name 'Windows XP Luna'
gsettings set org.cinnamon.desktop.interface clock-show-date true
gsettings set org.nemo.desktop computer-icon-visible true
gsettings set org.nemo.desktop home-icon-visible true
gsettings set org.nemo.desktop network-icon-visible true
gsettings set org.nemo.desktop trash-icon-visible true
gsettings set org.cinnamon enabled-applets "['panel1:left:0:CinnVIIStarkMenu@NikoKrause:15', 'panel1:left:1:grouped-window-list@cinnamon.org:2', 'panel1:right:2:systray@cinnamon.org:3', 'panel1:right:3:xapp-status@cinnamon.org:4', 'panel1:right:4:notifications@cinnamon.org:5', 'panel1:right:5:printers@cinnamon.org:6', 'panel1:right:6:removable-drives@cinnamon.org:7', 'panel1:right:7:keyboard@cinnamon.org:8', 'panel1:right:8:favorites@cinnamon.org:9', 'panel1:right:9:network@cinnamon.org:10', 'panel1:right:10:sound@cinnamon.org:11', 'panel1:right:11:power@cinnamon.org:12', 'panel1:right:12:calendar@cinnamon.org:13', 'panel1:right:13:cornerbar@cinnamon.org:14']"

cp $install_path/theme-winxp/0.json ~/.config/cinnamon/spices/menu@cinnamon.org/
