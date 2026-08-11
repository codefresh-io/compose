FROM docker/compose-bin:v5.3.1@sha256:38fd4a3c7458b931d339b1eb657df0bef790a39bcaeb93ff9f70f59849b905c5 AS compose-bin


# DHI source: https://hub.docker.com/repository/docker/octopusdeploy/dhi-debian-base
FROM octopusdeploy/dhi-debian-base:trixie-debian13@sha256:014bacad6433af5bc9bd098ac713c4f104f9b395dd1d9d58bbcafd51ad2ce582 AS compose-plugin
WORKDIR /home/compose
COPY --chown=nonroot:nonroot --chmod=755 --from=compose-bin /docker-compose /usr/local/bin/docker-compose

ENV COMPOSE_COMPATIBILITY=true
USER nonroot:nonroot
ENTRYPOINT [ "docker-compose" ]
