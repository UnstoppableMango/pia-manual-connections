# syntax=docker/dockerfile:1
FROM ubuntu:noble-20250529@sha256:b59d21599a2b151e23eea5f6602f4af4d7d31c4e236d22bf0b62b86d2e386b8f AS base

RUN export DEBIAN_FRONTEND=noninteractive && \
	apt-get update && apt-get install -y git

# renovate: datasource=git-refs depName=https://github.com/pia-foss/manual-connections
ARG PIA_VERSION=e956c57849a38f912e654e0357f5ae456dfd1742

WORKDIR /src
ADD https://github.com/pia-foss/manual-connections.git#${PIA_VERSION} .
COPY patches/*.patch /patches/
RUN git apply /patches/*.patch

FROM ubuntu:noble-20250529@sha256:b59d21599a2b151e23eea5f6602f4af4d7d31c4e236d22bf0b62b86d2e386b8f AS final

RUN export DEBIAN_FRONTEND=noninteractive && \
	apt-get update && apt-get install -y \
	curl jq wireguard-tools openvpn iproute2

WORKDIR /src
COPY --from=base /src ./
COPY entrypoint.sh .

VOLUME [ "/opt/piavpn-manual" ]

CMD [ "/src/entrypoint.sh" ]
