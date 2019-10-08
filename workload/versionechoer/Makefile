# Switch default shell to be bash
SHELL=/bin/bash


# Parameters - defaulted
DOCKERHUB_REPO_NAME ?= ${USER}
IMAGE_NAME ?= versionechoer
VERSION ?= $(shell cat VERSION)


# Derived or calculated
FULL_IMAGE_NAME = ${DOCKERHUB_REPO_NAME}/${IMAGE_NAME}
FULL_IMAGE_NAME_AND_TAG = ${FULL_IMAGE_NAME}:${VERSION}


build:
	@# Fast build - so we can run without having to wait for full static build
	go build -ldflags "-X main.version=${VERSION}" .


build-image:
	@docker image build \
                --build-arg VERSION=${VERSION} \
                --pull \
                --tag ${FULL_IMAGE_NAME_AND_TAG} \
                .


# Assumes you have logged in to dockerhub
push-image:
	@docker image push ${FULL_IMAGE_NAME_AND_TAG}
