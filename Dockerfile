FROM alpine:3.4
MAINTAINER osh@e-conomic.com

RUN apk update && apk add --no-cache python3 && \
  pip3 install --no-cache-dir --disable-pip-version-check --upgrade pip && \
  pip3 install --no-cache-dir pypiserver passlib && \
  mkdir -p /srv/pypi

EXPOSE 80

VOLUME ["/srv/pypi"]

CMD ["pypi-server", \
  "--port", "80", \
  "--passwords", "/srv/pypi/.htpasswd", \
  "/srv/pypi"]
