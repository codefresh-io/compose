FROM docker/compose-bin:v5.7.1@sha256:6a6704a7ccbc45eb4cc7e5b71dba685e9bc23705c580430f15034b2b5e46ec2b AS compose-bin


# DHI source: https://hub.docker.com/repository/docker/octopusdeploy/dhi-debian-base
FROM octopusdeploy/dhi-debian-base:trixie-debian13@sha256:e3e8512202bb7d8a7093905a3615408784beba909b3cd61d3bb49367f5cfa448 AS compose-plugin
WORKDIR /home/compose
COPY --chown=nonroot:nonroot --chmod=755 --from=compose-bin /docker-compose /usr/local/bin/docker-compose

ENV COMPOSE_COMPATIBILITY=true
USER nonroot:nonroot
ENTRYPOINT [ "docker-compose" ]
