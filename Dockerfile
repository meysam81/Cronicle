FROM oven/bun:1-alpine AS builder

WORKDIR /opt/cronicle

RUN apk add --no-cache \
    bash \
    curl \
    git \
    python3 \
    make \
    g++

COPY package.json ./
RUN bun install --production

COPY . .

RUN bun run bin/build.js dist

FROM oven/bun:1-alpine

WORKDIR /opt/cronicle

RUN apk add --no-cache \
    bash \
    curl \
    procps

COPY --from=builder /opt/cronicle /opt/cronicle

RUN mkdir -p logs data plugins && \
    chmod 755 logs data plugins

EXPOSE 3012

ENV CRONICLE_foreground=1
ENV CRONICLE_echo=1
ENV CRONICLE_color=1
ENV NODE_ENV=production

VOLUME ["/opt/cronicle/logs", "/opt/cronicle/data", "/opt/cronicle/plugins"]

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
