# Stop containers
echo -e '\n\e[0;92mZastavuji kontejnery...\e[0m'
lxc stop servera
lxc stop serverb
wait 2

# Delete containers
echo -e '\n\e[0;92mMazu kontejnery...\e[0m'
lxc delete servera
lxc delete serverb
wait 2

echo -e '\n\e[0;92mHOTOVO\e[0m'
