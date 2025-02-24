FROM alpine:3.19.0

RUN apk upgrade --no-cache && apk add --no-cache perl perl-io-socket-ssl curl
COPY ddclient /usr/sbin/ddclient
COPY entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]