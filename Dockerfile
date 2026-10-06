FROM docker/compose-bin:v5.6.0@sha256:db34ebea4a1acd4b130e9abc305cdb51b3fe53b9116a6c2ac268a451eb308bed AS compose-bin


# DHI source: https://hub.docker.com/repository/docker/octopusdeploy/dhi-debian-base
FROM octopusdeploy/dhi-debian-base:trixie-debian13@sha256:20079b51710f0397da5e056bfc7156b6aafc7ff3aa4ef4cbcb0b0f1df99cd8c4 AS compose-plugin
WORKDIR /home/compose
COPY --chown=nonroot:nonroot --chmod=755 --from=compose-bin /docker-compose /usr/local/bin/docker-compose

ENV COMPOSE_COMPATIBILITY=true
USER nonroot:nonroot
ENTRYPOINT [ "docker-compose" ]
