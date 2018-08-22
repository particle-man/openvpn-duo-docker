FROM ubuntu:18.04 as builder
LABEL maintainer="Charles Brown <charlibr@cisco.com>"
LABEL description="Ubuntu based openvpn enhanced with Duo MFA auth support"
LABEL upstream="https://github.com/kylemanna/docker-openvpn"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get -y upgrade 
RUN apt-get install -y gcc openssl make python git

WORKDIR /tmp/git-clone
RUN git clone --single-branch -b 2.2 https://github.com/duosecurity/duo_openvpn.git

WORKDIR /tmp/git-clone/duo_openvpn
RUN make install 

COPY bin /tmp/bin
RUN chmod -R 0755 /tmp/bin

FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -y upgrade && apt-get install -y openvpn openssl iptables python && apt-get -y autoremove && apt-get clean

COPY --from=builder /opt/duo /opt/duo/
COPY --from=builder /tmp/bin /usr/local/bin/

# Needed by scripts
ENV OPENVPN /etc/openvpn
VOLUME ["/etc/openvpn"]

EXPOSE 1194
CMD ["ovpn_run"]
