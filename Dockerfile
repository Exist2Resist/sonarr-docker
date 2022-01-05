FROM exist2resist/rhel8-systemd
LABEL maintainer="exist2resist@outlook.com"

ENV TZ='America/Edmonton' PUID=99 PGID=100

COPY ./sonarr.service /etc/systemd/system/sonarr.service
COPY ./install.sh /tmp/install.sh
RUN chmod +x /tmp/install.sh && ./tmp/install.sh && rm -f /tmp/install.sh

VOLUME ["/config","/mnt"]
EXPOSE 8989
CMD [ "/usr/local/bin/systemctl" ]
