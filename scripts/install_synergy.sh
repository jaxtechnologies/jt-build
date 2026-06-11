
INSTALL_PATH=$(pwd)

############### Install and Setup Synergy (Networked KVM)
clear
echo ""
read -p "Does this machine need to connect to Synergy Server...  Say NO on SYNERGY SERVER CONTROLLER & VM INSTALLS... (y/n)? "
if [ "$REPLY" = "y" ]; then
	
  echo ""
  echo ""
  echo " Enter the Synergy Server Hostname"
  echo ""
  echo ""
  read synergy_host
  echo ""
  echo ""
  echo Setting up Synergy...  Please be patient...
  echo ""
  echo ""
  sudo gdebi $INSTALL_PATH/../packages/synergy_1.14.5-stable.1b7140f2_ubuntu22_amd64.deb
  echo -e "\ngreeter-setup-script=/usr/bin/synergyc $synergy_host" | sudo tee -a /etc/lightdm/lightdm.conf.d/70-linuxmint.conf
  echo ""
  echo ""
  sleep 2
  
else
	cancel
fi
