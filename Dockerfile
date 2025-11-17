FROM debian:11

# 设置环境变量
ENV KAMAILIO_VERSION=5.7
ENV DEBIAN_FRONTEND=noninteractive

# 安装编译依赖和运行时依赖
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    make \
    bison \
    flex \
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
    lua5.1 \
    liblua5.1-0-dev \
    wget \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# 下载并编译 Kamailio
RUN cd /usr/src && \
    wget https://www.kamailio.org/pub/kamailio/${KAMAILIO_VERSION}/src/kamailio-${KAMAILIO_VERSION}_src.tar.gz && \
    tar -xzf kamailio-${KAMAILIO_VERSION}_src.tar.gz && \
    cd kamailio-${KAMAILIO_VERSION} && \
    make FLAVOUR=kamailio \
         include_modules="app_lua websocket tls auth outbound nathelper http_client utils" \
         cfg prefix=/usr \
         cfg-dir=/etc/kamailio/ \
         bin-dir=/usr/sbin/ \
         modules-dir=/usr/lib/x86_64-linux-gnu/kamailio/modules/ && \
    make all && \
    make install && \
    cd / && \
    rm -rf /usr/src/kamailio-*

# 创建必要的目录
RUN mkdir -p /etc/kamailio && \
    mkdir -p /var/run/kamailio

# 清理
RUN apt-get purge -y --auto-remove \
    gcc g++ make bison flex wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 5060/udp 5061/tcp 5062/tcp

ENTRYPOINT ["kamailio","-DDE","-m","512","-M","8"]