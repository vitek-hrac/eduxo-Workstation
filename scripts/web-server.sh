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
echo -e '\n\e[0;92mInstaluji kontejner WEB.\e[0m'
lxc launch ubuntu:lts WEB

# Add user to container
echo -e '\n\e[0;92mVytvoreni uzivatele sysadmin v kontejneru WEB:\e[0m'
lxc exec WEB -- groupadd sysadmin
lxc exec WEB -- useradd -rm -d /home/sysadmin -s /bin/bash -g sysadmin -G sudo -u 1000 sysadmin
lxc exec WEB -- sh -c 'echo "sysadmin:Netlab!23" | chpasswd'

# Enable SSH Password Authentication
lxc exec WEB -- sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
lxc exec WEB -- systemctl restart sshd

# Add static IP adress
echo -e '\e[0;92mZadejte pozadovanou IP adresu kontejneru WEB (ze site 10.20.30.0/24):\e[0m'
read IP
lxc stop $NAME
lxc network attach lxdbr0 $NAME eth0 eth0
lxc config device set $NAME eth0 ipv4.address $IP
lxc start $NAME

# Upgrade container
echo -e '\e[0;92mPriprava kontejneru WEB\e[0m'
lxc exec WEB -- DEBIAN_FRONTEND=noninteractive apt-get update > /dev/null
lxc exec WEB -- DEBIAN_FRONTEND=noninteractive apt-get upgrade -y > /dev/null
lxc exec WEB -- DEBIAN_FRONTEND=noninteractive apt install nginx -y > /dev/null
lxc exec WEB -- DEBIAN_FRONTEND=noninteractive apt-get autoremove -y > /dev/null

echo -e '\n\e[1;92mKontejner WEB je pripraven.\e[0m\n'

lxc list
