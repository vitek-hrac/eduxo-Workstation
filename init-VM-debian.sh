#!/bin/bash
# This script prepare VM eduxo Workstation on Debian
# Tested on Debian 11 (Bullseye)


# Must be install manual
# ======================
# Install VBox Additions


# Install Script
# ==============


# Test internet connection
function check_internet() {
  printf "Checking if you are online...\n"
  wget -q --spider http://github.com
  if [ $? -eq 0 ]; then
    echo -e '\e[0;92mOnline. Continuing.\e[0m'
  else
    echo -e '\e[0;91mOffline. Go connect to the internet then run the script again.\e[0m'
  fi
}

check_internet


echo -e '\n\e[1;92mStart installation.\e[0m\n'
sudo sh -c 'echo "
# Edit /etc/hosts
127.0.0.1       localhost
127.0.1.1       eduxo.lab	eduxo
10.20.30.40     server.eduxo.lab	server

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
" > /etc/hosts'


# Install upgrades and basic programs
echo -e '\n\e[0;92mInstalling basic programs, wait for completion.\e[0m'
sudo apt-get update -y > /dev/null
sudo apt-get upgrade -y > /dev/null
sudo apt-get install -y tigervnc-viewer asciinema xrdp > /dev/null


# Install GIT
sudo apt-get install -y git > /dev/null

# GIT clone
git clone -q git@github.com:eduxo/eduxo.git > /dev/null 2>&1

# Update GIT eduxo on login
sh -c 'echo "
# eduxo
cd $HOME/eduxo/ && git pull > /dev/null 2>&1
" >> $HOME/.profile'

# Update GIT eduxo on login via rdp
sh -c 'echo "
# eduxo
cd $HOME/eduxo/ && git pull > /dev/null 2>&1
" >> $HOME/.profile'


# Install Wireshark
echo "wireshark-common wireshark-common/install-setuid boolean true" | sudo debconf-set-selections
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y wireshark > /dev/null
sudo adduser $USER wireshark > /dev/null


# Install PackerTracer (CiscoPacketTracer_820_Ubuntu_64bit.deb)
wget -q --no-check-certificate 'https://drive.google.com/uc?id=1wIY2XxRshMLwWlO_ki5WRUTC1wYRUl0z&confirm=no_antivirus&export=download' -O 'CiscoPacketTracer_820_Ubuntu_64bit.deb'
echo "PacketTracer PacketTracer_820_amd64/accept-eula select true" | sudo debconf-set-selections  > /dev/null
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y ./CiscoPacketTracer_820_Ubuntu_64bit.deb  > /dev/null
rm CiscoPacketTracer_820_Ubuntu_64bit.deb > /dev/null

echo -e '\e[0;92mInstallation basic programs is completed.\e[0m\n'


# Install GNS3
echo -e '\n\e[0;92mInstalling program GNS3, wait for completion.\e[0m'
sh -c 'echo "
deb http://ppa.launchpad.net/gns3/ppa/ubuntu trusty main
deb-src http://ppa.launchpad.net/gns3/ppa/ubuntu trusty main
" >> /etc/apt/sources.list'
sudo apt-get update > /dev/null
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y gns3-gui gns3-server > /dev/null

echo -e '\e[0;92mInstallation GNS3 is completed.\e[0m\n'


# Install Docker (https://docs.docker.com/engine/install/debian/)
echo -e '\n\e[0;92mInstalling Docker, wait for completion.\e[0m'

# Uninstall old versions
# sudo apt-get remove docker docker-engine docker.io containerd runc
    
# Set up the repository
# sudo apt-get update
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release > /dev/null
    
# Add Docker’s official GPG key
sudo mkdir -p /etc/apt/keyrings  > /dev/null
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg  > /dev/null
    
# Set up the stable repository
sudo sh -c 'echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null'
     
# Install Docker Engine
sudo apt-get update > /dev/null
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin  > /dev/null
     
# Add your user to the docker group
sudo usermod -aG docker $USER > /dev/null
     
# Install Portainer
sudo docker pull portainer/portainer-ce:latest > /dev/null
sudo docker run -d -p 9443:9443 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest > /dev/null
     
echo -e '\e[0;92mInstallation Docker is completed.\e[0m\n'


# Install LXD
echo -e '\n\e[0;92mInstalling LXD, wait for completion.\e[0m'
sudo apt install lxd > /dev/null

# Add your user to the lxd group
sudo adduser $USER lxd > /dev/null

sh -c 'echo "
config: {}
networks:
- config:
    ipv4.address: 10.20.30.1/24
    ipv4.nat: "true"
    ipv6.address: auto
  description: ""
  name: lxdbr0
  type: ""
  project: default
storage_pools:
- config:
    size: 19GB
  description: ""
  name: default
  driver: zfs
profiles:
- config: {}
  description: ""
  devices:
    eth0:
      name: eth0
      network: lxdbr0
      type: nic
    root:
      path: /
      pool: default
      type: disk
  name: default
projects: []
cluster: null
" > $HOME/input.yaml'

lxd init --preseed < $HOME/input.yaml
rm $HOME/input.yaml
    
# Create container
NAME="server"
echo -e '\e[0;92mDeploying container '$NAME' ...\e[0m'
lxc launch ubuntu:lts $NAME  > /dev/null

# Add user to container
lxc exec $NAME -- groupadd sysadmin
lxc exec $NAME -- useradd -rm -d /home/sysadmin -s /bin/bash -g sysadmin -G sudo -u 1000 sysadmin
lxc exec $NAME -- sh -c 'echo "sysadmin:Netlab!23" | chpasswd'

# Enable SSH Password Authentication
lxc exec $NAME -- sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
lxc exec $NAME -- systemctl restart sshd 

# Add static IP adress
lxc stop $NAME
lxc network attach lxdbr0 $NAME eth0 eth0
lxc config device set $NAME eth0 ipv4.address 10.20.30.40
lxc start $NAME

# Upgrade container
echo -e '\e[0;92mUpdating container '$NAME' ...\e[0m'
lxc exec $NAME -- apt-get update > /dev/null
lxc exec $NAME -- apt-get upgrade -y > /dev/null
lxc exec $NAME -- apt-get autoremove -y > /dev/null
echo -e '\e[0;92mConteiner '$NAME' is ready.\e[0m'
echo -e '\e[0;92mInstallation LXD is completed.\e[0m\n'


# clean & restart
echo -e '\n\e[0;92mCleaning ...\e[0m'
sudo DEBIAN_FRONTEND=noninteractive apt-get autoremove -y > /dev/null
history -c
unset DEBIAN_FRONTEND

echo -e '\n\e[1;92mInstallation is completed, restarting PC!\e[0m\n'
sleep 3
sudo reboot


# Post-autoinstall
# ================
# Set Background
# Set Homepage
