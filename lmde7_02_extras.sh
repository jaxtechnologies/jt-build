#!/bin/bash
# NAME: Jax|Tech LMDE Extra Apps Setup Script
# DESC: An installation and deployment script for Jax|Tech's LMDE Debian desktop.
# Adapted from Derek Taylor's (DistroTube) DTOS script...
# Top logo inspiration came from Chris Titus's ArchTitus script...
# Whiptail wiki: https://en.wikibooks.org/wiki/Bash_Shell_Scripting/Whiptail

INSTALL_PATH=$(pwd)
LOG=$INSTALL_PATH/jaxtech_extras_setup.log
rm $LOG > /dev/null 2>&1
DEFAULT_USER="jt"
CURRENT_USER=$(whoami)

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
echo " Jax|Tech LMDE Extra Apps Setup Script will launch in 5 seconds..."

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

    sudo apt-get update 2>&1 | tee -a $LOG

    if ! command -v nala &> /dev/null; then
        echo "Installing nala for package management..."
        sudo apt-get install nala -y 2>&1 | tee -a $LOG
    fi

    #sudo nala fetch 2>&1
    sudo nala update 2>&1
    sudo nala upgrade -y 2>&1
    sleep 5
}


#######################################################################################################
#################################### START OF FLATPAK APPLICATIONS ####################################
#######################################################################################################
flatpak_brave() {
    flatpak install flathub com.brave.Browser -y 2>&1 | tee -a $LOG
    sleep 5
}

flatpak_localsend() {
    flatpak install flathub org.localsend.localsend_app -y 2>&1 | tee -a $LOG
    sleep 5
}

flatpak_port_perf() {
    flatpak install flathub info.portfolio_performance.PortfolioPerformance -y 2>&1 | tee -a $LOG
    sleep 5
}

flatpak_warble() {
    flatpak install flathub com.github.avojak.warble -y 2>&1 | tee -a $LOG
    sleep 5
}


######################################################################################################
#################################### START OF DIRECT APPLICATIONS ####################################
######################################################################################################
direct_chrome() {
    sudo nala install libu2f-udev fonts-liberation -y 2>&1
    wget -P packages/ https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb 2>&1 | tee -a $LOG
    sudo dpkg -i packages/google-chrome-stable_current_amd64.deb 2>&1 | tee -a $LOG
    sleep 5
}


###################################################################################################
#################################### START OF NAS APPLICATIONS ####################################
###################################################################################################
nas_virtualbox() {
    ##### Updates are at https://download.virtualbox.org/virtualbox/
    sudo nala install libqt6help6 libqt6printsupport6 libqt6statemachine6 libqt6xml6 -y 2>&1
    sudo dpkg -i packages/virtualbox-7.2_7.2.4-170995~Debian~trixie_amd64.deb 2>&1 | tee -a $LOG
    sleep 5
}

nas_powershell() {
    ##### Updates are at https://github.com/PowerShell/PowerShell/releases/latest
    cp packages/powershell.png $HOME/.local/share/applications/ 2>&1 | tee -a $LOG
    cp packages/PowerShell.desktop $HOME/Desktop/ 2>&1 | tee -a $LOG
    cp packages/PowerShell.desktop $HOME/.local/share/applications/ 2>&1 | tee -a $LOG
    sudo dpkg -i packages/libicu74_74.2-2_amd64.deb 2>&1 | tee -a $LOG
    sudo dpkg -i packages/powershell_7.5.4-1.deb_amd64.deb 2>&1 | tee -a $LOG

    if grep -q "$DEFAULT_USER" "$HOME/Desktop/PowerShell.desktop"; then
        echo "Found Default User '$DEFAULT_USER' in "$HOME/Desktop/PowerShell.desktop". Swapping with current user '$CURRENT_USER'..."
        sed -i "s|$DEFAULT_USER|$CURRENT_USER|g" "$HOME/Desktop/PowerShell.desktop"
    else
        echo "No match for '$DEFAULT_USER' found in "$HOME/Desktop/PowerShell.desktop". No action needed."
    fi

    if grep -q "$DEFAULT_USER" "$HOME/.local/share/applications/PowerShell.desktop"; then
        echo "Found Default User '$DEFAULT_USER' in "$HOME/.local/share/applications/PowerShell.desktop". Swapping with current user '$CURRENT_USER'..."
        sed -i "s|$DEFAULT_USER|$CURRENT_USER|g" "$HOME/.local/share/applications/PowerShell.desktop"
    else
        echo "No match for '$DEFAULT_USER' found in "$HOME/.local/share/applications/PowerShell.desktop". No action needed."
    fi
    
    sleep 5
}

nas_code() {
    ##### Updates are at https://code.visualstudio.com/Download#
    sudo dpkg -i packages/code_1.106.3-1764110892_amd64.deb 2>&1 | tee -a $LOG
    sleep 5
}

