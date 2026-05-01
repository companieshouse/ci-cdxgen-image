ARG BUILD_VERSION="latest"
FROM 416670754337.dkr.ecr.eu-west-2.amazonaws.com/ci-corretto-build-21:${BUILD_VERSION}

ARG NVM_VERSION="0.39.5"
ARG NODE_VERSION="20.11.1"
ARG CDXGEN_VERSION="10.1.2"
ARG JQ_VERSION="1.7.1"
ARG FIND_VERSION="1:4.8.0"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN dnf upgrade -y \
    && dnf update -y \
    && dnf install -y \
         jq-${JQ_VERSION} \
         findutils-${FIND_VERSION} \
    \
    # Setting Up Node.js on Amazon Linux 2023
    # https://docs.aws.amazon.com/sdk-for-javascript/v2/developer-guide/setting-up-node-on-ec2-instance.html
    && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh | bash \
    && . ~/.nvm/nvm.sh \
    && nvm install ${NODE_VERSION} \
    && npm install -g @cyclonedx/cdxgen@${CDXGEN_VERSION} \
    && dnf clean all
