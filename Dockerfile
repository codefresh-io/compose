ARG COMPOSE_VERSION=v2.40.3
# ↑ CI relies on this ARG. Don't remove or rename it ↑

FROM debian:trixie-20251208-slim AS compose-plugin
WORKDIR /home/compose
RUN groupadd --gid 3000 compose \
  && useradd --uid 3000 \
    --gid 3000 \
    --home /home/compose \
    --shell /bin/bash \
    compose  
COPY --from=docker/compose-bin:${COMPOSE_VERSION} --chown=compose:compose /docker-compose /usr/local/bin/docker-compose

ENV COMPOSE_COMPATIBILITY=true
USER compose:compose
ENTRYPOINT [ "docker-compose" ]
