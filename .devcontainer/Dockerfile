FROM ruby:4.0.1-trixie

ARG RAILS_DEVELOPMENT_HOSTS=".githubpreview.dev,.app.github.dev"
ENV RAILS_DEVELOPMENT_HOSTS=${RAILS_DEVELOPMENT_HOSTS}

# Installs postgresql-client-18
RUN apt-get install curl ca-certificates git -y --no-install-recommends \
  && sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt trixie-pgdg main" > /etc/apt/sources.list.d/pgdg.list' \
  && curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o /etc/apt/trusted.gpg.d/postgresql.gpg

RUN apt-get update \
  && apt-get install postgresql-client-18 sudo -y --no-install-recommends \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN gem update --system -N

# Add user vscode to the group sudo
RUN groupadd -g 1000 vscode && \
  useradd -u 1000 -g 1000 -m -s /bin/bash vscode && \
  echo "vscode ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/vscode

USER vscode
