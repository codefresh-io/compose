ARG GO_VERSION=1.17-alpine
ARG GOLANGCI_LINT_VERSION=v1.40.1-alpine
ARG PROTOC_GEN_GO_VERSION=v1.4.3

ARG BUILD_TAGS="e2e,kube"
ARG DOCS_FORMATS="md,yaml"
ARG LICENSE_FILES=".*\(Dockerfile\|Makefile\|\.go\|\.hcl\|\.sh\)"

# xx is a helper for cross-compilation
FROM --platform=${BUILDPLATFORM} tonistiigi/xx:${XX_VERSION} AS xx

FROM golangci/golangci-lint:${GOLANGCI_LINT_VERSION}-alpine AS golangci-lint
FROM ghcr.io/google/addlicense:${ADDLICENSE_VERSION} AS addlicense

FROM --platform=${BUILDPLATFORM} golang:${GO_VERSION}-alpine AS base
COPY --from=xx / /
RUN apk add --no-cache \
      docker \
      file \
      git \
      make \
      protoc \
      protobuf-dev
WORKDIR /src
ENV CGO_ENABLED=0

FROM base AS build-base
COPY go.* .
RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    go mod download

FROM base AS make-compose-plugin
ENV CGO_ENABLED=0
ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT
RUN --mount=from=binary \
    mkdir -p /out && \
    # TODO: should just use standard arch
    TARGETARCH=$([ "$TARGETARCH" = "amd64" ] && echo "x86_64" || echo "$TARGETARCH"); \
    TARGETARCH=$([ "$TARGETARCH" = "arm64" ] && echo "aarch64" || echo "$TARGETARCH"); \
    cp docker-compose* "/out/docker-compose-${TARGETOS}-${TARGETARCH}${TARGETVARIANT}$(ls docker-compose* | sed -e 's/^docker-compose//')"

FROM debian:bullseye-slim AS compose-plugin
WORKDIR /root
COPY --from=make-compose-plugin /out/* /usr/local/bin/

RUN adduser -D -h /home/cfu -s /bin/bash cfu
USER cfu

ENTRYPOINT [ "docker-compose" ]
