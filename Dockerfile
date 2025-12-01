FROM debian:trixie-20251117-slim AS compose-plugin
WORKDIR /home/compose
RUN groupadd --gid 3000 compose \
  && useradd --uid 3000 \
    --gid 3000 \
    --home /home/compose \
    --shell /bin/bash \
    compose  
COPY --from=docker/compose-bin:v2.40.3 --chown=compose:compose /docker-compose /usr/local/bin/docker-compose

ENV COMPOSE_COMPATIBILITY=true
USER compose:compose
ENTRYPOINT [ "docker-compose" ]
