#!/usr/bin/env bash
# NAME: JTOS
# DESC: An installation and deployment script for JaxTech's Mint Cinnamon desktop.
# Adapted from Derek Taylor's (DistroTube) DTOS script...
# Top logo inspiration came from Chris Titus's ArchTitus script...

INSTALL_PATH=$(pwd)

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
echo " JTOS setup conky script will launch in 5 seconds..."

sleep 5

############### Install Conky/Settings and Widget Apps
clear
echo ""
read -p "Install Conky/Settings and Widget Apps... (y/n)? "
if [ "$REPLY" = "y" ]; then
	
  echo ""
  echo Installing conky and necessary helper apps...  Please be patient...
  echo ""
  echo ""
  sudo apt install conky-all -y
  ### required by conky network statistics section
  sudo apt install vnstat -y
  ### graphical sensor monitor
  sudo apt install psensor -y
  ### helps determine system monitors for conky
  sudo apt install tree -y

  PS3="Select the conky file to use: "

  clear
  echo ""
  echo ""

  select opt in vm e6530 macbookpro macpro quit; do

    case $opt in
      vm)
        cp $INSTALL_PATH/../configs/.conkyrc_vm ~/.conkyrc
        break
        ;;
      e6530)
        cp $INSTALL_PATH/../configs/.conkyrc_e6530 ~/.conkyrc
        break
        ;;
      macbookpro)
        cp $INSTALL_PATH/../configs/.conkyrc_macbookpro ~/.conkyrc
        break
        ;;
      macpro)
        cp $INSTALL_PATH/../configs/.conkyrc_macpro ~/.conkyrc
        break
        ;;
      quit)
        break
        ;;
      *)
        echo "Invalid option $REPLY"
        ;;
    esac
  done

  cp $INSTALL_PATH/../configs/StartupConky.desktop ~/.config/autostart/

  sudo cp $INSTALL_PATH/../configs/sun-hours_etc_cron.daily /etc/cron.daily/sun-hours
  sudo chown root:root /etc/cron.daily/sun-hours
  sudo chmod 755 /etc/cron.daily/sun-hours

  sudo cp $INSTALL_PATH/../configs/sun-hours_usr_local_bin /usr/local/bin/sun-hours
  sudo chown root:root /usr/local/bin/sun-hours
  sudo chmod 755 /usr/local/bin/sun-hours

  echo ""
  echo ""
  echo Getting current Sunset and Sunrise times...  Please be patient...
  sudo /usr/local/bin/sun-hours
  sleep 10

else
	cancel
fi

exit
