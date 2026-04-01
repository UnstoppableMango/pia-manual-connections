# syntax=docker/dockerfile:1
FROM ubuntu:noble-20260217@sha256:186072bba1b2f436cbb91ef2567abca677337cfc786c86e107d25b7072feef0c AS base

RUN export DEBIAN_FRONTEND=noninteractive && \
	apt-get update && apt-get install -y git

# renovate: datasource=git-refs depName=https://github.com/pia-foss/manual-connections
ARG PIA_VERSION=a1412dbe2ca41edbb79c766bc475335cb6cb13ad

WORKDIR /src
ADD https://github.com/pia-foss/manual-connections.git#${PIA_VERSION} .
COPY patches/*.patch /patches/
RUN git apply /patches/*.patch

FROM ubuntu:noble-20260217@sha256:186072bba1b2f436cbb91ef2567abca677337cfc786c86e107d25b7072feef0c AS final

RUN export DEBIAN_FRONTEND=noninteractive && \
	apt-get update && apt-get install -y \
	curl jq wireguard-tools openvpn iproute2

WORKDIR /src
COPY --from=base /src ./
COPY entrypoint.sh .

VOLUME [ "/opt/piavpn-manual" ]

CMD [ "/src/entrypoint.sh" ]
