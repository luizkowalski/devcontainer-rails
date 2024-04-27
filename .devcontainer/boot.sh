#!/bin/bash

echo "Updating RubyGems..."
gem update --system -N

echo "Installing dependencies..."
bundle install
yarn install

echo "Copying database.yml..."
cp -n config/database.yml.example config/database.yml

echo "Creating database..."
bin/rails db:prepare

echo "Done!"
