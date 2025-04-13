_ != mkdir -p .make
PROJECT := unstoppablemango/pia-manual-connections
IMG     := ${PROJECT}:v0.0.1-alpha

DEVCTL := go tool devctl
GINKGO := go tool ginkgo

GO_SRC != $(DEVCTL) list --go

docker: .make/docker-build
test: .make/go-test
tidy: go.sum

go.sum: go.mod ${GO_SRC}
	go mod tidy

.make/docker-build: Dockerfile .dockerignore entrypoint.sh
	docker build -f $< . -t ${IMG}
	@touch $@

.make/go-test: go.mod ${GO_SRC} Dockerfile
	$(GINKGO)
