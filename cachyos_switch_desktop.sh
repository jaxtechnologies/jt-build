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
		*bspwm*)
			echo "bspwm"
			;;
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
		bspwm)
			clear
			remove_bspwm
			;;
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

remove_bspwm () {
	##### cachyos-bspwm-settings don't exist
	sudo pacman -R --noconfirm cachyos-bspwm-settings
}

remove_cinnamon () {
	##### cachyos-cinnamon-settings don't exist
	sudo pacman -R --noconfirm cachyos-cinnamon-settings
}

remove_cosmic () {
	##### cachyos-cosmic-settings don't exist
	sudo pacman -R --noconfirm cachyos-cosmic-settings
}

remove_gnome () {
	##### cachyos-gnome-settings don't exist
	sudo pacman -R --noconfirm cachyos-gnome-settings
}

remove_i3 () {
	sudo pacman -R --noconfirm cachyos-i3wm-settings
}

remove_kde () {
	sudo pacman -R --noconfirm cachyos-kde-settings
}

remove_niri () {
	sudo pacman -R --noconfirm cachyos-niri-settings
}

remove_openbox () {
	sudo pacman -R --noconfirm cachyos-openbox-settings
}

remove_qtile () {
	sudo pacman -R --noconfirm cachyos-qtile-settings
}

########################################
##### INSTALL NEW DESKTOP ENVIRONMENT
########################################

