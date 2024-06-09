FROM mcr.microsoft.com/vscode/devcontainers/base:ubuntu-24.04

ENV RAILS_DEVELOPMENT_HOSTS=".githubpreview.dev,.app.github.dev"

RUN apt install curl ca-certificates git

# Installs postgresql-client-16
RUN install -d /usr/share/postgresql-common/pgdg
RUN curl -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc --fail https://www.postgresql.org/media/keys/ACCC4CF8.asc
RUN sh -c 'echo "deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

RUN apt update \
  && apt install postgresql-client-16 -y --no-install-recommends \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
