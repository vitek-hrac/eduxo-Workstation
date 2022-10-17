# Dockerfile je ulozen ve stejnem adresari

docker build -t CONTAINER_NAME .
docker run -d -p 80:80 -p 22:22 --name NAZEV CONTAINER_NAME:latest
docker container inspect NAZEV | grep -i IPAddress | tail -n 1 | tr -d ' "'
