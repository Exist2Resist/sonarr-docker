#!/bin/bash
rpmkeys --import "http://pool.sks-keyservers.net/pks/lookup?op=get&search=0x3fa7e0328081bff6a14da29aa6a19b38d3d831ef"
su -c 'curl https://download.mono-project.com/repo/centos7-stable.repo | tee /etc/yum.repos.d/mono-centos7-stable.repo'

yum install epel-release yum-utils -y && yum clean all -y
rpm --import "http://keyserver.ubuntu.com/pks/lookup?op=get&search=0x3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF"
yum-config-manager --add-repo http://download.mono-project.com/repo/centos/
yum install wget mediainfo libzen libmediainfo curl gettext mono-core mono-devel sqlite.x86_64 -y && yum clean all -y

yum -y install wget git par2cmdline p7zip unrar unzip tar gcc python-feedparser python-configobj \
  && python-cheetah python-dbus python-devel libxslt-devel yum-utils \
  && yum clean all -y

groupmod -g 100 users && usermod -u 99 -g 100 nobody 

mkdir -p /config

wget http://download.sonarr.tv/v2/master/mono/NzbDrone.master.tar.gz -O /tmp/NzbDrone.master.tar.gz \
  && tar -xvf /tmp/NzbDrone.master.tar.gz -C /opt/ \
  && rm -f NzbDrone.master.tar.gz && mkdir /opt/sonarr && mkdir /opt/sonarr/bin && mv /opt/NzbDrone/* /opt/sonarr/bin \
  && rm -rf /opt/NzbDrone && chown -R nobody:users /opt/sonarr /config

systemctl enable sonarr.service