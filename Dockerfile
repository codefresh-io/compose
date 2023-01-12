# syntax=docker/dockerfile:1


#   Copyright 2020 Docker Compose CLI authors

#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at

#       http://www.apache.org/licenses/LICENSE-2.0

#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

ARG GO_VERSION=1.19.4-alpine
ARG COMPOSE_UPSTREAM_VERSION=v2.15.1

FROM --platform=${BUILDPLATFORM} golang:${GO_VERSION} AS base
WORKDIR /compose-cli
RUN apk add --no-cache -vv \
  git \
  docker \
  make \
  protoc \
  protobuf-dev
COPY go.* .
RUN --mount=type=cache,target=/go/pkg/mod \
  --mount=type=cache,target=/root/.cache/go-build \
  go mod download

FROM base AS make-compose-plugin
ENV CGO_ENABLED=0
ARG TARGETOS
ARG TARGETARCH
ARG BUILD_TAGS
RUN --mount=target=. \
  --mount=type=cache,target=/go/pkg/mod \
  --mount=type=cache,target=/root/.cache/go-build \
  GOOS=${TARGETOS} \
  GOARCH=${TARGETARCH} \
  BUILD_TAGS=${BUILD_TAGS} \
  GIT_TAG=${COMPOSE_UPSTREAM_VERSION} \
  make COMPOSE_BINARY=/out/docker-compose -f builder.Makefile compose-plugin

FROM debian:bullseye-slim AS compose-plugin
COPY --from=make-compose-plugin /out/* /usr/local/bin/

RUN addgroup cfg && \
  adduser --ingroup cfg \
  --gecos "" --disabled-password \
  --home /home/cfu \
  --shell /bin/bash cfu

USER cfu

WORKDIR /home/cfu

RUN chown -R cfu:cfg /home/cfu && \
  chmod 755 /home/cfu

USER cfu:cfg

ENTRYPOINT [ "docker-compose" ]