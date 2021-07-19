REPO ?= registry.gitlab.com/acnodal/epic
PREFIX ?= router
SUFFIX ?= ${USER}-dev

TAG ?= ${REPO}/${PREFIX}:${SUFFIX}
DOCKERFILE ?= Dockerfile

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

image:	## Build the Docker image
	docker build --tag=${TAG} ${DOCKER_BUILD_OPTIONS} .

install:	image ## Push the image to the registry
	docker push ${TAG}
