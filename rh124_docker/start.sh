#!/bin/bash
# Vytvoreni docker containeru CentOS:latest

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

# Container 
echo -e '\n\e[0;92mZadejte jmeno kontejneru:\e[0m'
read NAME

docker build -t $NAME .
docker run -h $NAME.eduxo.lab -d -p 80:80 -p 22:22 --name $NAME $NAME:latest
docker container inspect $NAME | grep -i IPAddress | tail -n 1 | tr -d ' "'
