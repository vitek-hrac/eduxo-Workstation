FROM centos:latest

RUN cd /etc/yum.repos.d/
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
RUN sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*


# Aktualizace Docker image
RUN dnf update -y

# Instalace openssh server
RUN dnf install openssh-server sudo nano -y

# Nastavení hostname
RUN sh -c 'echo "rh124" > /etc/hostname'

# Přidání uživatele do sudo skupiny, vytvoření /home adresáře pro uživatele a nastavení shellu na /bin/bash
RUN groupadd sysadmin
RUN useradd -rm -d /home/sysadmin -s /bin/bash -g sysadmin -G wheel -u 1000 sysadmin

# Import souborů do Docker image
ADD files/ /home/sysadmin

# Zapnutí ssh serveru
RUN mkdir -p /var/run/sshd ; chmod -rx /var/run/sshd
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN sed -ri 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config

# Nastavení hesla pro uživatele
RUN echo 'sysadmin:Netlab!23' | chpasswd


# --------------------------------NASTAVENÍ PRO ÚLOHY---------------------------------------


# --------------------------------NASTAVENÍ PRO ÚLOHY---------------------------------------


# Zviditelnění portu 22 do sítě
EXPOSE 22

# funkce CMD říká co se má stát po zapnutí kontejneru, RUN říká co se má stát v kompilačním procesu daného kontejneru
CMD ["/usr/sbin/sshd","-D"]
