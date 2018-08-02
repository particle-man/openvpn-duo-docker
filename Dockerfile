# Original credit: https://github.com/kylemanna/docker-openvpn

# Smallest base image
FROM ubuntu:latest

MAINTAINER Charles Brown <charlibr@cisco.com>

RUN apt-get update && \
    apt-get install -y openvpn gcc openssl curl make iptables && \
    curl -L https://github.com/duosecurity/duo_openvpn/tarball/master > /tmp/duo-openvpn.tgz && \
    cd /tmp && tar xvzf duo-openvpn.tgz && cd duosecurity-duo_openvpn* && make install && cd / && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/*
# Needed by scripts
ENV OPENVPN /etc/openvpn

VOLUME ["/etc/openvpn"]

# Internally uses port 1194/tcp, remap using `docker run -p 443:1194/udp`
EXPOSE 1194/tcp

CMD ["ovpn_run"]

ADD ./bin /usr/local/bin
RUN chmod a+x /usr/local/bin/*
