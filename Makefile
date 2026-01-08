# Makefile for kbot Telegram Bot

# Variables
APP_NAME := kbot
VERSION ?= v1.0.0
REGISTRY ?= ghcr.io
REPOSITORY ?= den-vasyliev/kbot
OS ?= linux
ARCH ?= amd64
GIT_COMMIT := $(shell git rev-parse --short HEAD 2>/dev/null || echo "unknown")
IMAGE_TAG := $(VERSION)-$(GIT_COMMIT)-$(OS)-$(ARCH)
IMAGE_NAME := $(REGISTRY)/$(REPOSITORY):$(IMAGE_TAG)

# Build binary
.PHONY: build
build:
	@echo "Building $(APP_NAME)..."
	@GOOS=$(OS) GOARCH=$(ARCH) go build -ldflags "-X github.com/sadko/tg-bot/cmd.appVersion=$(VERSION)" -o bin/$(APP_NAME) main.go

# Build Docker image
.PHONY: docker-build
docker-build:
	@echo "Building Docker image $(IMAGE_NAME)..."
	@docker build \
		--platform $(OS)/$(ARCH) \
		--build-arg VERSION=$(VERSION) \
		--build-arg GIT_COMMIT=$(GIT_COMMIT) \
		-t $(IMAGE_NAME) \
		.

# Push Docker image
.PHONY: docker-push
docker-push:
	@echo "Pushing Docker image $(IMAGE_NAME)..."
	@docker push $(IMAGE_NAME)

# Build and push
.PHONY: docker-build-push
docker-build-push: docker-build docker-push

# Update Helm chart values
.PHONY: update-helm-values
update-helm-values:
	@echo "Updating Helm values.yaml..."
	@sed -i.bak \
		-e 's|tag:.*|tag: "$(VERSION)-$(GIT_COMMIT)"|' \
		-e 's|os:.*|os: $(OS)|' \
		-e 's|arch:.*|arch: $(ARCH)|' \
		helm/kbot/values.yaml || true
	@rm -f helm/kbot/values.yaml.bak

# Run tests
.PHONY: test
test:
	@echo "Running tests..."
	@go test -v ./...

# Clean build artifacts
.PHONY: clean
clean:
	@echo "Cleaning build artifacts..."
	@rm -rf bin/
	@rm -f helm/kbot/values.yaml.bak

# Help
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  build              - Build the binary"
	@echo "  docker-build       - Build Docker image"
	@echo "  docker-push        - Push Docker image to registry"
	@echo "  docker-build-push  - Build and push Docker image"
	@echo "  update-helm-values - Update Helm chart values.yaml"
	@echo "  test               - Run tests"
	@echo "  clean              - Clean build artifacts"
	@echo "  help               - Show this help message"
	@echo ""
	@echo "Variables:"
	@echo "  VERSION=$(VERSION)"
	@echo "  REGISTRY=$(REGISTRY)"
	@echo "  REPOSITORY=$(REPOSITORY)"
	@echo "  OS=$(OS)"
	@echo "  ARCH=$(ARCH)"
	@echo "  IMAGE_NAME=$(IMAGE_NAME)"

