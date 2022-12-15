FROM mcr.microsoft.com/vscode/devcontainers/base:ubuntu-22.04

# Installing essential packages
RUN apt update && export DEBIAN_FRONTEND=noninteractive \
    && apt -y install --no-install-recommends \
    build-essential libpq-dev python3

# Set zsh as default shell for vscode user
RUN chsh -s /bin/zsh vscode
