FROM debian:11


RUN apt-get update && apt-get install -y wget gnupg && \
    wget -O - https://deb.kamailio.org/kamailiodebkey.gpg | apt-key add - && \
    echo 'deb http://deb.kamailio.org/kamailio bullseye main' >> /etc/apt/sources.list && \
    echo 'deb-src http://deb.kamailio.org/kamailio bullseye main' >> /etc/apt/sources.list && \
    apt-get update && apt-get install -y kamailio  && \
    apt-get install -y kamailio-lua-modules kamailio-outbound-modules kamailio-websocket-modules kamailio-tls-modules kamailio-utils-modules


EXPOSE 5060/udp 5061/tcp 5062/tcp

ENTRYPOINT ["kamailio","-DDE"]