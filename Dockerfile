# DHI source: https://hub.docker.com/repository/docker/octopusdeploy/dhi-docker
FROM octopusdeploy/dhi-docker:29.10.0-cli@sha256:2a19c4cb31621c029f0be3b33a9cebabdfe6d5605f80f52bac727a496a88afea AS docker


# DHI source: https://hub.docker.com/repository/docker/octopusdeploy/dhi-debian-base
FROM octopusdeploy/dhi-debian-base:trixie-debian13@sha256:aa05c07c3ee50351cfda6595ca8277d1cd07aa9a338f9efe9416188193af7a3f AS compose-plugin
WORKDIR /home/compose
COPY --chown=nonroot:nonroot --chmod=755 --from=docker /usr/libexec/docker/cli-plugins/docker-compose /usr/local/bin/docker-compose
ENV COMPOSE_COMPATIBILITY=true
USER nonroot:nonroot
RUN docker-compose --version
ENTRYPOINT [ "docker-compose" ]
