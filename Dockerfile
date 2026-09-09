FROM docker/compose-bin:v5.5.0@sha256:962d5ea7017e5ef425bfa47e492efa2c27d0492e8af58c497011e73b2ce98ee0 AS compose-bin


# DHI source: https://hub.docker.com/repository/docker/octopusdeploy/dhi-debian-base
FROM octopusdeploy/dhi-debian-base:trixie-debian13@sha256:f5cabbc76f75c55151aa0f23d06d643cbb04a07de4c8bf88f003ca7dcbae8527 AS compose-plugin
WORKDIR /home/compose
COPY --chown=nonroot:nonroot --chmod=755 --from=compose-bin /docker-compose /usr/local/bin/docker-compose

ENV COMPOSE_COMPATIBILITY=true
USER nonroot:nonroot
ENTRYPOINT [ "docker-compose" ]
