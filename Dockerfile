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

# 安装 git
RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

# 从 GitHub 克隆并编译 Kamailio
RUN cd /usr/src && \
    git clone --depth 1 --branch ${KAMAILIO_VERSION} https://github.com/kamailio/kamailio.git kamailio && \
    cd kamailio && \
    make cfg prefix=/usr cfg-dir=/etc/kamailio/ && \
    make all && \
    make install && \
    echo "=========== 查找模块安装位置 ===========" && \
    find /usr -name "*.so" -path "*/kamailio/modules/*" 2>/dev/null | head -5 && \
    echo "=========== 验证关键模块 ===========" && \
    find /usr -name "outbound.so" -o -name "websocket.so" -o -name "app_lua.so" 2>/dev/null && \
    cd / && \
    rm -rf /usr/src/kamailio

# 创建必要的目录
RUN mkdir -p /etc/kamailio && \
    mkdir -p /var/run/kamailio

# 清理
RUN apt-get purge -y --auto-remove \
    gcc g++ make bison flex wget git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 5060/udp 5061/tcp 5062/tcp

ENTRYPOINT ["kamailio","-DDE","-m","512","-M","8"]