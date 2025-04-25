# Codespace on Rails

## Why?

I've been trying to get some Ruby on Rails projects I have set up on Codespaces. After many tries, I've finally got it working (at least the way I wanted it to), so now I'm creating this repository to keep these changes and copy them to other projects whenever needed.

I mostly copied what was done [here](https://github.com/microsoft/vscode-dev-containers/tree/main/containers/ruby-rails-postgres) and fixed some things that were not working for me or that I didn't need.

## How?

1. Copy the `.devcontainer` folder to your project
2. Customize the files to your needs
3. Open the project in Codespaces

## What's in the box?

- Ruby 3.4.3
- PostgreSQL 17 (exposed locally on port 5433)
- Valkey 8
- Node LTS
- ZSH and Oh My Zsh

## Customizations

There are a couple of things you _can_ customize and a couple of things you _should_ customize.

### Could

You can choose different Ruby and Node versions by updating the `devcontainer.json` file. Currently, it will install Ruby 3.4.x and Node LTS You can also change the PostgreSQL username and password, although I don't think it matters too much.

You can also change the project's name under `devcontainer.json` and `docker-compose.yml` if you want to. I've left it as `Your Project Name` for now.

If you change the `service` name (defaults to `app` right now), remember to update the app section in docker-compose.yml. They have to match.

### Should

You should, however, update your `database.yml` file if you use one. Here is what mine looks like:

```yaml
default: &default
  adapter: postgresql
  encoding: unicode
  host: postgres # This is the name of the container in the docker-compose.yml file
  username: postgres # This is the default username for the postgres image
  password: postgres # This is the default password for the postgres image
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>

development:
  <<: *default
  database: app_development

test:
  <<: *default
  database: app_test

production:
  <<: *default
  url: <%= ENV["DATABASE_URL"] %>
```

Notice the `host: postgres`? That's the name of the container in the `docker-compose.yml` file. If you change it to `db`, you must update the `database.yml` file too.

## How do I SSH into the Codespace instance?

This configuration includes an SSH server. To access your codespace instance, you should install the `gh` CLI and run `gh codespace ssh` and select your codespace.

## How do I attach to my container if I'm not using Codespaces?

`docker exec -it --user vscode app /bin/zsh`
