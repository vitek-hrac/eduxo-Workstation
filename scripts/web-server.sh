#!/bin/bash

# TESTOVANO:
# Ubuntu 22.04

# ZDROJE:
# https://ubuntu.com/server/docs/containers-lxd

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

# Create container
echo -e '\n\e[0;92mVytvarim kontejner ...\e[0m'
lxc launch ubuntu:lts web-server

# Setting container
echo -e '\n\e[0;92mNastavuji kontejner ...\e[0m'

# Add user to container
lxc exec web-server -- groupadd sysadmin
lxc exec web-server -- useradd -rm -d /home/sysadmin -s /bin/bash -g sysadmin -G sudo -u 1000 sysadmin
lxc exec web-server -- sh -c 'echo "sysadmin:Netlab!23" | chpasswd'

# Enable SSH Password Authentication
lxc exec web-server -- sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
lxc exec web-server -- systemctl restart sshd

# Add static IP adress
lxc stop web-server
lxc network attach lxdbr0 web-server eth0 eth0
lxc config device set web-server eth0 ipv4.address 10.20.30.41
lxc start web-server

# Upgrade container
lxc exec web-server -- DEBIAN_FRONTEND=noninteractive apt-get update > /dev/null
lxc exec web-server -- DEBIAN_FRONTEND=noninteractive apt-get upgrade -y > /dev/null
lxc exec web-server -- DEBIAN_FRONTEND=noninteractive apt install nginx -y > /dev/null
lxc exec web-server -- DEBIAN_FRONTEND=noninteractive apt-get autoremove -y > /dev/null

sleep 2
echo -e '\n\e[1;92mKontejner je pripraven.\e[0m\n'

lxc list
echo -e '\n'
