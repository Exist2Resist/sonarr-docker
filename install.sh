#!/bin/bash

apt-get update && apt-get upgrade -y && apt-get clean
apt-get install apt-utils apt-transport-https ca-certificates && apt-get clean
apt-get update && apt-get upgrade -y && apt-get clean
apt-get install software-properties-common -y && apt-get clean
apt-get install build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev curl wget libbz2-dev -y && apt-get clean

# Set container TZ
ln -fs /usr/share/zoneinfo/America/Edmonton /etc/localtime
export DEBIAN_FRONTEND=noninteractive
apt-get install -y tzdata && apt-get clean -y

# Install applications
apt-get -y install jq curl wget autoconf automake g++ make git p7zip unzip tar gcc python3-distutils-extra python3-feedparser && apt-get clean
apt-get -y install python3-configobj libmediainfo0v5 gettext python-dev libxml2-dev python-cheetah python-dbus mediainfo apt-utils sqlite3 && apt-get clean

# Install Python3.6
wget https://www.python.org/ftp/python/3.6.15/Python-3.6.15.tgz -O /tmp/Python-3.6.15.tgz
cd /tmp
tar -xf /tmp/Python-3.6.15.tgz
cd Python-3.6.15
./configure --enable-optimizations
make install
cd /
rm -rf /tmp/Python-3.6.15
ln -fs /usr/local/bin/python3.6 /usr/local/bin/python

#Insttall par2
wget https://github.com/Parchive/par2cmdline/releases/download/v0.8.1/par2cmdline-0.8.1.tar.gz -O /tmp/par2cmdline-0.8.1.tar.gz
cd /tmp
tar -xf par2cmdline-0.8.1.tar.gz
cd ./par2cmdline-0.8.1
./automake.sh
./configure
make install
cd /
rm -rf /tmp/par2cmdline-0.8.1*

# Install rar
wget --no-check-certificate https://www.rarlab.com/rar/rarlinux-x64-610.tar.gz -O /tmp/rarlinux-x64-610.tar.gz
cd /tmp
tar -xf rarlinux-x64-610.tar.gz
cp rar/rar rar/unrar /usr/bin
rm -rf rar*

# Add user and set directories
useradd -u 99 sonarru && groupmod -g 100 users && usermod -u 99 -g 100 sonarru

# Get systemd
wget https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl3.py -O /usr/local/bin/systemctl
chmod 755 /usr/local/bin/systemctl

mkdir -p /config

LATEST_RELEASE=$(curl http://services.sonarr.tv/v1/releases | jq -r '.[] | select(.branch=="main") | .linux.manual.url ')
wget $LATEST_RELEASE -O /tmp/sonarr.tar.gz \
  && tar -xvf /tmp/sonarr.tar.gz -C /opt/ \
  && rm -f /tmp/sonarr.tar.gz && mkdir -p /opt/sonarr/bin && mv /opt/Sonarr/* /opt/sonarr/bin \
  && rm -rf /opt/Sonarr && chown -R sonarru:users /opt/sonarr /config

systemctl enable sonarr
