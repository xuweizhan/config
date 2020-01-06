#!/bin/bash
# 判断是否指定了domain来进行config配置
if [ ! $DOMAIN ]; then
echo "未设置环境变量domain[DOMAIN]，无法进行https安装，将只安装V2ray"
# 获取nginx配置
# curl -L -o /etc/nginx/sites-available/default https://xuweizhan.github.io/config/default_http.conf
else
echo "NOT NULL"
# ------------安装 nginx----------
# nginx
apt install nginx
# 删除原本配置
rm -f /etc/nginx/sites-available/default
# 更新nginx配置
curl -L -o /etc/nginx/sites-available/default https://xuweizhan.github.io/config/default_https.conf

# ----------https 签发证书-----------
# 安装依赖
apt-get -y install netcat
# 下载并执行acme脚本
curl -L -o /tmp/acme.sh https://get.acme.sh
chmod +x /tmp/acme.sh
/tmp/acme.sh
# 保存变量
source ~/.bashrc
# 签发证书
~/.acme.sh/acme.sh --issue -d ${DOMAIN} --standalone -k ec-256
# 安装证书
~/.acme.sh/acme.sh --installcert -d ${DOMAIN} --fullchainpath /etc/v2ray/v2ray.crt --keypath /etc/v2ray/v2ray.key --ecc

# ---------更新v2ray config-------


# -----------启动nginx------------
nginx


fi
