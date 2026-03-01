# syntax=docker/dockerfile:1
FROM ubuntu:noble-20260210.1@sha256:d1e2e92c075e5ca139d51a140fff46f84315c0fdce203eab2807c7e495eff4f9 AS base

RUN export DEBIAN_FRONTEND=noninteractive && \
	apt-get update && apt-get install -y git

# renovate: datasource=git-refs depName=https://github.com/pia-foss/manual-connections
ARG PIA_VERSION=a1412dbe2ca41edbb79c766bc475335cb6cb13ad

WORKDIR /src
ADD https://github.com/pia-foss/manual-connections.git#${PIA_VERSION} .
COPY patches/*.patch /patches/
RUN git apply /patches/*.patch

FROM ubuntu:noble-20260210.1@sha256:d1e2e92c075e5ca139d51a140fff46f84315c0fdce203eab2807c7e495eff4f9 AS final

RUN export DEBIAN_FRONTEND=noninteractive && \
	apt-get update && apt-get install -y \
	curl jq wireguard-tools openvpn iproute2

WORKDIR /src
COPY --from=base /src ./
COPY entrypoint.sh .

VOLUME [ "/opt/piavpn-manual" ]

CMD [ "/src/entrypoint.sh" ]
