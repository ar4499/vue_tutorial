FROM oven/bun:1.2-slim as development

ARG HOST_UID=1000
ARG HOST_GID=1000
ARG HOST_USER=user
ARG HOST_GROUP=user
ARG NODE_ENV=development
ARG TZ='Etc/UTC'

ENV TZ=$TZ

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    software-properties-common \
    sudo \
    tzdata \
    wget \
    curl \
    git \
    unzip \
    vim \
    openssl \
    bash && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    groupmod -g ${HOST_GID} -n ${HOST_GROUP} bun && \
    usermod -u ${HOST_UID} -g ${HOST_GID} -l ${HOST_USER} -md /home/${HOST_USER} -s /bin/zsh bun && \
    chown -R ${HOST_USER}:${HOST_GROUP} /home/${HOST_USER} && \
    echo ${TZ} > /etc/timezone && \
    ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime 

WORKDIR /home/${HOST_USER}
USER ${HOST_USER}

WORKDIR "/home/${HOST_USER}/app"

COPY --chown=${HOST_USER}:${HOST_GROUP} package.json .
COPY --chown=$HOST_USER:$HOST_GROUP bun.lock .

RUN if [ "${NODE_ENV}" = "production" ]; then \
    bun install --force --production --frozen-lockfile; \
    else \
    bun install; \
    fi && bun pm cache rm

