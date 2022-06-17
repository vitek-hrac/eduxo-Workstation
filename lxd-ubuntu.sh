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
    sudo snap install lxd
    sudo lxd init
    
    # pridani uzivatele do skupiny lxd
    sudo adduser $USER lxd
    
    echo -e '\n\e[1;92mInstalace LXD je kompletni, PC se restartuje!\e[0m\n'
    sleep 2
    reboot
fi
   
# VYTVORENI KONTEJNERU

echo -e '\n\e[1;92mZadejte jmeno kontejneru:\e[0m'
read NAME

# vytvoreni kontejneru
lxc launch ubuntu:lts $NAME

# nastaveni kontejneru
echo -e '\n\e[1;92mVytvoreni uzivatele sysadmin v kontejneru '$NAME':\e[0m\n'
lxc exec $NAME -- adduser sysadmin
lxc exec $NAME -- adduser sysadmin sudo
lxc exec $NAME -- sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

lxc exec $NAME -- systemctl restart sshd

# prirazeni staticke IP adresy
echo -e '\n\e[1;92mZadejte požadovanou IP adresu kontejneru '$NAME':\e[0m'
read IP

lxc stop $NAME
lxc network attach lxdbr0 $NAME eth0 eth0
lxc config device set $NAME eth0 ipv4.address $IP
lxc start $NAME

# aktualizace kontejneru
echo -e '\n\e[1;92mAktualizace kontejneru '$NAME'\e[0m\n'
sleep 2
lxc exec $NAME -- apt update
lxc exec $NAME -- apt upgrade -y
lxc exec $NAME -- apt autoremove -y

echo -e '\n\e[1;92mKontejner '$NAME' je pripraven.\e[0m\n'
lxc list
