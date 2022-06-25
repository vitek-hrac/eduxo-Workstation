# Initial Installation EDUXO Workstation
# ======================================

# Must be install manual
# ======================
# Install VBox Additions


# Install Script
# ==============
#!/bin/bash

# Test internet connection
function check_internet() {
  printf "Checking if you are online...\n"
  wget -q --spider http://github.com
  if [ $? -eq 0 ]; then
    echo -e '\e[1;92mOnline. Continuing.\e[0m\n'
  else
    echo -e '\e[1;91mOffline. Go connect to the internet then run the script again.\e[0m\n'
  fi
}

check_internet
sleep 2

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
ff02::2 ip6-allrouters" > /etc/hosts'


# Install GIT
sudo apt-get install -y git > /dev/null

# Add GIT repository to known_hosts
mkdir $HOME/.ssh
sh -c 'echo "|1|VSLCHr+ezHBxkFD9rRAYCxw6kFE=|77bNivll371MzWKyYmzQ8uBTqIE= ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl
|1|Nf+XGG/H0UPPUv4yup3G367CfvI=|wZ+hb+yLGjYapC1ap1R/93bL7zs= ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==
|1|QHTXH/m6GX3LiI27BD9LbgC2gmE=|ZLnxLbggMb36OPCLJMkls1IgfDQ= ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg=" > $HOME/.ssh/known_hosts'
chmod 644 $HOME/.ssh/known_hosts

# Add public key
sh -c 'echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCVc6cW+yR2LnymMl9JE6K1LrsGG+9FXN+SZj/DLmX+b3giOeCVq+zeJjBJFYie6QP+GKCwoZgdyhQ2BXvoZC2u6mNmhFV/KUdHSw0S888j3HwtWlN5ESFnOfTtrFSAngcAnXWgG31d9zNXZ+oYeS7VEBYtI8Fgl86/1QwXnDijhVebeAM9L+SCJjewaBt4PFMtCJx8Y+ymdFK1gYuy3M+WDvnKDOzV/oVbSbx44deh+7+I9HxO8x/3Q0LiLOQTVViC1b8Q/NNYA8DzJauB8auU+Cg1VAk9zi5e+/bbTW+BPn5s38G50/4LPbmB8wNZhG5gwOIGdbAtr1bTSNoqHrI1O5EUOCAGkknMC/ADmADwcfALIR24aUvL7Wh8UwJqoEq69wNnjHdRupRcqRzLi/JPW/Xcp0Sn9NaHgZ21YOBlf5XzGLg+FhYIAWebxGW7hrnw68GCtObA+AylOMqOrMidbFgbf/9dVDL9RN756UeYifa/ZgAgDuttnAdl9DkDzZMJUHlJ+mbJJs9vjlFPLwWAY1Obg+PB4SYBaWz7r8XeYa4LGszK7ONU3nLRqxg247cDRtID+aIjehHCV+4aJfpwLl2unDbkIxwgg8gllOtdBIO9+TjmvFviSrWH257JxGahqV0llcoeZVJGe1gQuBmiGViJEo5CqJueUqhGADBhEw== sysadmin@eduxo" > $HOME/.ssh/id_rsa.pub'
chmod 644 $HOME/.ssh/id_rsa.pub

# Add private key
sh -c 'echo "-----BEGIN OPENSSH PRIVATE KEY-----
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
-----END OPENSSH PRIVATE KEY-----" > $HOME/.ssh/id_rsa'
chmod 600 $HOME/.ssh/id_rsa

# GIT clone
git clone git@github.com:eduxo/eduxo.git > /dev/null


# Install upgrades and basic programs
echo -e '\n\e[1;92mInstalling basic programs, wait for completion.\e[0m'
sleep 2
sudo apt-get update -y > /dev/null
sudo apt-get upgrade -y > /dev/null
sudo apt-get install -y tigervnc-viewer asciinema > /dev/null


# Install Wireshark
echo "wireshark-common wireshark-common/install-setuid boolean true" | sudo debconf-set-selections
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y wireshark > /dev/null
unset DEBIAN_FRONTEND
sudo adduser $USER wireshark > /dev/null


# Install PackerTracer (CiscoPacketTracer_811_Ubuntu_64bit.deb)
wget -q --no-check-certificate 'https://drive.google.com/uc?id=19K-2Y9JU-6rgP9I6Cap7uP03UGIsdQCb&confirm=no_antivirus&export=download' -O 'CiscoPacketTracer_811_Ubuntu_64bit.deb'
echo "PacketTracer PacketTracer_810_amd64/accept-eula select true" | sudo debconf-set-selections  > /dev/null
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y ./CiscoPacketTracer_811_Ubuntu_64bit.deb  > /dev/null
rm CiscoPacketTracer_811_Ubuntu_64bit.deb > /dev/null

