FROM docker/compose-bin:v5.5.1@sha256:14162382692aae43977f79effa64a499d61de19d4645461881daaf88773f7e74 AS compose-bin


# DHI source: https://hub.docker.com/repository/docker/octopusdeploy/dhi-debian-base
FROM octopusdeploy/dhi-debian-base:trixie-debian13@sha256:b6c199b4653673cb7863db456a5aeb14438674106216b99cf8e9752cd0156046 AS compose-plugin
WORKDIR /home/compose
COPY --chown=nonroot:nonroot --chmod=755 --from=compose-bin /docker-compose /usr/local/bin/docker-compose

ENV COMPOSE_COMPATIBILITY=true
USER nonroot:nonroot
ENTRYPOINT [ "docker-compose" ]
