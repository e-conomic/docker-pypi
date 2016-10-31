FROM alpine:3.4
MAINTAINER osh@e-conomic.com

RUN apk add --no-cache python3 && \
  pip3 install --no-cache-dir --disable-pip-version-check --upgrade pip && \
  pip3 install --no-cache-dir pypiserver passlib && \
  mkdir -p /srv/pypi

# bcrypt requires a couple more guns to install
RUN apk add --no-cache g++ python3-dev libffi-dev && \
  pip3 install --no-cache-dir bcrypt && \
  apk del g++ python3-dev libffi-dev

EXPOSE 80

COPY .htpasswd /root/.htpasswd

VOLUME ["/srv/pypi"]

CMD ["pypi-server", \
  "--port", "80", \
  "--passwords", "/root/.htpasswd", \
  "/srv/pypi"]
