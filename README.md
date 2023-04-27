# kamailio版本

## 容器说明
### 文件挂载
生产环境运行时，一般挂载3个文件即可
#### kamailio.cfg 
这是kamailio运行的必要配置文件，容器内的目录必须是/etc/kamailio/kamailio.cfg
#### wss所需的证书文件
证书文件在容器内的目录，主要是根据kamailio.cfg配置文件来决定的，推荐在/etc/kamailio/目录 

### 端口说明
容器可用5060/udp 5061/tcp 5062/tcp三个端口，也可直接使用host模式

### 日志收集
kamailio.cfg配置文件设置log_stderror=yes，即可通过docker logs查看kamailio日志

### 启动
```
docker run -itd --network=host --name kamailio \
    -v ./kamailio.cfg:/etc/kamailio/kamailio.cfg \
    -v ./r.lua:/etc/kamailio/r.lua \
    -v ./domain.pem:/etc/kamailio/domain.pem \
    -v ./domain.key:/etc/kamailio/domain.key \
    xsdhy/kamailio:main
```
