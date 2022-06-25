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

# test, jestli je ZeroTier nainstalovany, pokud ne, nainstaluje se
if ! dpkg --get-selections | grep -qw zerotier;then
    echo -e '\n\e[1;92mZeroTier neni nanistalovan. Instaluji ZeroTier.\e[0m\n'
    
    # update seznamu balicku
    sudo apt update
    
    # instalace balicku
    curl -s https://install.zerotier.com | sudo bash > /dev/null
    sudo zerotier-cli join 123cd0042f647483
    sudo zerotier-cli status
    sudo zerotier-cli listnetworks
    sleep 3
    
    echo -e '\n\e[1;92mInstalace ZeroTier je kompletni, PC se restartuje!\e[0m\n'
    sleep 3
    reboot
else
    echo -e '\n\e[1;92mZeroTier je jiz nainstalovan!\e[0m\n'
fi
