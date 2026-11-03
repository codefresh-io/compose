FROM docker/compose-bin:v5.6.1@sha256:2aeaeedd4f2d8e2dcb399b2b9723bfaeb6714140cb0657897f5865960f1624ae AS compose-bin


# DHI source: https://hub.docker.com/repository/docker/octopusdeploy/dhi-debian-base
FROM octopusdeploy/dhi-debian-base:trixie-debian13@sha256:834d20c209fe4aac50dc95877d68d421f97ea38a905586bfdaf938bebb3924c0 AS compose-plugin
WORKDIR /home/compose
COPY --chown=nonroot:nonroot --chmod=755 --from=compose-bin /docker-compose /usr/local/bin/docker-compose

ENV COMPOSE_COMPATIBILITY=true
USER nonroot:nonroot
ENTRYPOINT [ "docker-compose" ]
