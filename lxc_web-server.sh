#!/bin/bash

# TESTOVANO:
# Ubuntu 20.04

# ZDROJE:
# https://ubuntu.com/server/docs/containers-lxd

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

# test, jestli je balicek lxd nainstalovany, pokud ne, nainstaluje se
if ! dpkg --get-selections | grep -qw lxd;then
    echo -e '\n\e[1;92mLXD neni nanistalovan. Instaluji LXD.\e[0m\n'
    
    # update seznamu balicku
    sudo apt update
    
    # instalace balicku lxd
    sudo apt install -y lxd
    sudo lxd init
    
    # pridani uzivatele do skupiny lxd
    sudo adduser $USER lxd
    
    echo -e '\n\e[1;92mInstalace LXD je kompletni, PC se restartuje!\e[0m\n'
    sleep 2
    reboot
fi
   
# vytvoreni kontejneru
echo -e '\n\e[1;92mInstaluji kontejner ...\e[0m\n'
lxc launch ubuntu:lts WEB

# nastaveni kontejneru
echo -e '\n\e[1;92mVytvarim uzivatele sysadmin ...\e[0m\n'
lxc exec WEB -- adduser sysadmin
lxc exec WEB -- adduser sysadmin sudo
lxc exec WEB -- sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

lxc exec WEB -- systemctl restart sshd

# prirazeni staticke IP adresy
lxc stop WEB
lxc network attach lxdbr0 WEB eth0 eth0
lxc config device set WEB eth0 ipv4.address 10.20.30.41
lxc start WEB

# instalace NGINX
echo -e '\n\e[1;92mInstaluji web server ...\e[0m\n'
sleep 2
lxc exec WEB -- apt update
lxc exec WEB -- apt install nginx -y
lxc exec WEB -- apt autoremove -y

echo -e '\n\e[1;92mKontejner WEB je pripraven.\e[0m\n'
lxc list