nas_balenaetcher() {
    ##### Updates are at https://github.com/balena-io/etcher/releases/
    unzip packages/balenaEtcher-linux-x64-2.1.4.zip -d $HOME/.local/share/applications/ 2>&1 | tee -a $LOG
    cp packages/balenaEtcher.png $HOME/.local/share/applications/balenaEtcher-linux-x64/ 2>&1 | tee -a $LOG
    cp packages/balenaEtcher.desktop $HOME/Desktop/ 2>&1 | tee -a $LOG
    cp packages/balenaEtcher.desktop $HOME/.local/share/applications/ 2>&1 | tee -a $LOG

    if grep -q "$DEFAULT_USER" "$HOME/Desktop/balenaEtcher.desktop"; then
        echo "Found Default User '$DEFAULT_USER' in "$HOME/Desktop/balenaEtcher.desktop". Swapping with current user '$CURRENT_USER'..."
        sed -i "s|$DEFAULT_USER|$CURRENT_USER|g" "$HOME/Desktop/balenaEtcher.desktop"
    else
        echo "No match for '$DEFAULT_USER' found in "$HOME/Desktop/balenaEtcher.desktop". No action needed."
    fi

    if grep -q "$DEFAULT_USER" "$HOME/.local/share/applications/balenaEtcher.desktop"; then
        echo "Found Default User '$DEFAULT_USER' in "$HOME/.local/share/applications/balenaEtcher.desktop". Swapping with current user '$CURRENT_USER'..."
        sed -i "s|$DEFAULT_USER|$CURRENT_USER|g" "$HOME/.local/share/applications/balenaEtcher.desktop"
    else
        echo "No match for '$DEFAULT_USER' found in "$HOME/.local/share/applications/balenaEtcher.desktop". No action needed."
    fi

    sleep 5
}

nas_moneydance() {
    ##### Updates are at https://infinitekind.com/download-moneydance-personal-finance-software
    sudo dpkg -i packages/moneydance_linux_amd64.deb 2>&1 | tee -a $LOG
    sleep 5
}

nas_insync() {
    sudo dpkg -i packages/insync_3.9.7.60031-trixie_amd64.deb 2>&1 | tee -a $LOG
    sleep 5
}

nas_teamviewer() {
    sudo nala install libminizip1t64 -y 2>&1
    sudo dpkg -i packages/teamviewer_15.72.3_amd64.deb 2>&1 | tee -a $LOG
    sleep 5
}

nas_synergy() {
    sudo nala install qt6-qpa-plugins libqt6widgets6 libei1 libportal1 libqt6network6 libqt6xml6 -y 2>&1
    sudo dpkg -i packages/synergy_1.20.0_debian-13_x86_64.deb 2>&1 | tee -a $LOG
    sleep 5
	
	clear
	host_name=$(hostname)
	
	# Prompt user for server hostname
	read -p "Enter the Synergy server hostname: " server_name

	# Check if server hostname was provided
	if [ -z "$server_name" ]; then
	    echo "Error: Server hostname cannot be empty"
	    exit 1
	fi

	# Add the greeter-setup-script line to lightdm configuration
	echo "Adding synergy client configuration to LightDM..."
	printf '\ngreeter-setup-script=/usr/bin/synergy-client %s\n' "$server_name" | sudo tee -a /etc/lightdm/lightdm.conf.d/70-linuxmint.conf
	
	echo "Configuration added successfully!"
	echo ""

	# Prompt user for Synergy License
	echo "Enter the Synergy License"
	read -s synergy_license

	# Check if synergy license was provided
	if [ -z "$synergy_license" ]; then
	    echo "Error: Synergy License cannot be empty"
	    exit 1
	fi

	# Option: ensure Synergy greeter settings are disabled (with confirmation)
	# Check and set autoHide, minimizeToTray, and preventSleep to false
	config_file="$HOME/.config/Synergy/Synergy.conf"
	echo ""
	echo ""
	echo "Checking Synergy config at: $config_file"
	
	if [ -f "$config_file" ]; then
	    read -r -p "Modify $config_file to set default settings? [Y/n] " response
	else
	    read -r -p "$config_file not found — create it with required settings? [Y/n] " response
	fi

	response=${response:-Y}

	case "$response" in
	    [yY]|[yY][eE][sS])
	        # create a backup before modifying (if file exists)
	        cp "$config_file" "$config_file".bak 2>/dev/null || true
	        if [ -f "$config_file" ]; then
	            for key in autoHide minimizeToTray preventSleep; do
	                if grep -qE "^\s*${key}\s*=" "$config_file"; then
	                    # replace the value with false, preserving leading whitespace
	                    sed -i -E "s|^(\s*${key}\s*=).*|\1false|" "$config_file"
	                else
	                    # append the key with false if missing
	                    echo "${key}=false" >> "$config_file"
	                fi
	            done
	            echo "Updated $config_file (backup at $config_file.bak)"
	        else
	            mkdir -p "$(dirname "$config_file")"
				
				echo "activated=true" >> $config_file
				echo "autoHide=false" >> $config_file
				echo "enableUpdateCheck=true" >> $config_file
				echo "groupClientChecked=true" >> $config_file
				echo "minimizeToTray=false" >> $config_file
				echo "preventSleep=false" >> $config_file
				echo "screenName=$host_name" >> $config_file
				echo "serialKey=$synergy_license" >> $config_file
				echo "serverHostname=$server_name" >> $config_file
				echo "startedBefore=true" >> $config_file
				
	            echo "Created $config_file"
	        fi
	        ;;
	    *)
	        echo "Skipped modifying $config_file"
	        ;;
	esac
}


