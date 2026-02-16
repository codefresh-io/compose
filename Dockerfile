# CI relies on this ARG. Don't remove or rename it
ARG COMPOSE_VERSION=v5.0.1
FROM docker/compose-bin:${COMPOSE_VERSION} AS compose-bin


# DHI source: https://hub.docker.com/repository/docker/octopusdeploy/dhi-debian-base
FROM octopusdeploy/dhi-debian-base:trixie-debian13@sha256:9ef766670af4743904b0f992a26b525c6c914648b56ea597ec23452adcf1a95d AS compose-plugin
WORKDIR /home/compose
COPY --chown=nonroot:nonroot --chmod=755 --from=compose-bin /docker-compose /usr/local/bin/docker-compose

ENV COMPOSE_COMPATIBILITY=true
USER nonroot:nonroot
ENTRYPOINT [ "docker-compose" ]
