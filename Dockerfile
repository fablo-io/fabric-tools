FROM ubuntu:22.04

ARG TARGETARCH
ARG TARGETOS
ARG FABRIC_VERSION

ENV ARCH=${TARGETARCH}
ENV PLATFORM=${TARGETOS}
ENV BINARY_FILE=hyperledger-fabric-${TARGETOS}-${TARGETARCH}-${FABRIC_VERSION}.tar.gz

RUN apt update && apt install -y \
    bash \
    curl \
    jq \
    tzdata

RUN mkdir -p /etc/hyperledger/fabric /var/hyperledger

RUN set -x && \
    if [ -z "$ARCH" ] || [ -z "$PLATFORM" ]; then \
        echo "ARCH and PLATFORM must be provided as build arguments"; exit 1; \
    fi && \
    echo "Downloading $BINARY_FILE" && \
    curl -sSL https://github.com/hyperledger/fabric/releases/download/v${FABRIC_VERSION}/${BINARY_FILE} | tar xz --strip-components=1 -C /usr/local/bin

ENV FABRIC_CFG_PATH=/etc/hyperledger/fabric
ENV FABRIC_VER=${FABRIC_VERSION}

COPY core.yaml    ${FABRIC_CFG_PATH}/core.yaml

VOLUME /etc/hyperledger/fabric
VOLUME /var/hyperledger