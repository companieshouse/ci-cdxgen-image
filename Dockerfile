ARG BUILD_VERSION="latest"
FROM 416670754337.dkr.ecr.eu-west-2.amazonaws.com/ci-corretto-build-21:${BUILD_VERSION}

ARG NODE_MAJOR_VERSION="24"
ARG NODE_FULL_VERSION="24.15.0"
ARG CDXGEN_VERSION="12.3.3"
ARG JQ_VERSION="1.7.1"
ARG FIND_VERSION="1:4.8.0"
ARG GO_VERSION="1.25.9"
ARG CDXGEN_USER="cdxgen_user"


SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN dnf upgrade -y \
    && dnf install -y \
         jq-${JQ_VERSION} \
         findutils-${FIND_VERSION} \
    && useradd -m -s /bin/bash ${CDXGEN_USER} \
    && curl -LO https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz \
    && rm go${GO_VERSION}.linux-amd64.tar.gz \
    && rm -rf /usr/local/go/doc \
              /usr/local/go/test \
              /usr/local/go/api \
              /usr/local/go/misc \
    && curl -fsSL https://rpm.nodesource.com/setup_${NODE_MAJOR_VERSION}.x | bash - \
    && dnf install -y nodejs-${NODE_FULL_VERSION} \
    && npm install -g @cyclonedx/cdxgen@${CDXGEN_VERSION} \
    && dnf clean all

USER ${CDXGEN_USER}
WORKDIR /home/${CDXGEN_USER}

ENV PATH="/usr/local/go/bin:${PATH}"
