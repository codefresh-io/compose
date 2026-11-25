# DHI source: https://hub.docker.com/repository/docker/octopusdeploy/dhi-docker
FROM octopusdeploy/dhi-docker:29.10.0-cli@sha256:9b1d26903329cba28dd3abcccdba31df0493d1730609acf150d429c89d790bda AS docker


# DHI source: https://hub.docker.com/repository/docker/octopusdeploy/dhi-debian-base
FROM octopusdeploy/dhi-debian-base:trixie-debian13@sha256:5fea62d91bafd8ae8a0b4ed2a22cadd9086c5d3a9dc8c9782c0705489fb535ee AS compose-plugin
WORKDIR /home/compose
COPY --chown=nonroot:nonroot --chmod=755 --from=docker /usr/libexec/docker/cli-plugins/docker-compose /usr/local/bin/docker-compose
ENV COMPOSE_COMPATIBILITY=true
USER nonroot:nonroot
RUN docker-compose --version
ENTRYPOINT [ "docker-compose" ]