########################################################################################################
#################################### START OF APPIMAGE APPLICATIONS ####################################
########################################################################################################
nas_edex-ui() {
    [ ! -d ~/.local/share/applications/ ] && mkdir -p ~/.local/share/applications 2>&1 | tee -a $LOG
    cp packages/edex-ui.png $HOME/.local/share/applications/ 2>&1 | tee -a $LOG
    cp packages/eDEX-UI.desktop $HOME/Desktop/ 2>&1 | tee -a $LOG
    cp packages/eDEX-UI.desktop $HOME/.local/share/applications/ 2>&1 | tee -a $LOG
    cp packages/eDEX-UI-Linux-x86_64.AppImage $HOME/.local/share/applications/ 2>&1 | tee -a $LOG
    chmod +x $HOME/.local/share/applications/eDEX-UI-Linux-x86_64.AppImage 2>&1 | tee -a $LOG

    if grep -q "$DEFAULT_USER" "$HOME/Desktop/eDEX-UI.desktop"; then
        echo "Found Default User '$DEFAULT_USER' in "$HOME/Desktop/eDEX-UI.desktop". Swapping with current user '$CURRENT_USER'..."
        sed -i "s|$DEFAULT_USER|$CURRENT_USER|g" "$HOME/Desktop/eDEX-UI.desktop"
    else
        echo "No match for '$DEFAULT_USER' found in "$HOME/Desktop/eDEX-UI.desktop". No action needed."
    fi

    if grep -q "$DEFAULT_USER" "$HOME/.local/share/applications/eDEX-UI.desktop"; then
        echo "Found Default User '$DEFAULT_USER' in "$HOME/.local/share/applications/eDEX-UI.desktop". Swapping with current user '$CURRENT_USER'..."
        sed -i "s|$DEFAULT_USER|$CURRENT_USER|g" "$HOME/.local/share/applications/eDEX-UI.desktop"
    else
        echo "No match for '$DEFAULT_USER' found in "$HOME/.local/share/applications/eDEX-UI.desktop". No action needed."
    fi

    sleep 5
}


