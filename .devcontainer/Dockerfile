FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

ENV RAILS_DEVELOPMENT_HOSTS=".githubpreview.dev,.app.github.dev"

# Installs postgresql-client-17
RUN apt-get install curl ca-certificates git -y --no-install-recommends \
  && sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list' \
  && curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o /etc/apt/trusted.gpg.d/postgresql.gpg

RUN apt-get update \
  && apt-get install postgresql-client-17 -y --no-install-recommends \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

USER vscode
