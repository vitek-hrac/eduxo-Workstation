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
echo -e '\n\e[0;92mVytvarim kontejner WEB...\e[0m'
lxc launch ubuntu:lts WEB

# Setting container
echo -e '\n\e[0;92mNastavuji kontejner...\e[0m'

# Add user to container
lxc exec WEB -- groupadd sysadmin
lxc exec WEB -- useradd -rm -d /home/sysadmin -s /bin/bash -g sysadmin -G sudo -u 1000 sysadmin
lxc exec WEB -- sh -c 'echo "sysadmin:Netlab!23" | chpasswd'

# Enable SSH Password Authentication
lxc exec WEB -- sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
lxc exec WEB -- systemctl restart sshd

# Add static IP adress
lxc stop WEB
lxc network attach lxdbr0 WEB eth0 eth0
lxc config device set WEB eth0 ipv4.address 10.20.30.41
lxc start WEB

# Upgrade container
lxc exec WEB -- DEBIAN_FRONTEND=noninteractive apt-get update > /dev/null
lxc exec WEB -- DEBIAN_FRONTEND=noninteractive apt-get upgrade -y > /dev/null
lxc exec WEB -- DEBIAN_FRONTEND=noninteractive apt install nginx -y > /dev/null
lxc exec WEB -- DEBIAN_FRONTEND=noninteractive apt-get autoremove -y > /dev/null

sleep 2
echo -e '\n\e[1;92mKontejner WEB je pripraven.\e[0m\n'

lxc list
echo -e '\n'