############################################################################################
#################################### MENU EXTRA APPS #######################################
############################################################################################
menu_extra_apps() {
    # Define available applications with descriptions
    local functions=(
        "flatpak_brave" "Install Brave Browser" "OFF"
        "flatpak_localsend" "Install LocalSend" "OFF"
        "flatpak_port_perf" "Install Portfolio Performance" "OFF"
        "flatpak_warble" "Install Warble" "OFF"
		"direct_chrome" "Install Chrome Browser" "OFF"
    )
    
    # Show checkbox menu using whiptail
    ##### Whiptail Windows -- Height(30) Width(67) Scroll(20)
    local selected_temp_extra=$(whiptail --title "Jax|Tech Extra Apps Setup" \
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
    SELECTED_EXTRA=$(echo $selected_temp_extra | tr -d '"')
    
    echo "Selected apps: $SELECTED_EXTRA" 2>&1 | tee -a $LOG
    echo "" 2>&1 | tee -a $LOG
}


#############################################################################################
#################################### INSTALL EXTRA APPS #####################################
#############################################################################################
install_extra_apps() {
    for func in $SELECTED_EXTRA; do
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


############################################################################################
#################################### PROCESS EXTRA APPS ####################################
############################################################################################
process_extra_apps() {
	if whiptail --title "Install Extra Apps?" --yesno "Do you want to install Extra Apps?\n\nChoosing Yes will run the Extra Apps flow.\n\nChoose No to skip and continue setup." 12 70; then
	    echo "User chose to proceed with Extra Apps installation." 2>&1 | tee -a $LOG
        menu_extra_apps
        install_extra_apps
	else
	    echo "User chose to skip Extra Apps installation." 2>&1 | tee -a $LOG
	fi

}


#############################################################################################
#################################### NAS CONNECTION MENU ####################################
#############################################################################################
nas_connect() {
        # Collect NAS Username
        NAS_USER=$(whiptail --title "NAS Connection - Step 1/4" \
            --inputbox "\n Enter NAS Username:" 9 50 \
            3>&1 1>&2 2>&3)
        
        if [ $? -ne 0 ]; then
            echo "User canceled."
            exit 0
        fi
        
        # Collect NAS IP Address
        NAS_IP=$(whiptail --title "NAS Connection - Step 2/4" \
            --inputbox "\n Enter NAS IP Address:" 9 50 \
            3>&1 1>&2 2>&3)
        
        if [ $? -ne 0 ]; then
            echo "User canceled."
            exit 0
        fi
        
        # Collect NAS Share Path
        NAS_SHARE=$(whiptail --title "NAS Connection - Step 3/4" \
            --inputbox "\n Enter NAS Share Path:" 9 50 \
            3>&1 1>&2 2>&3)
        
        if [ $? -ne 0 ]; then
            echo "User canceled."
            exit 0
        fi
                
        ##### Confirm NAS Settings
        if whiptail --title "Confirm NAS Connection Settings" --yesno "Are these settings correct?\n\n NAS User: $NAS_USER\n NAS IP: $NAS_IP\n NAS Share: $NAS_SHARE\n\nProceed with connection?" 14 50; then
            clear
            echo ""
            echo ""
            echo " Enter NAS Password to download NAS Build Packages..."
            echo ""
            cd $INSTALL_PATH/packages/
            bash -c "smbclient '//$NAS_IP/$NAS_SHARE' -U $NAS_USER -c 'prompt OFF;recurse ON;cd 'build_mint/packages/debian13trixie/';mget *'"
            sleep 10
        else
            echo "User canceled"
            exit 0
        fi

cd ..

}


##########################################################################################
#################################### MENU NAS APPS #######################################
##########################################################################################
menu_nas_apps() {
    # Define available applications with descriptions
    local functions=(
        "nas_balenaetcher" "Install BalenaEtcher" "OFF"
        "nas_code" "Install VS Code" "OFF"
        "nas_edex-ui" "Install eDEX-UI" "OFF"
        "nas_insync" "Install Insync" "OFF"
        "nas_moneydance" "Install MoneyDance" "OFF"
        "nas_powershell" "Install PowerShell" "OFF"
        "nas_synergy" "Install Synergy" "OFF"
        "nas_teamviewer" "Install TeamViewer" "OFF"
        "nas_virtualbox" "Install VirtualBox" "OFF"
    )
    
    # Show checkbox menu using whiptail
    ##### Whiptail Windows -- Height(30) Width(67) Scroll(20)
    local selected_temp_nas=$(whiptail --title "Jax|Tech NAS Apps Setup" \
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
    SELECTED_NAS=$(echo $selected_temp_nas | tr -d '"')
    
    echo "Selected apps: $SELECTED_NAS" 2>&1 | tee -a $LOG
    echo "" 2>&1 | tee -a $LOG
}


###########################################################################################
#################################### INSTALL NAS APPS #####################################
###########################################################################################
install_nas_apps() {
    for func in $SELECTED_NAS; do
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


##########################################################################################
#################################### PROCESS NAS APPS ####################################
##########################################################################################
process_nas_apps() {
	# Ask the user whether to proceed with the NAS connection and Extra Apps steps.
	# If the user answers Yes, run nas_connect, menu_nas_apps and install_nas_apps.
	# If No (or cancel), skip those three steps and continue with the rest of the script.
	if whiptail --title "Install NAS Apps?" --yesno "Do you want to install NAS Apps?\n\nChoosing Yes will run the NAS Connection flow.\n\nChoose No to skip and continue setup." 12 70; then
	    echo "User chose to proceed with NAS Apps installation." 2>&1 | tee -a $LOG
	    nas_connect
	    menu_nas_apps
	    install_nas_apps
	else
	    echo "User chose to skip NAS Apps installation." 2>&1 | tee -a $LOG
	fi

}


#######################################################################################################
#################################### START OF INSTALL FUNCTIONS #######################################
#######################################################################################################
update_base_system
#####################
process_extra_apps
process_nas_apps


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

if [ -f "~/.config/Synergy/Synergy.conf" ]; then
  echo ""
  echo " Synergy was not installed..."
  echo ""
  echo ""
else
  echo ""
  echo " Make sure to run Synergy before reboot to complete the config and connect to Synergy Server"
  echo ""
  echo ""
fi

echo ""
read -p "Setup is Complete - Reboot the Machine NOW (y/n)? "
if [ "$REPLY" = "y" ]; then

  echo "" 2>&1 | tee -a $LOG
  echo Rebooting Now... 2>&1 | tee -a $LOG
  sudo reboot 2>&1 | tee -a $LOG
  sleep 2
  
else
	cancel
fi

exit

