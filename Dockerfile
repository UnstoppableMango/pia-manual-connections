# syntax=docker/dockerfile:1
FROM ubuntu:26.04@sha256:5e275723f82c67e387ba9e3c24baa0abdcb268917f276a0561c97bef9450d0b4 AS base

RUN export DEBIAN_FRONTEND=noninteractive && \
	apt-get update && apt-get install -y git

# renovate: datasource=git-refs depName=https://github.com/pia-foss/manual-connections
ARG PIA_VERSION=a1412dbe2ca41edbb79c766bc475335cb6cb13ad

WORKDIR /src
ADD https://github.com/pia-foss/manual-connections.git#${PIA_VERSION} .
COPY patches/*.patch /patches/
RUN git apply /patches/*.patch

FROM ubuntu:26.04@sha256:5e275723f82c67e387ba9e3c24baa0abdcb268917f276a0561c97bef9450d0b4 AS final

RUN export DEBIAN_FRONTEND=noninteractive && \
	apt-get update && apt-get install -y \
	curl jq wireguard-tools openvpn iproute2

WORKDIR /src
COPY --from=base /src ./
COPY entrypoint.sh .

VOLUME [ "/opt/piavpn-manual" ]

CMD [ "/src/entrypoint.sh" ]
