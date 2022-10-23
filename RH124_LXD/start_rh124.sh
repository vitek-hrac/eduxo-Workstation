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

# ------------------------------------ SERVER A -------------------------------------------
# Container serverA
NAME="servera"
IP="10.20.30.110"

# Create container
echo -e '\n\e[0;92mVytvarim kontejner '$NAME'\e[0m'
lxc launch images:centos/9-Stream $NAME

lxc exec $NAME -- cd /etc/yum.repos.d/
lxc exec $NAME -- sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/centos.repo
lxc exec $NAME -- sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/centos.repo

# Upgrade container
echo -e '\e[0;92mAktualizuji kontejner '$NAME'\e[0m'
sleep 5
lxc exec $NAME -- dnf update -y > /dev/null
lxc exec $NAME -- dnf autoremove -y > /dev/null

# Setting container
echo -e '\e[0;92mNastavuji kontejner '$NAME'\e[0m'

# Install SSH
lxc exec $NAME -- dnf install openssh-server nano -y > /dev/null

# Add user to container
echo -e '\e[0;92mVytvorim uzivatele sysadmin v kontejneru '$NAME':\e[0m'
lxc exec $NAME -- groupadd sysadmin
lxc exec $NAME -- useradd -rm -d /home/sysadmin -s /bin/bash -g sysadmin -G wheel -u 1001 sysadmin
lxc exec $NAME -- sh -c 'echo "sysadmin:Netlab!23" | chpasswd'

# Add static IP adress
lxc stop $NAME
lxc network attach lxdbr0 $NAME eth0 eth0
lxc config device set $NAME eth0 ipv4.address $IP
lxc start $NAME


# --------------------------------NASTAVENÍ PRO SERVER A------------------------------------



# --------------------------------NASTAVENÍ PRO SERVER A------------------------------------


# Edit /etc/hosts
# echo -e '\e[0;92mPro nastaveni domain-name je nutne opravneni:\e[0m'
sudo sh -c 'echo "'$IP'     '$NAME'.eduxo.lab	'$NAME'" >> /etc/hosts'

echo -e '\n\e[0;92mKontejner je pripraven:\e[0m
Container-name: '$NAME'
Domain-name: '$NAME'.eduxo.lab
IP adresa: '$IP'\n'


# ------------------------------------ SERVER B -------------------------------------------
# Container server B
NAME="serverb"
IP="10.20.30.111"

# Create container
echo -e '\n\e[0;92mVytvarim kontejner...\e[0m'
lxc launch images:centos/9-Stream $NAME

lxc exec $NAME -- cd /etc/yum.repos.d/
lxc exec $NAME -- sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/centos.repo
lxc exec $NAME -- sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/centos.repo

# Upgrade container
echo -e '\e[0;92mAktualizuji kontejner...\e[0m'
sleep 5
lxc exec $NAME -- dnf update -y > /dev/null
lxc exec $NAME -- dnf autoremove -y > /dev/null

# Setting container
echo -e '\e[0;92mNastavuji kontejner...\e[0m'

# Install SSH
lxc exec $NAME -- dnf install openssh-server nano -y > /dev/null

# Add user to container
echo -e '\n\e[0;92mVytvoreni uzivatele sysadmin v kontejneru '$NAME':\e[0m'
lxc exec $NAME -- groupadd sysadmin
lxc exec $NAME -- useradd -rm -d /home/sysadmin -s /bin/bash -g sysadmin -G wheel -u 1001 sysadmin
lxc exec $NAME -- sh -c 'echo "sysadmin:Netlab!23" | chpasswd'

# Add static IP adress
lxc stop $NAME
lxc network attach lxdbr0 $NAME eth0 eth0
lxc config device set $NAME eth0 ipv4.address $IP
lxc start $NAME



# --------------------------------NASTAVENÍ PRO SERVER B------------------------------------



# --------------------------------NASTAVENÍ PRO SERVER B------------------------------------


# Edit /etc/hosts
# echo -e '\e[0;92mPro nastaveni domain-name je nutne opravneni:\e[0m'
sudo sh -c 'echo "'$IP'     '$NAME'.eduxo.lab	'$NAME'" >> /etc/hosts'

echo -e '\n\e[0;92mKontejner je pripraven:\e[0m
Container-name: '$NAME'
Domain-name: '$NAME'.eduxo.lab
IP adresa: '$IP'\n'
