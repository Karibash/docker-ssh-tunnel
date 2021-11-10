FROM alpine

RUN apk add --update bash autossh \
 && rm -rf /var/cache/apk/*

COPY run.sh /
RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]
