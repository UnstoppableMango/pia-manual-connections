# syntax=docker/dockerfile:1
FROM ubuntu:26.04@sha256:da6fc2be547864451aa253836dd926da33623312df4a9a243e35dc877c378a78 AS base

RUN export DEBIAN_FRONTEND=noninteractive && \
	apt-get update && apt-get install -y git

# renovate: datasource=git-refs depName=https://github.com/pia-foss/manual-connections
ARG PIA_VERSION=645377e87238a52596c004f760d238e3faea68d1

WORKDIR /src
ADD https://github.com/pia-foss/manual-connections.git#${PIA_VERSION} .
COPY patches/*.patch /patches/
RUN git apply /patches/*.patch

FROM ubuntu:26.04@sha256:da6fc2be547864451aa253836dd926da33623312df4a9a243e35dc877c378a78 AS final

RUN export DEBIAN_FRONTEND=noninteractive && \
	apt-get update && apt-get install -y \
	curl jq wireguard-tools openvpn iproute2

WORKDIR /src
COPY --from=base /src ./
COPY entrypoint.sh .

VOLUME [ "/opt/piavpn-manual" ]

CMD [ "/src/entrypoint.sh" ]
