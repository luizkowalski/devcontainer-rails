FROM mcr.microsoft.com/vscode/devcontainers/base:ubuntu-22.04

ENV RAILS_DEVELOPMENT_HOSTS=".githubpreview.dev,.app.github.dev"

# Adding the PostgreSQL repository so we can install postgresql-client v15
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
RUN curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o /etc/apt/trusted.gpg.d/postgresql.gpg
