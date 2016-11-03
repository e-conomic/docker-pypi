.PHONY: all build run clean

all: build

build:
	docker build \
	  --tag e-conomic/docker-pypi-auth \
	  .

run: build
	docker run -i \
	  --rm \
	  --name pypi-auth \
	  --hostname e-conomic-pypi-auth \
	  --volume pypi-auth:/root:rw \
	  e-conomic/docker-pypi-auth

clean:
	docker volume rm pypi-auth
