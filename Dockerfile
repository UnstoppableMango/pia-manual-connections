# syntax=docker/dockerfile:1
FROM ubuntu:noble-20250404@sha256:1e622c5f073b4f6bfad6632f2616c7f59ef256e96fe78bf6a595d1dc4376ac02

# renovate: datasource=github-tags depName=pia-foss/manual-connections
ARG MC_VERSION=v2.0.0

WORKDIR /src
ADD https://github.com/pia-foss/manual-connections.git#${MC_VERSION} .
COPY entrypoint.sh .

CMD [ "/src/entrypoint.sh" ]
