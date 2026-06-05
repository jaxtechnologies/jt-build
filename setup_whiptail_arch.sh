#!/bin/bash
# NAME: JTOS
# DESC: An installation and deployment script for JaxTech's Debian desktop.
# Adapted from Derek Taylor's (DistroTube) DTOS script...
# Top logo inspiration came from Chris Titus's ArchTitus script...
# Whiptail wiki: https://en.wikibooks.org/wiki/Bash_Shell_Scripting/Whiptail
# Removed < | tee -a $LOG > from all the "sudo nala install" lines as it caused terminal formatting issues


################################################################################
#################################### To Do #####################################
################################################################################

########## AUR HELPER APPS
#teamviewer
#powershell (install issues)


########## Flatpak Apps Working
#"barrier"
#"frozen bubble"
#"gtkhash"
#"neverball"
#"openarena"
#"openshot video editor"
#"portfolio performance"
#"sublime text"
#"warble"


########## Not working yet or need to find alternative
#autokey-gtk
#edex-ui
#google-chrome-stable
#insync
#moneydance (script works)
#nitrogen
#synergy
#virtualbox (Is installed but not sure if other packages needed)
#whiptail (seems to be working but not sure how to report)
#xrdp



INSTALL_PATH=$(pwd)
LOG=$INSTALL_PATH/jaxtech_arch_setup.log
rm $LOG > /dev/null 2>&1

clear

echo -ne "
   ████████╗  █████╗  ██╗   ██╗  ████████╗ ███████╗  ██████╗ ██╗  ██╗
   ╚══██╔══╝ ██╔══██╗  ██╗ ██╔╝  ╚══██╔══╝ ██╔════╝ ██╔════╝ ██║  ██║
      ██║    ███████║   ████╔╝      ██║    ███████╗ ██║      ███████║
   ██ ██║    ██╔══██║  ██╔╝██╗      ██║    ██╔════╝ ██║      ██╔══██║
   ╚███╔╝    ██║  ██║ ██╔╝  ██╗     ██║    ███████╗ ╚██████╗ ██║  ██║
    ╚══╝     ╚═╝  ╚═╝ ╚═╝   ╚═╝     ╚═╝    ╚══════╝  ╚═════╝ ╚═╝  ╚═╝
"
echo ""
echo " Jax|Tech Arch Setup Script will launch in 5 seconds..."

sleep 5

clear

############################################################################################
#################################### UPDATE BASE SYSTEM ####################################
############################################################################################
update_base_system() {
    clear
    echo "" 2>&1 | tee -a $LOG
    echo "Updating Current Packages and Source Lists...  Please be patient..." 2>&1 | tee -a $LOG
    echo ""
    echo Please enter sudo password to Update Current Packages...
    sleep 2

    sudo pacman -Syu 2>&1 | tee -a $LOG

    if ! command -v whiptail &> /dev/null; then
        echo "Installing whiptail for menu interface..."
        sudo pacman -S --noconfirm whiptail -y 2>&1 | tee -a $LOG
    fi
    sleep 5
}


