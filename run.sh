#!/bin/bash
# docker run -it --name=test -p 8080:80 -p 4443:443 debian /bin/bash
# https://xuweizhan.github.io/config/run.sh
# curl -L -o /home https://xuweizhan.github.io/config/run.sh
# git clone https://github.com/xuweizhan/config.git
V2RAYCONFIG="/v2ray/config.json"
CADDYFILE="/v2ray/Caddyfile"

# 调用报错
function warn() {
  echo -e "\033[31m$1\033[0m$2"
}

# 前置条件
action() {
    apt update
    apt-get install curl -y
}

# 安装v2ray，并修改配置
getV2ray() {
    curl -L -o /tmp/go.sh https://install.direct/go.sh
    chmod +x /tmp/go.sh
    /tmp/go.sh
    # 生成UUID
    UUID=/proc/sys/kernel/random/uuid
    # 生成配置文件
    cat >$V2RAYCONFIG <<EOF
    {
        "inbounds": [
            {
            "port": 36384,
            "listen": "127.0.0.1",
            "protocol": "vmess",
            "settings": {
            "clients": [
                {
EOF
    echo "\"id\": \"$UUID\"," >>$V2RAYCONFIG
    cat >>$V2RAYCONFIG <<EOF
                "alterId": 64
                }
            ]
            },
            "streamSettings": {
            "network": "ws",
                "wsSettings": {
                "path": "/update"
                }
            }
            }
        ],
        "outbounds": [
            {
            "protocol": "freedom",
            "settings": {}
            }
        ]
    }
EOF
    v2ray -config=$V2RAYCONFIG
    warn `cat data/uuid`
}

# 安装Caddy
getCaddy() {
    curl -o caddy.tar.gz 'https://caddyserver.com/download/linux/amd64?license=personal&telemetry=off'
    tar -zxvf caddy.tar.gz caddy
    chmod +x ./caddy
    echo "请输入domain"
    read DOMAIN
    $DOMAIN >$CADDYFILE
    cat >>$CADDYFILE <<EOF
    {
        log ./data/caddy.log
        errors ./data/caddy.error.log
        proxy /update localhost:36384 {
            websocket
            header_upstream -Origin
        }
    }
EOF
    echo "请输入mail"
    read MAIL
    # 读取域名和email
    caddy -conf=$CADDYFILE -email=$MAIL -agree
}

main() {
    # 更新系统
    action
    # 安装v2ray
    getV2ray
    # 安装Caddy
    getCaddy
}

main