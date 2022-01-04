#!/bin/bash
rpmkeys --import "http://pool.sks-keyservers.net/pks/lookup?op=get&search=0x3fa7e0328081bff6a14da29aa6a19b38d3d831ef"
su -c 'curl https://download.mono-project.com/repo/centos7-stable.repo | tee /etc/yum.repos.d/mono-centos7-stable.repo'

yum install epel-release yum-utils -y && yum clean all -y
rpm --import "http://keyserver.ubuntu.com/pks/lookup?op=get&search=0x3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF"
yum-config-manager --add-repo http://download.mono-project.com/repo/centos/

yum -y install wget git par2cmdline p7zip unrar unzip tar gcc python-feedparser python-configobj \
  && python-cheetah python-dbus python-devel libxslt-devel yum-utils mediainfo libzen libmediainfo \
  && curl gettext sqlite.x86_64 \
  && yum clean all -y

yum -y install mono-devel-5.20.1.19 mono-core-5.20.1.19 && yum clean all -y

groupmod -g 100 users && usermod -u 99 -g 100 nobody

mkdir -p /config

# Packages list available here: http://services.sonarr.tv/v1/releases
wget http://download.sonarr.tv/v3/main/3.0.6.1342/Sonarr.main.3.0.6.1342.linux.tar.gz -O /tmp/sonarr.tar.gz \
  && tar -xvf /tmp/sonarr.tar.gz -C /opt/ \
  && rm -f /tmp/sonarr.tar.gz && mkdir -p /opt/sonarr/bin && mv /opt/Sonarr/* /opt/sonarr/bin \
  && rm -rf /opt/Sonarr && chown -R nobody:users /opt/sonarr /config

systemctl enable sonarr.service