##################################################################################################
#################################### INSTALL BASE APPS ###########################################
##################################################################################################
install_base_apps() {
   clear
    sudo pacman -S --noconfirm install alacritty curl dos2unix eza fish gxmessage neovim openssh powerline-fonts sxhkd vim xdotool 2>&1

#    [ ! -d ~/.config/alacritty ] && mkdir -p ~/.config/alacritty 2>&1 | tee -a $LOG
#    [ ! -d ~/.config/sxhkd ] && mkdir -p ~/.config/sxhkd 2>&1 | tee -a $LOG
#    cp $INSTALL_PATH/configs/alacritty/alacritty.yml ~/.config/alacritty/ 2>&1 | tee -a $LOG
#    cp $INSTALL_PATH/configs/.bashrc_lmde7 ~/.bashrc 2>&1 | tee -a $LOG
#    cp $INSTALL_PATH/configs/.vimrc ~/ 2>&1 | tee -a $LOG
#    cp $INSTALL_PATH/configs/keybindings ~/keybindings 2>&1 | tee -a $LOG
#    cp $INSTALL_PATH/configs/sxhkd/sxhkdrc ~/.config/sxhkd/ 2>&1 | tee -a $LOG
#    cp $INSTALL_PATH/configs/autostart/sxhkd.desktop ~/.config/autostart/ 2>&1 | tee -a $LOG
    sleep 5

    ############### Setup Settings, Taskbar and Background Image
    clear
    echo "" 2>&1 | tee -a $LOG
    echo Setting up Settings, Taskbar and Background...  Please be patient... 2>&1 | tee -a $LOG
    echo "" 2>&1 | tee -a $LOG
    echo "" 2>&1 | tee -a $LOG
    cp $INSTALL_PATH/backgrounds/* ~/Pictures/ 2>&1 | tee -a $LOG
    sleep 10
}


#####################################################################################################
#################################### START OF WHIPTAIL FUNCTIONS ####################################
#####################################################################################################
##### Whiptail Colors: See this thread for more info:
##### https://askubuntu.com/questions/776831/whiptail-change-background-color-dynamically-from-magenta/781062
##### Whiptail Window Sizing
##### Height(rows) Width(columns) Scroll(rows)
##### Height & Width are required - Scroll(rows) is Optional
export NEWT_COLORS="
root=,blue
window=,white
shadow=,black
border=black,white
title=red,white
textbox=black,white
radiolist=black,white
label=black,blue
checkbox=black,white
compactbutton=black,white
button=white,red"

max() {
    echo -e "$1\n$2" | sort -n | tail -1
}

getbiggestword() {
    echo "$@" | sed "s/ /\n/g" | wc -L
}

replicate() {
    local n="$1"
    local x="$2"
    local str

    for _ in $(seq 1 "$n"); do
        str="$str$x"
    done
    echo "$str"
}

programchoices() {
    choices=()
    local maxlen; maxlen="$(getbiggestword "${!checkboxes[@]}")"
    linesize="$(max "$maxlen" 42)"
    local spacer; spacer="$(replicate "$((linesize - maxlen))" " ")"

    for key in "${!checkboxes[@]}"
    do
        # A portable way to check if a command exists in $PATH and is executable.
        # If it doesn't exist, we set the tick box to OFF.
        # If it exists, then we set the tick box to ON.
        if ! command -v "${checkboxes[$key]}" > /dev/null; then
            # $spacer length is defined in the individual window functions based
            # on the needed length to make the checkbox wide enough to fit window.
            choices+=("${key}" "${spacer}" "OFF")
        else
            choices+=("${key}" "${spacer}" "ON")
        fi
    done
}

selectedprograms() {
    result=$(
        # Creates the whiptail checklist. Also, we use a nifty
        # trick to swap stdout and stderr.
		##### Whiptail Windows -- Height(25) Width(15)
        whiptail --title "$title"                               \
                 --checklist "$text" 25 "$((linesize + 16))" 15 \
                 "${choices[@]}"                                \
                 3>&2 2>&1 1>&3
    )
}

exitorinstall() {
    exitstatus=$?
    # Check the exit status, if 0 we will install the selected
    # packages. A command which exits with zero (0) has succeeded.
    # A non-zero (1-255) exit status indicates failure.
    if [ $exitstatus = 0 ]; then
        # Take the results and remove the "'s and add new lines.
        # Otherwise, pacman is not going to like how we feed it.
        programs=$(echo "$result" | sed 's/" /\n/g' | sed 's/"//g' )
        echo $programs
        sudo pacman -S --noconfirm $programs -y || \
        echo "Failed to install required packages."
    else
        echo "User selected Cancel."
    fi
}


#####################################################################################################
#################################### START OF INSTALL CATEGORIES ####################################
#####################################################################################################
browsers() {
    title="Web Browsers"
    text="\nAll programs marked with '*' are already installed.\n\nUnselecting them will NOT uninstall them."
    spacer=$(for i in $(seq 1 38); do echo -n " "; done)

    local -A checkboxes
    checkboxes["brave"]="brave"
    checkboxes["chromium"]="chromium"
    checkboxes["falkon"]="falkon"
    checkboxes["qutebrowser"]="qutebrowser"

    programchoices && selectedprograms && exitorinstall
}

otherinternet() {
    title="Other Internet Programs"
    text="\nAll programs marked with '*' are already installed.\n\nUnselecting them will NOT uninstall them."
    spacer=$(for i in $(seq 1 47); do echo -n " "; done)

    local -A checkboxes
    checkboxes["filezilla"]="filezilla"
    checkboxes["localsend"]="localsend"
    checkboxes["remmina"]="remmina"
    checkboxes["transmission-gtk"]="transmission-qt"

    programchoices && selectedprograms && exitorinstall
}

devops() {
    title="DevOps Programs"
    text="\nAll programs marked with '*' are already installed.\n\nUnselecting them will NOT uninstall them."
    spacer=$(for i in $(seq 1 46); do echo -n " "; done)

    local -A checkboxes
    checkboxes["adb"]="adb"
    checkboxes["android-tools"]="android-tools"
    checkboxes["code"]="code"
    checkboxes["docker"]="docker"
    checkboxes["docker-compose"]="docker-compose"
    checkboxes["python-pip"]="python-pip"
    checkboxes["python-pipvenv"]="python-pipenv"
    checkboxes["sqlitebrowser"]="sqlitebrowser"
    checkboxes["tk"]="tk"

    programchoices && selectedprograms && exitorinstall
}

graphics() {
    title="Graphics Programs"
    text="\nAll programs marked with '*' are already installed.\n\nUnselecting them will NOT uninstall them."
    spacer=$(for i in $(seq 1 53); do echo -n " "; done)

    local -A checkboxes
    checkboxes["digikam"]="digikam"
    checkboxes["gimp"]="gimp"
    checkboxes["inkscape"]="inkscape"
    checkboxes["krita"]="krita"
    checkboxes["ksnip"]="ksnip"

    programchoices && selectedprograms && exitorinstall
}

multimedia() {
    title="Multimedia Programs"
    text="\nAll programs marked with '*' are already installed.\n\nUnselecting them will NOT uninstall them."
    spacer=$(for i in $(seq 1 53); do echo -n " "; done)

    local -A checkboxes
    checkboxes["guvcview"]="guvcview"
    checkboxes["handbrake"]="handbrake"
    checkboxes["kdenlive"]="kdenlive"
    checkboxes["obs-studio"]="obs-studio"
    checkboxes["rhythmbox"]="rhythmbox"
    checkboxes["vlc"]="vlc"

    programchoices && selectedprograms && exitorinstall
}

office() {
    title="Office Programs"
    text="\nAll programs marked with '*' are already installed.\n\nUnselecting them will NOT uninstall them."
    spacer=$(for i in $(seq 1 46); do echo -n " "; done)

    local -A checkboxes
    checkboxes["okular"]="okular"
    checkboxes["pdfarranger"]="pdfarranger"
    checkboxes["pdfgrep"]="pdfgrep"
    checkboxes["scribus"]="scribus"

    programchoices && selectedprograms && exitorinstall
}

utilities() {
    title="Utility Programs"
    text="\nAll programs marked with '*' are already installed.\n\nUnselecting them will NOT uninstall them."
    spacer=$(for i in $(seq 1 46); do echo -n " "; done)

    local -A checkboxes
    checkboxes["brasero"]="brasero"
    checkboxes["btop"]="btop"
    checkboxes["cherrytree"]="cherrytree"
    checkboxes["cmatrix"]="cmatrix"
    checkboxes["conky"]="conky"
    checkboxes["conky-manager"]="conky-manager"
    checkboxes["etcher-bin"]="etcher-bin"
    checkboxes["fastfetch"]="fastfetch"
    checkboxes["font-manager"]="font-manager"
    checkboxes["htop"]="htop"
    checkboxes["keepass2"]="keepass"
    checkboxes["kleopatra"]="kleopatra"
    checkboxes["meld"]="meld"
    checkboxes["neofetch"]="neofetch"
    checkboxes["tldr"]="tldr"
    checkboxes["zenmap"]="zenmap"

    programchoices && selectedprograms && exitorinstall
}

games() {
    title="Games"
    text="\nAll programs marked with '*' are already installed.\n\nUnselecting them will NOT uninstall them."
    spacer=$(for i in $(seq 1 51); do echo -n " "; done)

    local -A checkboxes
    checkboxes["0ad"]="0ad"
    checkboxes["kbounce"]="kbounce"
    checkboxes["pingus"]="pingus"
    checkboxes["steam"]="steam"
    checkboxes["supertuxkart"]="supertuxkart"
    checkboxes["wesnoth"]="wesnoth"

    programchoices && selectedprograms && exitorinstall
}

educational() {
    title="Educational"
    text="\nAll programs marked with '*' are already installed.\n\nUnselecting them will NOT uninstall them."
    spacer=$(for i in $(seq 1 51); do echo -n " "; done)

    local -A checkboxes
    checkboxes["bibletime"]="bibletime"
    checkboxes["xiphos"]="xiphos"

    programchoices && selectedprograms && exitorinstall
}



########################################################################################################
#################################### START OF OPTIONAL APPLICATIONS ####################################
########################################################################################################
opt_polybar() {
    ############### Install Polybar and Apps
    sudo nala install polybar mpd mpc ncmpcpp rofi -y 2>&1
    sudo cp -r $INSTALL_PATH/fonts/jaxtech /usr/share/fonts/ 2>&1 | tee -a $LOG
    sudo cp $INSTALL_PATH/scripts/* /usr/local/bin/ 2>&1 | tee -a $LOG
    [ ! -d ~/.config/mpd ] && mkdir -p ~/.config/mpd 2>&1 | tee -a $LOG
    [ ! -d ~/.config/ncmpcpp ] && mkdir -p ~/.config/ncmpcpp 2>&1 | tee -a $LOG
    [ ! -d ~/.config/polybar ] && mkdir -p ~/.config/polybar 2>&1 | tee -a $LOG
    [ ! -d ~/.config/rofi ] && mkdir -p ~/.config/rofi 2>&1 | tee -a $LOG
    cp $INSTALL_PATH/configs/autostart/mpd.desktop ~/.config/autostart/ 2>&1 | tee -a $LOG
    cp $INSTALL_PATH/configs/autostart/polybar.desktop ~/.config/autostart/ 2>&1 | tee -a $LOG
    cp $INSTALL_PATH/configs/mpd/* ~/.config/mpd/ 2>&1 | tee -a $LOG
    cp $INSTALL_PATH/configs/ncmpcpp/* ~/.config/ncmpcpp/ 2>&1 | tee -a $LOG
    cp $INSTALL_PATH/configs/polybar/* ~/.config/polybar/ 2>&1 | tee -a $LOG
    cp -r $INSTALL_PATH/configs/rofi/* ~/.config/rofi/ 2>&1 | tee -a $LOG
    cp -r $INSTALL_PATH/music/* ~/Music/ 2>&1 | tee -a $LOG
    touch ~/.config/mpd/mpd.db 2>&1 | tee -a $LOG
    touch ~/.config/mpd/mpd.log 2>&1 | tee -a $LOG
    touch ~/.config/mpd/mpd.pid 2>&1 | tee -a $LOG
    systemctl --user enable mpd.service
    sleep 5
}

opt_xmonad() {
	############### Install Xmonad (Tiling Window Manager)
    ##### Install Packages
    ##### alacritty - terminal 
    ##### xwallpaper - background set app
    ##### nitrogen - background chooser
    ##### picom -transparency compositor
    sudo nala install xmonad xmobar alacritty xwallpaper nitrogen picom -y 2>&1
    [ ! -d ~/.config/xmobar ] && mkdir -p ~/.config/xmobar
    [ ! -d ~/.config/xmonad ] && mkdir -p ~/.config/xmonad
    cp $INSTALL_PATH/configs/xmonad/xmobarrc ~/.config/xmobar/
    cp $INSTALL_PATH/configs/xmonad/haskell_20.xpm ~/.config/xmonad/
    cp $INSTALL_PATH/configs/xmonad/xmonad.hs ~/.config/xmonad/
    cp $INSTALL_PATH/configs/xmonad/xmonad_bg ~/.config/xmonad/.xmonad_bg
    sudo cp $INSTALL_PATH/backgrounds/xmonad.png /usr/share/backgrounds/
    sleep 2
}

opt_grub() {
	############### Configure Grub For Single Boot / Dual Boot
    clear
    echo ""
    PS3="Select the current OS: "

    clear
    echo "" 2>&1 | tee -a $LOG
    echo "" 2>&1 | tee -a $LOG
    echo "Select the current OS to modify Grub..." 2>&1 | tee -a $LOG
    echo "" 2>&1 | tee -a $LOG

    select opt in LMDE MINT QUIT; do

      case $opt in
        LMDE)
          echo "" 2>&1 | tee -a $LOG
          echo  Modifying Grub Menu to not display...  Please be patient... 2>&1 | tee -a $LOG
          echo "" 2>&1 | tee -a $LOG
          echo "" 2>&1 | tee -a $LOG
          sudo sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/g' /etc/default/grub 2>&1 | tee -a $LOG
          sudo update-grub 2>&1 | tee -a $LOG
          sleep 2
          break
          ;;
        MINT)
          echo "" 2>&1 | tee -a $LOG
          echo " NOTICE: MINT is set to 0 Timeout by Default...  No changes necessary..." 2>&1 | tee -a $LOG
          sleep 3
          break
          ;;
        QUIT)
          break
          ;;
        *)
          echo "Invalid option $REPLY" 2>&1 | tee -a $LOG
          ;;
      esac
    done
    sleep 5
}


##################################################################################################################
#################################### START OF BROTHER MFC-7860DW INSTALLATION ####################################
##################################################################################################################
brother_mfc_7860dw() {
    ##### Install Brother MFC-7860DW Printer
    clear
    echo "" 2>&1 | tee -a $LOG
    echo "" 2>&1 | tee -a $LOG
    echo "Answer Yes to specify the DeviceURI..." 2>&1 | tee -a $LOG
    echo "" 2>&1 | tee -a $LOG
    echo "Choose (I) Specify IP Address during setup..." 2>&1 | tee -a $LOG
    echo "" 2>&1 | tee -a $LOG
    sleep 3
    cd packages/
    sudo bash linux-brprinter-installer-2.2.6-0 MFC-7860DW 2>&1
    cd ..
    sleep 3

}


###############################################################################################
#################################### MENU OPTIONAL APPS #######################################
###############################################################################################
menu_optional_apps() {
    # Define available applications with descriptions
    local functions=(
        "opt_conky" "Install Conky" "OFF"
        "opt_grub" "Configure Grub" "OFF"
        "opt_polybar" "Install Polybar" "OFF"
        "opt_xmonad" "Install XMonad" "OFF"
    )
    
    # Show checkbox menu using whiptail
    ##### Whiptail Windows -- Height(30) Width(67) Scroll(20)
    local selected_temp_optional=$(whiptail --title "Jax|Tech Optional Apps Setup" \
        --checklist "\n Select Apps to Install, ENTER to confirm:" \
        30 67 20 \
        "${functions[@]}" \
        3>&1 1>&2 2>&3)
    
    # Check if user cancelled
    if [ $? -ne 0 ]; then
        echo "Installation cancelled by user."
        exit 1
    fi
    
    # Remove quotes from selection and make it global
    SELECTED_OPTIONAL=$(echo $selected_temp_optional | tr -d '"')
    
    echo "Selected apps: $SELECTED_OPTIONAL" 2>&1 | tee -a $LOG
    echo "" 2>&1 | tee -a $LOG
}


################################################################################################
#################################### INSTALL OPTIONAL APPS #####################################
################################################################################################
install_optional_apps() {
    for func in $SELECTED_OPTIONAL; do
        echo "" 2>&1 | tee -a $LOG
        echo "===========================================" 2>&1 | tee -a $LOG
        echo "Installing App: $func" 2>&1 | tee -a $LOG
        echo "===========================================" 2>&1 | tee -a $LOG
        
        if declare -f "$func" > /dev/null; then
            $func
        else
            echo "Error: Function $func not found!" 2>&1 | tee -a $LOG
        fi
    done
    
}


###############################################################################################
#################################### PROCESS OPTIONAL APPS ####################################
###############################################################################################
process_optional_apps() {
	if whiptail --title "Install Optional Apps?" --yesno "Do you want to install Optional Apps?\n\nChoosing Yes will run the Optional Apps flow.\n\nChoose No to skip and continue setup." 12 70; then
	    echo "User chose to proceed with Optional Apps installation." 2>&1 | tee -a $LOG
        menu_optional_apps
        install_optional_apps
	else
	    echo "User chose to skip Optional Apps installation." 2>&1 | tee -a $LOG
	fi

}


#############################################################################################################
#################################### PROCESS PRINTER DRIVERS MFC-7860DW #####################################
#############################################################################################################
process_mfc7860dw_drivers() {
	if whiptail --title "Install Brother MFC-7860DW Drivers?" --yesno "\nDo you want to install Brother MFC-7860DW Drivers?\n" 12 70; then
	    echo "User chose to proceed with Brother MFC-7860DW Drivers installation." 2>&1 | tee -a $LOG
	    brother_mfc_7860dw
	else
	    echo "User chose to skip Brother MFC-7860DW Drivers installation." 2>&1 | tee -a $LOG
	fi

}


#######################################################################################################
#################################### START OF INSTALL FUNCTIONS #######################################
#######################################################################################################
update_base_system
install_base_apps
#####################
browsers
otherinternet
devops
graphics
multimedia
office
utilities
games
educational
#####################
process_optional_apps
process_mfc7860dw_drivers


#####################################################################################
#################################### LOG NOTICE #####################################
#####################################################################################
clear
echo "" 2>&1 | tee -a $LOG
echo "" 2>&1 | tee -a $LOG
echo "  Log file available at: $LOG"
echo " ====================================================================================" 2>&1 | tee -a $LOG
echo "  NOTICE -- When Searching Logs, the following keywords are useful (unmet and notice)" 2>&1 | tee -a $LOG
echo " ====================================================================================" 2>&1 | tee -a $LOG
echo "" 2>&1 | tee -a $LOG
sleep 10


#########################################################################################
#################################### SETUP COMPLETE #####################################
#########################################################################################
clear
echo ""
echo ""
echo " =========================================================================="
echo "  NOTICE -- To Install Extra Apps, run the 7a_setup_extras_lmde7 script... "
echo " =========================================================================="
echo ""
echo ""
echo ""
read -p "Setup is Complete - Reboot the Machine NOW (y/n)? "
if [ "$REPLY" = "y" ]; then

  echo "" 2>&1 | tee -a $LOG
  echo Rebooting Now... 2>&1 | tee -a $LOG
  sudo reboot 2>&1 | tee -a $LOG
  sleep 2
  
else
	exit
fi

exit
