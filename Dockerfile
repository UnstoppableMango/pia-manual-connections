# syntax=docker/dockerfile:1
FROM ubuntu:noble-20250404@sha256:1e622c5f073b4f6bfad6632f2616c7f59ef256e96fe78bf6a595d1dc4376ac02 AS base

RUN DEBIAN_FRONTEND=noninteractive \
	apt update && apt install -y git

# renovate: datasource=github-tags depName=pia-foss/manual-connections
ARG MC_VERSION=v2.0.0

WORKDIR /src
ADD https://github.com/pia-foss/manual-connections.git#${MC_VERSION} .
COPY patches/*.patch /patches/
RUN git apply /patches/*.patch

FROM ubuntu:noble-20250404@sha256:1e622c5f073b4f6bfad6632f2616c7f59ef256e96fe78bf6a595d1dc4376ac02

RUN DEBIAN_FRONTEND=noninteractive \
	apt update && apt install -y \
	curl jq wireguard-tools openvpn iproute2

WORKDIR /src
COPY --from=base /src ./
COPY entrypoint.sh .

CMD [ "/src/entrypoint.sh" ]
