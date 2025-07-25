FROM debian:11 AS builder

ENV KAM_VERSION=5.6.4

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      git build-essential bison flex pkg-config \
      libssl-dev libcurl4-openssl-dev libpcre3-dev libxml2-dev \
      liblua5.3-dev libunistring-dev libevent-dev libev-dev \
      libmicrohttpd-dev libwebsockets-dev libsctp-dev \
      libjansson-dev ca-certificates && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src
RUN git clone --depth 1 --branch ${KAM_VERSION} https://github.com/kamailio/kamailio.git

WORKDIR /usr/src/kamailio
RUN make cfg include_modules="app_lua ndb_lua outbound websocket tls utils" && \
    make -j$(nproc) && \
    make install

ENV PATH="/usr/local/sbin:/usr/local/bin:${PATH}"
ENV KAMAILIO_CFG=/usr/local/etc/kamailio/kamailio.cfg

EXPOSE 5060/udp 5061/tcp 5062/tcp
ENTRYPOINT ["kamailio","-m","512","-M","8","-D","-E"]
