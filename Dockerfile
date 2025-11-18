FROM debian:11

ENV KAMAILIO_VERSION=5.7
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    git \
    make \
    bison \
    flex \
    pkg-config \
    lua5.1 \
    liblua5.1-0-dev \
    libssl-dev \
    libcurl4-openssl-dev \
    libxml2-dev \
    libpcre3-dev \
    libmariadb-dev \
    libpq-dev \
    libhiredis-dev \
    libmemcached-dev \
    libjson-c-dev \
    libevent-dev \
    libncurses5-dev \
    libunistring-dev \
    wget \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN cd /usr/src && \
    git clone --depth 1 --branch ${KAMAILIO_VERSION} https://github.com/kamailio/kamailio.git && \
    cd kamailio && \
    make FLAVOUR=kamailio \
         include_modules="app_lua http_client websocket tls xhttp_prom jsonrpcs" \
         cfg prefix=/usr cfg-dir=/etc/kamailio/ && \
    make all && \
    make install && \
    ldconfig && \
    cd / && rm -rf /usr/src/kamailio

# 必要目录
RUN mkdir -p /etc/kamailio /var/run/kamailio

# 清理构建依赖
RUN apt-get purge -y --auto-remove \
    gcc g++ make bison flex wget git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 5060/udp 5061/tcp 5062/tcp

ENTRYPOINT ["kamailio","-DD","-E","-m","512","-M","8","-f","/etc/kamailio/kamailio.cfg"]
