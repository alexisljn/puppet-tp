#!/bin/sh

# Paranoia mode
set -e
set -u

HOSTNAME="$(hostname)"

export DEBIAN_FRONTEND=noninteractive

# Mettre à jour le catalogue des paquets debian
apt-get update --allow-releaseinfo-change

# Installer les prérequis pour puppet
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    git \
    curl \
    wget \
    vim \
    gnupg2 \
    software-properties-common

# J'utilise /etc/hosts pour associer les IP aux noms de domaines
# sur mon réseau local, sur chacune des machines
sed -i \
	-e '/^## BEGIN PROVISION/,/^## END PROVISION/d' \
	/etc/hosts
cat >> /etc/hosts <<MARK
## BEGIN PROVISION
192.168.50.250      control control.home
192.168.50.10       revproxy revproxy.home
192.168.50.20       app1 app1.home
192.168.50.30       app2 app2.home
192.168.50.40       app3 app3.home
192.168.50.50       app4 app4.home
192.168.50.60       app5 app5.home
## END PROVISION
MARK

# Désactive l'update automatique du cache apt + indexation (lourd en CPU)
cat >> /etc/apt/apt.conf.d/99periodic-disable <<MARK
APT::Periodic::Enable "0";
MARK

echo "SUCCESS."
