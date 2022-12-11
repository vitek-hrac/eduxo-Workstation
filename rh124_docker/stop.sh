#!/bin/bash
# Odstraneni docker containeru

# Container 
echo -e '\n\e[0;92mZadejte jmeno kontejneru:\e[0m'
read NAME

docker stop $NAME
docker container rm $NAME
docker image rm $NAME:latest
