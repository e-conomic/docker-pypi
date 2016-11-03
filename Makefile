.PHONY: all build run clean

all: build

build:
	make -C auth build
	docker build \
	  --tag e-conomic/docker-pypi \
	  .

run: build
	make -C auth run
	docker run -i \
	  --rm \
	  --publish 8080:80 \
	  --name pypi \
	  --hostname e-conomic-pypi \
	  --volume pypi:/srv/pypi:rw \
	  --volume pypi-auth:/root/auth:ro \
	  e-conomic/docker-pypi

clean:
	make -C auth clean
	docker volume rm pypi
