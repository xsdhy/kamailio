# ---- 基础镜像 ----
  FROM debian:11

  # ---- 安装 Kamailio 5.6.4 与指定模块 ----
  RUN set -eux; \
      # 基础工具
      apt-get update && \
      apt-get install -y --no-install-recommends ca-certificates gnupg wget ; \
      \
      # 导入官方 GPG key（新方式，存放在 /usr/share/keyrings）
      wget -qO /usr/share/keyrings/kamailio.gpg https://deb.kamailio.org/kamailiodebkey.gpg ; \
      \
      # 启用 5.6 分支仓库
      echo "deb [signed-by=/usr/share/keyrings/kamailio.gpg] http://deb.kamailio.org/kamailio56 bullseye main" \
          > /etc/apt/sources.list.d/kamailio56.list ; \
      \
      # 安装核心与模块（全部锁定到 5.6.4）
      apt-get update && \
      apt-get install -y --no-install-recommends \
          kamailio=5.6.4* \
          kamailio-lua-modules=5.6.4* \
          kamailio-outbound-modules=5.6.4* \
          kamailio-websocket-modules=5.6.4* \
          kamailio-tls-modules=5.6.4* \
          kamailio-utils-modules=5.6.4* ; \
      \
      # 镜像瘦身
      apt-get clean && \
      rm -rf /var/lib/apt/lists/*
  
  # ---- 运行配置 ----
  EXPOSE 5060/udp 5061/tcp 5062/tcp
  
  ENTRYPOINT ["kamailio", "-m", "512", "-M", "4096", "-D", "-E"]