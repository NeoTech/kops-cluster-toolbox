FROM alpine:latest

ARG AWSCLI_VERSION=1.16.193
ARG KOPS_VERSION=1.11.1
ARG TERRAFORM_VERSION=0.12.8
ARG KUBECTL_VERSION=v1.14.0
ARG HELM_VERSION=v2.14.3

RUN  apk add --update --no-cache bash python jq ca-certificates groff less \
  && apk add --update --no-cache --virtual build-deps py-pip curl \
  && pip install --upgrade --no-cache-dir awscli==$AWSCLI_VERSION

RUN  curl -sLo /usr/local/bin/kops https://github.com/kubernetes/kops/releases/download/${KOPS_VERSION}/kops-linux-amd64 \
  && curl -sLo /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
  && curl -LSs https://storage.googleapis.com/kubernetes-helm/helm-${HELM_VERSION}-linux-amd64.tar.gz | tar zx && mv linux-amd64/helm /usr/local/bin/helm \
  && curl -sLo /tmp/${TERRAFORM_VERSION}.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && unzip /tmp/${TERRAFORM_VERSION}.zip -d  /usr/local/bin/ \
  && chmod +x /usr/local/bin/kops /usr/local/bin/kubectl /usr/local/bin/terraform /usr/local/bin/helm

RUN  apk del --purge build-deps \
  && rm -f /var/cache/apk/* \
  && rm -rf linux-amd64/ \
  && rm -f /tmp/${TERRAFORM_VERSION}.zip

WORKDIR /apps
