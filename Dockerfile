FROM debian:11


RUN wget -O- https://deb.kamailio.org/kamailiodebkey.gpg | sudo apt-key add - && \
    echo 'deb http://deb.kamailio.org/kamailio bullseye main' >> /etc/apt/sources.list && \
    echo 'deb-src http://deb.kamailio.org/kamailio bullseye main' >> /etc/apt/sources.listt && \
    apt-get update && apt-get install -y kamailio && apt-get install -y kamailio-lua-modules kamailio-outbound-modules kamailio-websocket-modules kamailio-tls-modules kamailio-utils-modules


EXPOSE 5060/udp 5061/tcp 5062/tcp

ENTRYPOINT ["kamailio","-DDE"]