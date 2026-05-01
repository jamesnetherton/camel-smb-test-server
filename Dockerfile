FROM fedora:44 as samba

LABEL org.opencontainers.image.title="SMB Test Server" \
      org.opencontainers.image.description="SMB/CIFS server for testing purposes only - NOT FOR PRODUCTION" \
      org.opencontainers.image.authors="Apache Camel" \
      org.opencontainers.image.documentation="https://github.com/jamesnetherton/camel-smb-test-server"

ENV SAMBA_ROOT=/opt/camel/samba

EXPOSE 139 445

ADD smb.conf /etc/samba/smb.conf
ADD start.sh /usr/local/bin

RUN dnf install -y --setopt=tsflags=nodocs --setopt=install_weak_deps=False samba procps-ng && \
    mkdir -p /data/rw /data/ro && \
    chmod +x /usr/local/bin/start.sh && \
    dnf clean all

CMD /usr/local/bin/start.sh
