NAME   := pruiz/vkvm-sm
VER    ?= latest
TAG    := $$(git log -1 --pretty=%h)
IMG    := ${NAME}:${TAG}
LATEST := ${NAME}:${VER}

build:
	@docker build -t ${IMG} .
	@docker tag ${IMG} ${LATEST}

push:
	@docker push ${NAME}:${TAG}

login:
	@docker log -u ${DOCKER_USER} -p ${DOCKER_PASS}
