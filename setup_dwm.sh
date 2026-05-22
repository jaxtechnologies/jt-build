
terminus-font
ttf-mononoki-nerd 

openssh

##### openssh -- Enable and start openssh
echo "Enabling and starting openssh..."
sleep 5
sudo systemctl enable sshd
sudo systemctl start sshd
sudo ufw allow ssh
sleep 5

