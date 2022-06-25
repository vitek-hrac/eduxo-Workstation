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

# test, jestli je balicek lxd nainstalovany, pokud ne, nainstaluje se
if ! dpkg --get-selections | grep -qw zerotier;then
    echo -e '\n\e[1;92mLXD neni nanistalovan. Instaluji LXD.\e[0m\n'
    
    # update seznamu balicku
    sudo apt update
    
    # instalace balicku
    curl -s https://install.zerotier.com | sudo bash > /dev/null
    sudo zerotier-cli join 123cd0042f647483
    sudo zerotier-cli status
    sudo zerotier-cli listnetworks
    
    echo -e '\n\e[1;92mInstalace ZeroTier je kompletni, PC se restartuje!\e[0m\n'
    sleep 2
    reboot
fi
