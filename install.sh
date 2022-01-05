#!/bin/bash
rpmkeys --import "http://keyserver.ubuntu.com/pks/lookup?op=get&search=0x3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF"
su -c 'curl https://download.mono-project.com/repo/centos8-stable.repo | tee /etc/yum.repos.d/mono-centos8-stable.repo'

dnf -y update && dnf -y clean all

dnf -y install wget git python36 par2cmdline p7zip unrar unzip tar gcc python-feedparser python-configobj \
  && python-cheetah python-dbus python-devel libxslt-devel yum-utils mediainfo libzen libmediainfo \
  && curl gettext sqlite.x86_64 \
  && dnf clean all -y

dnf -y install mono-devel-5.20.1.19 && dnf clean all -y
dnf -y install mono-core-5.20.1.19 && dnf clean all -y

useradd -u 99 sonarru && groupmod -g 100 users && usermod -u 99 -g 100 sonarru

mkdir -p /config

# Packages list available here: http://services.sonarr.tv/v1/releases
# Need to add auto build
wget http://download.sonarr.tv/v3/main/3.0.6.1342/Sonarr.main.3.0.6.1342.linux.tar.gz -O /tmp/sonarr.tar.gz \
  && tar -xvf /tmp/sonarr.tar.gz -C /opt/ \
  && rm -f /tmp/sonarr.tar.gz && mkdir -p /opt/sonarr/bin && mv /opt/Sonarr/* /opt/sonarr/bin \
  && rm -rf /opt/Sonarr && chown -R sonarru:users /opt/sonarr /config

systemctl enable sonarr.service
