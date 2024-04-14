FROM node:20
# FROM ubuntu:18.04

LABEL version="1.0.0"
LABEL repository="https://github.com/sma11black/hexo-action"
LABEL homepage="https://sma11black.github.io"
LABEL maintainer="sma11black <smallblack@outlook.com>"

COPY entrypoint.sh /entrypoint.sh

RUN apk add --no-cache git openssh > /dev/null ; \
    chmod +x /entrypoint.sh

# RUN apt-get update \
#     && apt-get install -y --no-install-recommends curl git openssh-client \
#     && curl -sL https://deb.nodesource.com/setup_13.x | bash - \
#     && apt update \
#     && apt install -y nodejs npm \
#     && node --version \
#     && nodejs --version \
#     && rm -rf /var/lib/apt/lists/* \
#     && chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]