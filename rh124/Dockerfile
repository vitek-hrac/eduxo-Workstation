FROM centos:latest

# Aktualizace Docker image
RUN dnf update -y

# Instalace openssh server
RUN dnf install openssh-server sudo -y

# Nastavení hostname
RUN sh -c 'echo "rh124" > /etc/hostname'

# Přidání uživatele do sudo skupiny, vytvoření /home adresáře pro uživatele a nastavení shellu na /bin/bash
RUN groupadd sysadmin
RUN useradd -rm -d /home/sysadmin -s /bin/bash -g sysadmin -G sudo -u 1000 sysadmin

# Import souborů do Docker image
ADD files/ /home/sysadmin

# Zapnutí ssh serveru
RUN service ssh start

# Nastavení hesla pro uživatele
RUN echo 'sysadmin:Netlab!23' | chpasswd


# --------------------------------NASTAVENÍ PRO ÚLOHY---------------------------------------


# --------------------------------NASTAVENÍ PRO ÚLOHY---------------------------------------


# Zviditelnění portu 22 do sítě
EXPOSE 22

# funkce CMD říká co se má stát po zapnutí kontejneru, RUN říká co se má stát v kompilačním procesu daného kontejneru
CMD ["/usr/sbin/sshd","-D"]
