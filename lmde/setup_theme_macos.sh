clear

echo -ne "
   ████████╗  █████╗  ██╗   ██╗  ████████╗ ███████╗  ██████╗ ██╗  ██╗
   ╚══██╔══╝ ██╔══██╗  ██╗ ██╔╝  ╚══██╔══╝ ██╔════╝ ██╔════╝ ██║  ██║
      ██║    ███████║   ████╔╝      ██║    ███████╗ ██║      ███████║
   ██ ██║    ██╔══██║  ██╔╝██╗      ██║    ██╔════╝ ██║      ██╔══██║
   ╚███╔╝    ██║  ██║ ██╔╝  ██╗     ██║    ███████╗ ╚██████╗ ██║  ██║
    ╚══╝     ╚═╝  ╚═╝ ╚═╝   ╚═╝     ╚═╝    ╚══════╝  ╚═════╝ ╚═╝  ╚═╝

"
echo " macOS Theme script will launch in 5 seconds..."

sleep 5

sudo apt install plank -y

##########################################
###  BASE CONFIG INSTALLATION SECTION  ###
##########################################
install_path=$(pwd)
[ ! -d ~/.icons ] && mkdir -p ~/.icons
[ ! -d ~/.themes ] && mkdir -p ~/.themes
[ ! -d /usr/share/backgrounds/macOS ] && sudo mkdir -p /usr/share/backgrounds/macOS

sudo cp $install_path/theme-macos/macOS-10-13-High-Sierra-1920x1200.jpg /usr/share/backgrounds/macOS/
sudo cp $install_path/theme-macos/macOS-10-15-Catalina-1920x1200.jpg /usr/share/backgrounds/macOS/

unzip -q $install_path/theme-macos/macOS-Cursors.zip -d ~/.icons/
unzip -q $install_path/theme-macos/macOS-Icons.zip -d ~/.icons/
unzip -q $install_path/theme-macos/macOS-Theme-6.1-Dark.zip -d ~/.themes/
unzip -q $install_path/theme-macos/macOS-Theme-6.1-Light.zip -d ~/.themes/
sleep 2

##### To get current gsettings from command line
##### gsettings list-recursively | grep -i <current_setting>
gsettings set org.cinnamon.desktop.background picture-uri 'file:///usr/share/backgrounds/macOS/macOS-10-15-Catalina-1920x1200.jpg'
gsettings set org.cinnamon.desktop.interface cursor-theme 'macOS-Cursors'
gsettings set org.cinnamon.desktop.interface gtk-theme 'macOS-Theme-6.1-Dark'
gsettings set org.cinnamon.desktop.interface icon-theme 'macOS-Icons'
gsettings set org.cinnamon.theme name 'macOS-Theme-6.1-Dark'
gsettings set org.cinnamon.desktop.interface clock-show-date true
#gsettings set org.nemo.desktop computer-icon-visible true
#gsettings set org.nemo.desktop home-icon-visible true
#gsettings set org.nemo.desktop network-icon-visible true
gsettings set org.nemo.desktop trash-icon-visible true
gsettings set org.cinnamon panels-enabled "['1:0:top']"
gsettings set org.cinnamon panels-height "['1:24']"
gsettings set org.cinnamon enabled-applets "['panel1:left:0:menu@cinnamon.org:0', 'panel1:right:0:systray@cinnamon.org:3', 'panel1:right:1:xapp-status@cinnamon.org:4', 'panel1:right:2:notifications@cinnamon.org:5', 'panel1:right:3:printers@cinnamon.org:6', 'panel1:right:4:removable-drives@cinnamon.org:7', 'panel1:right:5:keyboard@cinnamon.org:8', 'panel1:right:6:favorites@cinnamon.org:9', 'panel1:right:7:network@cinnamon.org:10', 'panel1:right:8:sound@cinnamon.org:11', 'panel1:right:9:power@cinnamon.org:12', 'panel1:right:10:calendar@cinnamon.org:13', 'panel1:right:11:cornerbar@cinnamon.org:14']"

cp $install_path/theme-macos/plank.desktop ~/.config/autostart/
cp $install_path/theme-macos/0.json ~/.config/cinnamon/spices/menu@cinnamon.org/

##### Cleanup previous plank install and start new instance
plank &
sleep 2
killall plank
sleep 2
cp $install_path/theme-macos/launchers/* ~/.config/plank/dock1/launchers/ 2>/dev/null
sleep 2
plank &

exit
