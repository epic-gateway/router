REPO ?= quay.io/epic-gateway
PREFIX ?= router
SUFFIX ?= ${USER}-dev

# Image URL to use all building/pushing image targets
IMG ?= ${REPO}/${PREFIX}:${SUFFIX}

# Get the currently used golang install path (in GOPATH/bin, unless GOBIN is set)
ifeq (,$(shell go env GOBIN))
GOBIN=$(shell go env GOPATH)/bin
else
GOBIN=$(shell go env GOBIN)
endif

##@ Default Goal
.PHONY: help
help: ## Display this help
	@echo "Usage:"
	@echo "  make <goal> [VAR=value ...]"
	@echo ""
	@echo "Variables"
	@echo "  REPO   The registry part of the Docker tag"
	@echo "  PREFIX Docker tag prefix (after the registry, before the suffix)"
	@echo "  SUFFIX Docker tag suffix (the part after ':')"
	@awk 'BEGIN {FS = ":.*##"}; \
		/^[a-zA-Z0-9_-]+:.*?##/ { printf "  %-15s %s\n", $$1, $$2 } \
		/^##@/ { printf "\n%s\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Development Goals

image-build:	## Build the Docker image
	docker build --tag=${IMG} ${DOCKER_BUILD_OPTIONS} .

image-push:	## Push the image to the registry
	docker push ${IMG}

# Generate manifests e.g. CRD, RBAC etc.
.PHONY: manifests
manifests: kustomize ## Generate deployment manifests
	$(KUSTOMIZE) build config/default | IMG=$(IMG) envsubst > deploy/bird-epic.yaml
	cp deploy/bird-epic.yaml deploy/bird-epic-${SUFFIX}.yaml

.PHONY: package
package: manifests
	tar cjf bird-epic-${SUFFIX}.tar.bz2 *.yaml *.sh configlets deploy/*.yaml

kustomize: ## Install kustomize
ifeq (, $(shell which kustomize))
	@{ \
	set -e ;\
	KUSTOMIZE_GEN_TMP_DIR=$$(mktemp -d) ;\
	cd $$KUSTOMIZE_GEN_TMP_DIR ;\
	go mod init tmp ;\
	go get sigs.k8s.io/kustomize/kustomize/v3@v3.8.6 ;\
	rm -rf $$KUSTOMIZE_GEN_TMP_DIR ;\
	}
KUSTOMIZE=$(GOBIN)/kustomize
else
KUSTOMIZE=$(shell which kustomize)
endif
