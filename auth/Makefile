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
	  --volume pypi-auth:/root/auth:rw \
	  e-conomic/docker-pypi-auth

interact: build
	docker run -i \
	  --rm \
	  --name pypi-auth \
	  --hostname e-conomic-pypi-auth \
	  --volume pypi-auth:/root/auth:rw \
		--entrypoint="/root/auth-interact" \
	  e-conomic/docker-pypi-auth

clean:
	docker volume rm pypi-auth
