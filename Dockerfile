FROM alpine:3.4
MAINTAINER osh@e-conomic.com

RUN apk add --no-cache python3 && \
  pip3 install --no-cache-dir --disable-pip-version-check --upgrade pip && \
  pip3 install --no-cache-dir pypiserver passlib && \
  mkdir -p /srv/pypi && mkdir -p /root/auth

# bcrypt requires a couple more guns to install
RUN apk add --no-cache g++ python3-dev libffi-dev && \
  pip3 install --no-cache-dir bcrypt && \
  apk del g++ python3-dev libffi-dev

EXPOSE 80

# PyPI volume, should be mounted read-write.
VOLUME ["/srv/pypi"]

# PyPI auth volume, should be mounted read-only.
VOLUME ["/root/auth"]

CMD ["pypi-server", \
  "--port", "80", \
  "--passwords", "/root/auth/htpasswd", \
  "/srv/pypi"]
