FROM alpine:3.4
MAINTAINER osh@e-conomic.com

ADD auth-interact /root/auth-interact

RUN apk add --no-cache apache2-utils bash && \
  mkdir /root/auth

VOLUME ["/root/auth"]

ADD htpasswd /root/auth

ENTRYPOINT [ "/usr/bin/env", "sh", "-c", "exit" ]