install_bspwm () {
	remove_current_desktop
	sleep 10
	sudo cp -r $INSTALL_PATH/fonts/jaxtech /usr/share/fonts/
	sudo cp $INSTALL_PATH/scripts/* /usr/local/bin/
	[ ! -d ~/.config/bspwm/ ] && mkdir -p ~/.config/bspwm/
	[ ! -d ~/.config/sxhkd/ ] && mkdir -p ~/.config/sxhkd/
	[ ! -d ~/.config/mpd ] && mkdir -p ~/.config/mpd/
    [ ! -d ~/.config/ncmpcpp ] && mkdir -p ~/.config/ncmpcpp/
	[ ! -d ~/.config/polybar/ ] && mkdir -p ~/.config/polybar/
	[ ! -d ~/.config/rofi ] && mkdir -p ~/.config/rofi/
	[ ! -d ~/Music ] && mkdir -p ~/Music/
	sudo pacman -Syu --noconfirm
	sudo pacman -S --needed --noconfirm bspwm dmenu feh mpc mpd ncmpcpp picom polybar sddm sxhkd thunar thunar-archive-plugin thunar-media-tags-plugin thunar-volman xorg-xinit
    sleep 10
	rsync -a /etc/skel/.config ~/
	cp $INSTALL_PATH/bspwm/backgrounds/wallpaper.jpg ~/
	cp $INSTALL_PATH/bspwm/.config/bspwm/* ~/.config/bspwm/
	cp $INSTALL_PATH/bspwm/.config/sxhkd/* ~/.config/sxhkd/
	cp $INSTALL_PATH/bspwm/.config/mpd/* ~/.config/mpd/
    cp $INSTALL_PATH/bspwm/.config/ncmpcpp/* ~/.config/ncmpcpp/
    cp $INSTALL_PATH/bspwm/.config/polybar/* ~/.config/polybar/
	cp -r $INSTALL_PATH/rofi/* ~/.config/rofi/
	cp $INSTALL_PATH/bspwm/.xprofile ~/
	cp -r $INSTALL_PATH/music/* ~/Music/
	touch ~/.config/mpd/mpd.db
    touch ~/.config/mpd/mpd.log
    touch ~/.config/mpd/mpd.pid
	sudo systemctl enable sddm
	systemctl --user enable mpd.service
    clear
    echo ""
    echo " bspwm installed. Please reboot and select bspwm Session from the login screen to start using it."
    sleep 10
    exit_menu
}

install_cinnamon () {
	remove_current_desktop
	sleep 10
	sudo pacman -Syu --noconfirm
	sudo pacman -S --needed --noconfirm cinnamon gnome-terminal nemo-fileroller sddm
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
	sudo pacman -S --needed --noconfirm cosmic-session cosmic-text-editor cosmic-terminal cosmic-store sddm
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
	sudo pacman -S --needed --noconfirm gnome cachyos-gnome-settings sddm
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
	sudo pacman -S --needed --noconfirm i3-wm i3status cachyos-i3wm-settings sddm
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
	sudo pacman -S --needed --noconfirm plasma-desktop discover dolphin konsole flatpak cachyos-kde-settings sddm
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
	sudo pacman -S --needed --noconfirm niri xwayland-satellite cachyos-niri-noctalia sddm
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
	echo " Select OpenBox installation type:"
	echo " 1) OpenBox Simple Menu Setup"
	echo " 2) OpenBox CachyOS Style Setup"
	echo ""

	read -rp " Enter choice [1-2]: " choice
	
	case "$choice" in
	    1)
			clear
			echo ""
	        echo " Starting OpenBox Simple Menu Setup..."
			sleep 5
	
	        # Simple Menu Setup commands
	        sudo pacman -S --needed --noconfirm feh jgmenu lightdm lightdm-gtk-greeter obmenu-generator openbox polkit-gnome thunar thunar-archive-plugin thunar-media-tags-plugin \
			thunar-volman tint2 xcompmgr xfce4-terminal xorg-xrandr xscreensaver xterm yad
			sleep 10
			rsync -a /etc/skel/.config ~/
			sudo cp $INSTALL_PATH/openbox/backgrounds/wallpaper.jpg /usr/share/backgrounds/wallpaper.jpg
			cp $INSTALL_PATH/openbox/.config/openbox/* ~/.config/openbox/
			cp $INSTALL_PATH/openbox/.config/tint2/* ~/.config/tint2/
			obmenu-generator -p
			paru -S --noconfirm gmrun
	
	        ;;
	    2)
			clear
			echo ""
	        echo " Starting OpenBox CachyOS Style Setup..."
			sleep 5
	
	        # OpenBox Style Setup commands
	        sudo pacman -S --needed --noconfirm obconf-qt libwnck3 acpi arandr archlinux-xdg-menu dex dmenu dunst feh gvfs gvfs-afc gvfs-gphoto2 gvfs-mtp gvfs-nfs gvfs-smb jgmenu \
			jq lightdm lightdm-gtk-greeter lxappearance mpc mpd mpv ncmpcpp network-manager-applet obmenu-generator openbox pasystray picom polkit-gnome rofi \
			rxvt-unicode scrot slock sysstat thunar thunar-archive-plugin thunar-media-tags-plugin thunar-volman tint2 ttf-nerd-fonts-symbols tumbler xbindkeys \
			xcursor-neutral xdg-user-dirs xdotool xed xfce4-terminal xscreensaver
			sleep 10
			sudo pacman -U --noconfirm $INSTALL_PATH/openbox/packages/gtk2-2.24.33-5-x86_64.pkg.tar.zst
			sudo pacman -U --noconfirm $INSTALL_PATH/openbox/packages/gtkmm-1_2.24.5-5-x86_64.pkg.tar.zst
			sudo pacman -U --noconfirm $INSTALL_PATH/openbox/packages/nitrogen-1.6.1-6-x86_64.pkg.tar.zst
			sudo pacman -Rdd --noconfirm picom;
			sudo pacman -Sdd --needed --noconfirm cachyos-openbox-settings;
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
	sudo pacman -S --needed --noconfirm qtile cachyos-qtile-settings sddm
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
 | a) Install bspwm     i) Install Qtile    q)             |
 | b) Install Cinnamon  j)                  r)             |
 | c) Install Cosmic    k)                  s)             |
 | d) Install Gnome     l)                  t)             |
 | e) Install i3        m)                  u)             |
 | f) Install KDE       n)                  v)             |
 | g) Install Niri      o)                  w)             |
 | h) Install Openbox   p)                  x) exit menu   |
 -----------------------------------------------------------

!

echo -n "  Your choice? : "
read choice

case $choice in
a) install_bspwm ;;
b) install_cinnamon ;;
c) install_cosmic ;;
d) install_gnome ;;
e) install_i3 ;;
f) install_kde ;;
g) install_niri ;;
h) install_openbox ;;
i) install_qtile ;;
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
