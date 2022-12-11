#!/bin/bash
# This script prepare VM eduxo Workstation on Debian
# Tested on Debian 11 (Bullseye) Mate


# Must be install manual
# ======================
# Install VBox Additions


# Test internet connection
function check_internet() {
  printf "Checking if you are online..."
  wget -q --spider http://github.com
  if [ $? -eq 0 ]; then
    echo -e '\e[0;92mOnline. Continuing.\e[0m\n'
  else
    echo -e '\e[0;91mOffline. Go connect to the internet then run the script again.\e[0m\n'
  fi
}
check_internet


echo -e '\e[1;92mStart installation.\e[0m'

sudo sh -c 'echo "
127.0.0.1     localhost
127.0.1.1     eduxo.lab eduxo

10.20.30.40   server.eduxo.lab	server

# The following lines are desirable for IPv6 capable hosts
::1     localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters

2001:db8:acad::40   server.eduxo.lab	server
" > /etc/hosts'


# Install upgrades and basic programs
echo -e '\e[0;92mInstalling basic programs, wait for completion.\e[0m\n'
sleep 3
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y asciinema xrdp


# Install GIT
sudo apt-get install -y git

# GIT clone
git clone https://github.com/eduxo/eduxo.git $HOME/eduxo

# Update GIT eduxo on login
sh -c 'echo "
# eduxo
cd $HOME/eduxo/ && git pull > /dev/null 2>&1
" >> $HOME/.profile'

# Update GIT eduxo on login via rdp
sh -c 'echo "

# eduxo
cd $HOME/eduxo/ && git pull > /dev/null 2>&1
" >> /etc/xrdp/startwm.sh'


# Install Wireshark
echo "wireshark-common wireshark-common/install-setuid boolean true" | sudo debconf-set-selections
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y wireshark
sudo adduser $USER wireshark


# Install PackerTracer (CiscoPacketTracer_820_Ubuntu_64bit.deb)
wget --no-check-certificate 'https://drive.google.com/uc?id=1wIY2XxRshMLwWlO_ki5WRUTC1wYRUl0z&confirm=no_antivirus&export=download' -O 'CiscoPacketTracer_820_Ubuntu_64bit.deb'
echo "PacketTracer PacketTracer_820_amd64/accept-eula select true" | sudo debconf-set-selections
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y ./CiscoPacketTracer_820_Ubuntu_64bit.deb
rm CiscoPacketTracer_820_Ubuntu_64bit.deb

echo -e '\e[0;92mInstallation basic programs is completed.\e[0m\n'
sleep 3


# Install GNS3
echo -e '\e[0;92mInstalling program GNS3, wait for completion.\e[0m\n'
sleep 3
sudo apt-get install -y python3-pip python3-pyqt5 python3-pyqt5.qtsvg \
python3-pyqt5.qtwebsockets \
qemu qemu-kvm qemu-utils libvirt-clients libvirt-daemon-system virtinst \
tigervnc-viewer tigervnc-standalone-server apt-transport-https \
ca-certificates curl gnupg2 software-properties-common \
xterm
sudo pip3 install gns3-server
sudo pip3 install gns3-gui

# Install ubridge and dynamips (https://computingforgeeks.com/how-to-install-gns3-on-debian/)
sudo apt-get install -y pcaputils libpcap-dev
git clone https://github.com/GNS3/ubridge.git $HOME/ubridge
cd $HOME/ubridge && make
cd $HOME/ubridge && sudo make install
rm -rf $HOME/ubridge

sudo apt-get install -y libelf-dev cmake
git clone https://github.com/GNS3/dynamips.git $HOME/dynamips
mkdir $HOME/dynamips/build
cd $HOME/dynamips/build && cmake ..
cd $HOME/dynamips/build && sudo make install
rm -rf $HOME/dynamips

# Uprava konfigurace (https://docs.gns3.com/docs/troubleshooting-faq/troubleshoot-gns3/)
mkdir -p $HOME/.config/GNS3/2.2/
#/usr/bin/gns3server
sh -c 'echo "[Server]
path = /usr/bin/gns3server
ubridge_path = ubridge
host = localhost
port = 3080
images_path = /home/sysadmin/GNS3/images
projects_path = /home/sysadmin/GNS3/projects
appliances_path = /home/sysadmin/GNS3/appliances
additional_images_paths = 
symbols_path = /home/sysadmin/GNS3/symbols
configs_path = /home/sysadmin/GNS3/configs
report_errors = True
auto_start = True
allow_console_from_anywhere = False
auth = True
user = sysadmin
password = Netlab!23
protocol = http
console_start_port_range = 5000
console_end_port_range = 10000
udp_start_port_range = 10000
udp_end_port_range = 20000
[Qemu]
enable_kvm = false" > $HOME/.config/GNS3/2.2/gns3_server.conf'

