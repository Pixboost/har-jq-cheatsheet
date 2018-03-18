FROM alpine:3.7

RUN apk add --no-cache nodejs jq chromium bash
RUN npm install -g chrome-har-capturer

COPY entrypoint.sh /
COPY har-stat.sh /

ENTRYPOINT ["/entrypoint.sh"]