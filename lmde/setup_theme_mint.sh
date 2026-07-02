clear

echo -ne "
   ████████╗  █████╗  ██╗   ██╗  ████████╗ ███████╗  ██████╗ ██╗  ██╗
   ╚══██╔══╝ ██╔══██╗  ██╗ ██╔╝  ╚══██╔══╝ ██╔════╝ ██╔════╝ ██║  ██║
      ██║    ███████║   ████╔╝      ██║    ███████╗ ██║      ███████║
   ██ ██║    ██╔══██║  ██╔╝██╗      ██║    ██╔════╝ ██║      ██╔══██║
   ╚███╔╝    ██║  ██║ ██╔╝  ██╗     ██║    ███████╗ ╚██████╗ ██║  ██║
    ╚══╝     ╚═╝  ╚═╝ ╚═╝   ╚═╝     ╚═╝    ╚══════╝  ╚═════╝ ╚═╝  ╚═╝

"
echo " Mint Theme Reset script will launch in 5 seconds..."

sleep 5

sudo apt remove plank -y
killall plank

install_path=$(pwd)

##### To get current gsettings from command line
##### gsettings list-recursively | grep -i <current_setting>
gsettings set org.cinnamon.desktop.background picture-uri 'file:///usr/share/backgrounds/linuxmint/ktee_linuxmint.png'
gsettings set org.cinnamon.desktop.interface cursor-theme 'Bibata-Modern-Classic'
gsettings set org.cinnamon.desktop.interface gtk-theme 'Mint-Y-Aqua'
gsettings set org.cinnamon.desktop.interface icon-theme 'Mint-Y-Sand'
gsettings set org.cinnamon.theme name 'Mint-Y-Dark-Aqua'
gsettings set org.nemo.desktop computer-icon-visible false
gsettings set org.nemo.desktop home-icon-visible false
gsettings set org.nemo.desktop network-icon-visible false
gsettings set org.nemo.desktop trash-icon-visible false
gsettings set com.linuxmint.mintmenu applet-icon 'linuxmint-logo-ring-symbolic'
gsettings set org.cinnamon.desktop.interface clock-show-date false
gsettings set org.cinnamon panels-enabled "['1:0:bottom']"
gsettings set org.cinnamon panels-height "['1:40']"
gsettings set org.cinnamon enabled-applets "['panel1:left:0:menu@cinnamon.org:0', 'panel1:left:1:separator@cinnamon.org:1', 'panel1:left:2:grouped-window-list@cinnamon.org:2', 'panel1:right:0:systray@cinnamon.org:3', 'panel1:right:1:xapp-status@cinnamon.org:4', 'panel1:right:2:notifications@cinnamon.org:5', 'panel1:right:3:printers@cinnamon.org:6', 'panel1:right:4:removable-drives@cinnamon.org:7', 'panel1:right:5:keyboard@cinnamon.org:8', 'panel1:right:6:favorites@cinnamon.org:9', 'panel1:right:7:network@cinnamon.org:10', 'panel1:right:8:sound@cinnamon.org:11', 'panel1:right:9:power@cinnamon.org:12', 'panel1:right:10:calendar@cinnamon.org:13', 'panel1:right:11:cornerbar@cinnamon.org:14']"

cp $install_path/configs/0.json ~/.config/cinnamon/spices/menu@cinnamon.org/

[ -d ~/.icons ] && rm -rf ~/.icons/*
[ -d ~/.themes ] && rm -rf ~/.themes/*
[ -d ~/.config/plank ] && rm -rf ~/.config/plank/
[ -d ~/.local/share/plank ] && rm -rf ~/.local/share/plank/
[ -d ~/.config/cinnamon/spices/Cinnamenu@json ] && rm -rf ~/.config/cinnamon/spices/Cinnamenu@json/
[ -d ~/.local/share/cinnamon/applets/Cinnamenu@json ] && rm -rf ~/.local/share/cinnamon/applets/Cinnamenu@json/
[ -d ~/.config/cinnamon/spices/CinnVIIStarkMenu@NikoKrause ] && rm -rf ~/.config/cinnamon/spices/CinnVIIStarkMenu@NikoKrause/
[ -d ~/.local/share/cinnamon/applets/CinnVIIStarkMenu@NikoKrause ] && rm -rf ~/.local/share/cinnamon/applets/CinnVIIStarkMenu@NikoKrause/
[ -d /usr/share/backgrounds/windows-xp ] && sudo rm -rf /usr/share/backgrounds/windows-xp/
[ -d /usr/share/backgrounds/windows-7 ] && sudo rm -rf /usr/share/backgrounds/windows-7/
[ -d /usr/share/backgrounds/windows-10 ] && sudo rm -rf /usr/share/backgrounds/windows-10/
[ -d /usr/share/backgrounds/windows-11 ] && sudo rm -rf /usr/share/backgrounds/windows-11/

gio set -t unset $HOME/Desktop metadata::custom-icon
