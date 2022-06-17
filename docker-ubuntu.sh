#!/bin/bash

# TESTOVANO:
# Ubuntu 20.04

# ZDROJE:
# https://docs.docker.com/engine/install/ubuntu/

# Test internet connection

function check_internet() {
  printf "Checking if you are online...\n"
  wget -q --spider http://github.com
  if [ $? -eq 0 ]; then
    echo -e '\e[1;92mOnline. Continuing.\e[0m'
  else
    echo -e '\e[1;91mOffline. Go connect to the internet then run the script again.\e[0m'
  fi
}

check_internet

# test, jestli je Docker nainstalovany, pokud ne, nainstaluje se
if ! dpkg --get-selections | grep -qw docker-ce;then
    echo -e '\n\e[1;92mDocker neni nanistalovan. Instaluji Docker.\e[0m\n'
    
# Uninstall old versions
sudo apt remove docker docker-engine docker.io containerd runc
    
# Set up the repository
sudo apt update
sudo apt install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
    
# Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    
# Set up the stable repository
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
     
# Install Docker Engine
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io
     
# Add your user to the docker group
sudo usermod -aG docker $USER
     
# Install Portainer
# sudo docker pull portainer/portainer-ce:latest || error "Failed to pull latest Portainer docker image!"
# sudo docker run -d -p 9443:9443 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest || error "Failed to run Portainer docker image!"
     
# Install OpenProject
# docker run -d -p 8080:80 -e SECRET_KEY_BASE=secret openproject/community:12
          
echo -e '\n\e[1;92mInstalace Dockeru je kompletni, PC se restartuje!\e[0m\n'
sleep 2
reboot

else
    echo -e '\n\e[1;92mDocker je jiz nainstalovan!\e[0m\n'
fi