echo -e '\n\e[1;92mInstallation basic programs is completed.\e[0m\n'
sleep 2


# GNS3 (https://docs.gns3.com/docs/getting-started/installation/linux/)
echo -e '\n\e[1;92mInstalling program GNS3, wait for completion.\e[0m'
sleep 2
sudo add-apt-repository -y ppa:gns3/ppa > /dev/null
sudo apt-get update > /dev/null
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y gns3-gui gns3-server > /dev/null
unset DEBIAN_FRONTEND
# Uprava konfigurace (https://docs.gns3.com/docs/troubleshooting-faq/troubleshoot-gns3/)
mkdir -p $HOME/.config/GNS3/2.2/
#/usr/bin/gns3server
sh -c 'echo "[Server]
path = /usr/bin/gns3server
ubridge_path = ubridge
host = localhost
port = 3080
images_path = /home/sysadmin/eduxo/GNS3/images
projects_path = /home/sysadmin/eduxo/GNS3/projects
appliances_path = /home/sysadmin/eduxo/GNS3/appliances
additional_images_paths = 
symbols_path = /home/sysadmin/eduxo/GNS3/symbols
configs_path = /home/sysadmin/eduxo/GNS3/configs
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

echo -e '\n\e[1;92mInstallation GNS3 is completed.\e[0m\n'
sleep 2


# Install Docker (https://docs.docker.com/engine/install/ubuntu/)
echo -e '\n\e[1;92mInstalling Docker, wait for completion.\e[0m'
sleep 2

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
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg > /dev/null
    
# Set up the stable repository
sudo sh -c 'echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null'
     
# Install Docker Engine
sudo apt-get update > /dev/null
sudo apt-get install -y docker-ce docker-ce-cli containerd.io > /dev/null
     
# Add your user to the docker group
sudo usermod -aG docker $USER > /dev/null
     
# Install Portainer
sudo docker pull portainer/portainer-ce:latest > /dev/null
sudo docker run -d -p 9443:9443 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest > /dev/null
     
echo -e '\n\e[1;92mInstallation Docker is completed.\e[0m\n'


# Install LXD
echo -e '\n\e[1;92mInstalling LXD, wait for completion.\e[0m'
sleep 2 
sudo snap install lxd > /dev/null

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
echo -e '\n\e[1;92mDeploying container '$NAME' ...\e[0m'
lxc launch ubuntu:lts $NAME  > /dev/null

# Add user to container
lxc exec $NAME -- groupadd sysadmin
lxc exec $NAME -- useradd -rm -d /home/sysadmin -s /bin/bash -g sysadmin -G sudo -u 1000 sysadmin
lxc exec $NAME -- sh -c 'echo "sysadmin:Netlab!23" | chpasswd'
#lxc exec $NAME -- sh -c 'echo "sysadmin:Netlab!23" | sudo chpasswd'

# Enable SSH Password Authentication
lxc exec $NAME -- sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
lxc exec $NAME -- systemctl restart sshd 

# Add static IP adress
lxc stop $NAME
lxc network attach lxdbr0 $NAME eth0 eth0
lxc config device set $NAME eth0 ipv4.address 10.20.30.40
lxc start $NAME

# Upgrade container
echo -e '\n\e[1;92mUpdating container '$NAME' ...\e[0m'
sleep 2
lxc exec $NAME -- apt-get update > /dev/null
lxc exec $NAME -- apt-get upgrade -y > /dev/null
sleep 2
lxc exec $NAME -- apt-get autoremove -y > /dev/null

echo -e '\n\e[1;92mConteiner '$NAME' is ready.\e[0m'
lxc list
echo -e '\n\e[1;92mInstallation LXD is completed.\e[0m\n'
sleep 2


# clean & restart
echo -e '\n\e[1;92mCleaning ...\e[0m'
sudo apt-get autoremove -y > /dev/null
history -c
sleep 2
echo -e '\n\e[1;92mInstallation is completed, restarting PC!\e[0m\n'
sleep 3
sudo reboot


# Post-autoinstall
# ================
# Set Background (earth.jpg)
# Home Page: https://eduxo.ssipf.cz/3MrrhgZtr3ooAgcIpg6f/

# Create SSH key
# ssh-keygen -q -t rsa -b 4096 -f "$HOME/.ssh/id_rsa" -N ""
