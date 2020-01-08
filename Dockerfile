# 来源
FROM debian:latest as builder
# 作者
LABEL maintainer "007@gmail.com"
# 指定域名
ENV Domain ""

# v2ray
RUN apt update
RUN apt install curl -y
RUN curl -L -o /tmp/go.sh https://install.direct/go.sh
RUN chmod +x /tmp/go.sh
RUN /tmp/go.sh



# 执行判断脚本， 更新配置文件
RUN curl -L -o /tmp/env.sh https://xuweizhan.github.io/config/env.sh
RUN chmod +x /tmp/env.sh
RUN /tmp/env.sh


# 拷贝配置文件
# COPY --from=builder /usr/bin/v2ray/v2ray /usr/bin/v2ray/
# COPY --from=builder /usr/bin/v2ray/v2ctl /usr/bin/v2ray/
# COPY --from=builder /usr/bin/v2ray/geoip.dat /usr/bin/v2ray/
# COPY --from=builder /usr/bin/v2ray/geosite.dat /usr/bin/v2ray/
# COPY config.json /etc/v2ray/config.json

# 证书
# RUN set -ex && \
#     apk --no-cache add ca-certificates && \
#     mkdir /var/log/v2ray/ &&\
#     chmod +x /usr/bin/v2ray/v2ctl && \
#     chmod +x /usr/bin/v2ray/v2ray


ENV PATH /usr/bin/v2ray:$PATH
