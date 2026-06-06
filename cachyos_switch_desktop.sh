#!/usr/bin/bash
# Script to change Desktop Environments
# 2026-03-26
# Eddie Reynolds
#

INSTALL_PATH=$(pwd)

get_current_desktop () {
    printf '%s\n' "${DESKTOP_SESSION:-Unknown}"
}

get_current_desktop_key () {
	case "$(get_current_desktop | tr '[:upper:]' '[:lower:]')" in
		*cinnamon*)
			echo "cinnamon"
			;;
		*cosmic*)
			echo "cosmic"
			;;
		*gnome*)
			echo "gnome"
			;;
		*i3*)
			echo "i3"
			;;
		*kde*|*plasma*)
			echo "kde"
			;;
		*niri*)
			echo "niri"
			;;
		*openbox*)
			echo "obenbox"
			;;
		*qtile*)
			echo "qtile"
			;;
		*)
			echo ""
			;;
	esac
}

remove_current_desktop () {
	case "$(get_current_desktop_key)" in
		cinnamon)
			clear
			remove_cinnamon
			;;
		cosmic)
			clear
			remove_cosmic
			;;
		gnome)
			clear
			remove_gnome
			;;
		i3)
			clear
			remove_i3
			;;
		kde)
			clear
			remove_kde
			;;
		niri)
			clear
			remove_niri
			;;
		openbox)
			clear
			remove_openbox
			;;
		qtile)
			clear
			remove_qtile
			;;
		*)
			clear
			echo "No supported desktop found in XDG_CURRENT_DESKTOP: $(get_current_desktop)"
			echo "Continuing Setup... Enter sudo password when asked..."
			;;
	esac
}

########################################
##### REMOVE PREVIOUS SETTINGS
########################################

remove_cinnamon () {
	##### cachyos-cinnamon-settings don't exist
	sudo pacman -R cachyos-cinnamon-settings --noconfirm
}

remove_cosmic () {
	##### cachyos-cosmic-settings don't exist
	sudo pacman -R cachyos-cosmic-settings --noconfirm
}

remove_gnome () {
	##### cachyos-gnome-settings don't exist
	sudo pacman -R cachyos-gnome-settings --noconfirm
}

remove_i3 () {
	sudo pacman -R cachyos-i3wm-settings --noconfirm
}

remove_kde () {
	sudo pacman -R cachyos-kde-settings --noconfirm
}

remove_niri () {
	sudo pacman -R cachyos-niri-settings --noconfirm
}

remove_openbox () {
	sudo pacman -R cachyos-openbox-settings --noconfirm
}

remove_qtile () {
	sudo pacman -R cachyos-qtile-settings --noconfirm
}

########################################
##### INSTALL NEW DESKTOP ENVIRONMENT
########################################

install_cinnamon () {
	remove_current_desktop
	sleep 10
	sudo pacman -Syu --noconfirm
	sudo pacman -S cinnamon gnome-terminal nemo-fileroller sddm --needed --noconfirm
    sleep 10
	rsync -a /etc/skel/.config ~/
	sudo systemctl enable sddm
    clear
    echo ""
    echo " Cinnamon installed. Please reboot and select Cinnamon Session from the login screen to start using it."
    sleep 10
    exit_menu
}

install_cosmic () {
	remove_current_desktop
	sleep 10
	sudo pacman -Syu --noconfirm
	sudo pacman -S cosmic-session cosmic-text-editor cosmic-terminal cosmic-store sddm --needed --noconfirm
    sleep 10
	rsync -a /etc/skel/.config ~/
	sudo systemctl enable sddm
    clear
    echo ""
    echo " Cosmic installed. Please reboot and select Cosmic Session from the login screen to start using it."
    sleep 10
    exit_menu
}

install_gnome () {
	remove_current_desktop
	sleep 10
	sudo pacman -Syu --noconfirm
	##### gnome-extra can install a lot of the gnome suite of apps...
	sudo pacman -S gnome cachyos-gnome-settings sddm --needed --noconfirm
    sleep 10
	rsync -a /etc/skel/.config ~/
	sudo systemctl enable sddm
    clear
    echo ""
    echo " Gnome installed. Please reboot and select Gnome Session from the login screen to start using it."
    sleep 10
    exit_menu
}

install_i3 () {
	remove_current_desktop
	sleep 10
	sudo pacman -Syu --noconfirm
	sudo pacman -S i3-wm i3status cachyos-i3wm-settings sddm --needed --noconfirm
    sleep 10
	rsync -a /etc/skel/.config ~/
	sed -i '/refresh-rate/s/^/# /' ~/.config/picom/picom.conf
	sudo systemctl enable sddm
    clear
    echo ""
    echo " i3 installed. Please reboot and select i3 Session from the login screen to start using it."
    sleep 10
    exit_menu
}

install_kde () {
	remove_current_desktop
	sleep 10
	sudo pacman -Syu --noconfirm
	sudo pacman -S plasma-desktop discover dolphin konsole flatpak cachyos-kde-settings sddm --needed --noconfirm
    sleep 10
	rsync -a /etc/skel/.config ~/
	sudo systemctl enable sddm
    clear
    echo ""
    echo " KDE Plasma installed. Please reboot and select KDE Plasma Session from the login screen to start using it."
    sleep 10
    exit_menu
}

install_niri () {
	remove_current_desktop
	sleep 10
	sudo pacman -Syu --noconfirm
	sudo pacman -S niri xwayland-satellite cachyos-niri-noctalia sddm --needed --noconfirm
    sleep 10
	rsync -a /etc/skel/.config ~/
	sudo systemctl enable sddm
    clear
    echo ""
    echo " Niri installed. Please reboot and select Niri Session from the login screen to start using it."
    sleep 10
    exit_menu
}

