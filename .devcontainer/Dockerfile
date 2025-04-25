FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

ENV RAILS_DEVELOPMENT_HOSTS=".githubpreview.dev,.app.github.dev"

RUN apt install curl ca-certificates git -y

# Installs postgresql-client-17
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
RUN curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/postgresql.gpg

RUN apt update \
  && apt install postgresql-client-17 -y --no-install-recommends \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
