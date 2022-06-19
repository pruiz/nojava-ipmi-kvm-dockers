NAME   := pruiz/vkvm-dell
VER    ?= latest
JVM    ?= openjdk-7
BASE   ?= ${VER}-${JVM}
TAG    := $$(git log -1 --pretty=%h)
IMG    := ${NAME}:${TAG}
LATEST := ${NAME}:${BASE}

build:
	@docker build --build-arg "BASE=${BASE}" -t ${IMG} .
	@docker tag ${IMG} ${LATEST}

push:
	@docker push ${NAME}:${TAG}

login:
	@docker log -u ${DOCKER_USER} -p ${DOCKER_PASS}
