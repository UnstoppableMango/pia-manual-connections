_ != mkdir -p .make
PROJECT := unstoppablemango/pia-manual-connections
IMG     := ${PROJECT}:v0.0.1-alpha

GO     ?= go
DEVCTL ?= $(GO) tool devctl
DOCKER ?= docker
GINKGO ?= $(GO) tool ginkgo

GO_SRC ?= $(shell find . -name '*.go' -printf '%P\n')

build: result
docker: .make/docker-build
test: .make/go-test
tidy: go.sum

load: bin/stream-image.sh
	$< | $(DOCKER) load

check:
	nix flake check

update:
	nix flake update

.PHONY: result
result:
	nix build

bin/stream-image.sh: $(wildcard nix/*) $(wildcard patches/*.patch) flake.nix entrypoint.sh
	nix build .#ctr --out-link $@

go.sum: go.mod ${GO_SRC}
	$(GO) mod tidy

.make/docker-build: Dockerfile .dockerignore entrypoint.sh
	$(DOCKER) build -f $< . -t ${IMG}
	@touch $@

.make/go-test: go.mod ${GO_SRC} Dockerfile
	$(GINKGO)