echo -e '\e[0;92mInstallation GNS3 is completed.\e[0m\n'
sleep 3


# Install Docker (https://docs.docker.com/engine/install/debian/)
echo -e '\e[0;92mInstalling Docker, wait for completion.\e[0m\n'
sleep 3

# Uninstall old versions
# sudo apt-get remove docker docker-engine docker.io containerd runc
    
# Set up the repository
# sudo apt-get update
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
    
# Add Docker’s official GPG key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    
# Set up the stable repository
sudo sh -c 'echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null'
     
# Install Docker Engine
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
     
# Add your user to the docker group
sudo usermod -aG docker $USER
     
# Install Portainer
sudo docker pull portainer/portainer-ce:latest
sudo docker run -d \
--name portainer \
--restart always \
--publish 9443:9443 \
--volume /var/run/docker.sock:/var/run/docker.sock \
--volume portainer_data:/data portainer/portainer-ce:latest

echo -e '\e[0;92mInstallation Docker is completed.\e[0m\n'
sleep 3


# Install LXD
echo -e '\e[0;92mInstalling LXD, wait for completion.\e[0m\n'
sleep 3
sudo apt install -y snapd
sudo snap install core
sudo snap install lxd
sudo ln -s /snap/bin/lxd /usr/bin/lxd
sudo ln -s /snap/bin/lxc /usr/bin/lxc

# Add your user to the lxd group
sudo adduser $USER lxd

sh -c 'echo "
config: {}
networks:
- config:
    ipv4.address: 10.20.30.1/24
    ipv4.nat: "true"
    ipv6.address: 2001:db8:acad::1/64
    ipv6.nat: "true"
  description: ""
  name: intranet
  type: ""
  project: default
storage_pools:
- config:
    size: 19GB
  description: ""
  name: intranet
  driver: btrfs
profiles:
- config: {}
  description: ""
  devices:
    eth0:
      name: eth0
      network: intranet
      type: nic
    root:
      path: /
      pool: intranet
      type: disk
  name: default
projects: []
cluster: null
" > $HOME/input.yaml'

sudo lxd init --preseed < $HOME/input.yaml
rm $HOME/input.yaml
    
# Create container
NAME="server"
echo -e '\e[0;92mDeploying container '$NAME' ...\e[0m\n'
sleep 3
sudo lxc launch images:debian/11 $NAME

# Add user to container
sudo lxc exec $NAME -- groupadd sysadmin
sudo lxc exec $NAME -- useradd -rm -d /home/sysadmin -s /bin/bash -g sysadmin -G sudo -u 1000 sysadmin
sudo lxc exec $NAME -- sh -c 'echo "sysadmin:Netlab!23" | chpasswd'

# Enable SSH Password Authentication
sudo lxc exec $NAME -- apt-get install -y openssh-server

# Add static IP adress
sudo lxc stop $NAME
sudo lxc network attach lxdbr0 $NAME eth0 eth0
sudo lxc config device set $NAME eth0 ipv4.address 10.20.30.40
sudo lxc network set lxdbr0 ipv6.dhcp.stateful true
sudo lxc config device set $NAME eth0 ipv6.address 2001:db8:acad::40
sudo lxc start $NAME
sleep 3

# Upgrade container
echo -e '\e[0;92mUpdating container '$NAME' ...\e[0m\n'
sleep 3
sudo lxc exec $NAME -- apt-get update
sudo lxc exec $NAME -- apt-get upgrade -y
sudo lxc exec $NAME -- apt-get autoremove -y
echo -e '\e[0;92mConteiner '$NAME' is ready.\e[0m\n'
echo -e '\e[0;92mInstallation LXD is completed.\e[0m\n'


# clean & restart
echo -e '\e[0;92mCleaning ...\e[0m\n'
sleep 3
sudo DEBIAN_FRONTEND=noninteractive apt-get autoremove -y > /dev/null
history -c
unset DEBIAN_FRONTEND

echo -e '\n\e[1;92mInstallation is completed, restarting PC!\e[0m\n'
sleep 3
sudo reboot


# Post-autoinstall
# ================
# Set Background
# Set Homepage (www.eduxo.cz)
# Set GNS3
# Menu Education
# Associate files for Wireshark, GNS3 portable projects