install_openbox () {
	remove_current_desktop
	sleep 10
	[ ! -d /usr/share/backgrounds/ ] && sudo mkdir -p /usr/share/backgrounds/
	[ ! -d ~/.config/openbox/ ] && mkdir -p ~/.config/openbox/
	[ ! -d ~/.config/tint2/ ] && mkdir -p ~/.config/tint2/
	sudo pacman -Syu --noconfirm

	clear
	echo ""
	echo " Select installation type:"
	echo " 1) Simple Menu Setup"
	echo " 2) OpenBox Style Setup"
	echo ""

	read -rp " Enter choice [1-2]: " choice
	
	case "$choice" in
	    1)
			clear
			echo ""
	        echo " Starting Simple Menu Setup..."
	
	        # Simple Menu Setup commands
	        sudo pacman -S openbox xfce4-terminal xcompmgr tint2 yad feh polkit-gnome xorg-xrandr jgmenu lightdm lightdm-gtk-greeter --needed --noconfirm
			sleep 10
			rsync -a /etc/skel/.config ~/
			sudo cp $INSTALL_PATH/openbox/backgrounds/wallpaper.jpg /usr/share/backgrounds/wallpaper.jpg
			cp $INSTALL_PATH/openbox/.config/openbox/* ~/.config/openbox/
			cp $INSTALL_PATH/openbox/.config/tint2/* ~/.config/tint2/
	
	        ;;
	    2)
			clear
			echo ""
	        echo " Starting OpenBox Style Setup..."
	
	        # OpenBox Style Setup commands
	        sudo pacman -S obconf-qt libwnck3 acpi arandr archlinux-xdg-menu dex dmenu dunst feh gvfs gvfs-afc gvfs-gphoto2 gvfs-mtp gvfs-nfs gvfs-smb jgmenu \
			jq lightdm lightdm-gtk-greeter lxappearance mpc mpd mpv ncmpcpp network-manager-applet obmenu-generator openbox pasystray picom polkit-gnome rofi \
			rxvt-unicode scrot slock sysstat thunar thunar-archive-plugin thunar-media-tags-plugin thunar-volman tint2 ttf-nerd-fonts-symbols tumbler xbindkeys \
			xcursor-neutral xdg-user-dirs xed xfce4-terminal --needed --noconfirm
			sleep 10
			sudo pacman -U $INSTALL_PATH/openbox/packages/gtk2-2.24.33-5-x86_64.pkg.tar.zst --noconfirm
			sudo pacman -U $INSTALL_PATH/openbox/packages/gtkmm-1_2.24.5-5-x86_64.pkg.tar.zst --noconfirm
			sudo pacman -U $INSTALL_PATH/openbox/packages/nitrogen-1.6.1-6-x86_64.pkg.tar.zst --noconfirm
			sudo pacman -Rdd picom --noconfirm;
			sudo pacman -Sdd cachyos-openbox-settings --noconfirm --needed;
			rsync -a /etc/skel/ ~/
			xdg-user-dirs-update
			cp -r $INSTALL_PATH/music/* ~/Music/
			
	        ;;
	    *)
	        echo " Invalid selection."
	        exit 1
	        ;;
	esac
	
	sudo systemctl enable lightdm
    clear
    echo ""
    echo " Openbox installed. Please reboot and select Openbox Session from the login screen to start using it."
    sleep 10
    exit_menu
}

install_qtile () {
	remove_current_desktop
	sleep 10
	sudo pacman -Syu --noconfirm
	sudo pacman -S qtile cachyos-qtile-settings sddm  --needed --noconfirm
    sleep 10
	rsync -a /etc/skel/.config ~/
	sed -i '/glx-no-stencil/s/^/# /' ~/.config/qtile/scripts/picom.conf
	sudo systemctl enable sddm
    clear
    echo ""
    echo " Qtile installed. Please reboot and select Qtile Session from the login screen to start using it."
    sleep 10
    exit_menu
}

exit_menu () {
echo ""
echo " Script Complete"
echo ""
exit
}

########################################
##### START OF MENU SELECTIONS
########################################

while : # Loop forever
do
clear

GetCurrentEnv="$(get_current_desktop)"

echo ""
echo "The current desktop is" $GetCurrentEnv
echo ""
echo ""
cat << !

 -----------------------------------------------------------
 |              D E S K T O P     M E N U                  |
 -----------------------------------------------------------
 | a) Install Cinnamon  i)                  q)             |
 | b) Install Cosmic    j)                  r)             |
 | c) Install Gnome     k)                  s)             |
 | d) Install i3        l)                  t)             |
 | e) Install KDE       m)                  u)             |
 | f) Install Niri      n)                  v)             |
 | g) Install Openbox   o)                  w)             |
 | h) Install Qtile     p)                  x) exit menu   |
 -----------------------------------------------------------

!

echo -n "  Your choice? : "
read choice

case $choice in
a) install_cinnamon ;;
b) install_cosmic ;;
c) install_gnome ;;
d) install_i3 ;;
e) install_kde ;;
f) install_niri ;;
g) install_openbox ;;
h) install_qtile ;;
i) function_i ;;
j) function_j ;;
k) function_k ;;
l) function_l ;;
m) function_m ;;
n) function_n ;;
o) function_o ;;
p) function_p ;;
q) function_q ;;
r) function_r ;;
s) function_s ;;
t) function_t ;;
u) function_u ;;
v) function_v ;;
w) function_w ;;
x) exit_menu ;;

*) echo "\"$choice\" is not valid "; sleep 2 ;;
esac

done
