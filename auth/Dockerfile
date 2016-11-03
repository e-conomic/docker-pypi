FROM alpine:3.4
MAINTAINER osh@e-conomic.com

RUN mkdir /root/auth

VOLUME ["/root/auth"]

ADD htpasswd /root/auth

CMD [ "/bin/ash", "-c", "exit" ]
