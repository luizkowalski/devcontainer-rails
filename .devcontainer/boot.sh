#!/bin/bash

# Set up vscode user for SSH
sudo usermod --password $(echo vscode | openssl passwd -1 -stdin) vscode

bundle install
yarn install

cp config/database.yml.example config/database.yml

bin/rails db:create db:schema:load db:seed
