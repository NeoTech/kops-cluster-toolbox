# Switch default shell to be bash
SHELL=/bin/bash


# Parameters - defaulted
DOCKERHUB_USER ?= ${USER}
IMAGE_NAME ?= versionechoer
VERSION ?= $(shell cat VERSION)


# Derived or calculated
IMAGE_REPO_NAME = ${DOCKERHUB_USER}/${IMAGE_NAME}
RELEASE_NAME = ${IMAGE_NAME}
TAGGED_IMAGE = ${IMAGE_REPO}:${VERSION}


# Image targets
build:
	@# Fast build - so we can run without having to wait for full static build
	go build -ldflags "-X main.version=${VERSION}" .


build-image:
	@docker image build \
                --build-arg VERSION=${VERSION} \
                --pull \
                --tag ${TAGGED_IMAGE} \
                .


push-image:
	@# Assumes you have logged in to dockerhub
	@docker image push ${TAGGED_IMAGE}


# Helm chart targets
render-chart:
	@helm template --name ${RELEASE_NAME} --set image.tag=${VERSION} ./helm
