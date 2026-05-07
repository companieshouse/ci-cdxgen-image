ARG BUILD_VERSION="latest"
FROM 416670754337.dkr.ecr.eu-west-2.amazonaws.com/ci-corretto-build-21:${BUILD_VERSION}

ARG NVM_VERSION="0.40.4"
ARG NODE_VERSION="24.15.0"
ARG CDXGEN_VERSION="12.3.3"
ARG JQ_VERSION="1.7.1"
ARG FIND_VERSION="1:4.8.0"
ARG GO_VERSION="1.25.9"


SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN dnf upgrade -y \
    && dnf install -y \
         jq-${JQ_VERSION} \
         findutils-${FIND_VERSION} \
    && useradd -m -s /bin/bash appuser \
    && curl -LO https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz \
    && rm go${GO_VERSION}.linux-amd64.tar.gz \
    && rm -rf /usr/local/go/doc \
              /usr/local/go/test \
              /usr/local/go/api \
              /usr/local/go/misc \
    \
    # Setting Up Node.js on Amazon Linux 2023
    # https://docs.aws.amazon.com/sdk-for-javascript/v2/developer-guide/setting-up-node-on-ec2-instance.html
    && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh | bash \
    && . ~/.nvm/nvm.sh \
    && nvm install ${NODE_VERSION} \
    && nvm use ${NODE_VERSION} \
    && npm install -g @cyclonedx/cdxgen@${CDXGEN_VERSION} \
    && dnf clean all

ENV PATH="/usr/local/go/bin:${PATH}"
