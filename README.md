# Codespace on Rails

## Why?

I've been trying to get some Ruby on Rails projects I have set up on Codespaces. After a lot of tries, I've finally got it working (at least the way I wanted it to) so now I'm creating this repository to keep these changes and copy them to other projects whenever I need

I mostly copied what was done [here](https://github.com/microsoft/vscode-dev-containers/tree/main/containers/ruby-rails-postgres) and fixed a couple of things that were not working for me or I didn't need.

## How?

1. Copy `.devcontainer` folder to your project
2. Customize
3. Open the project in Codespaces
4. No step 4 :)

## What's in the box?

- Ruby 3.1
- PostgreSQL 15
- Redis 7
- Node 19
- SSH server

## Customizations

There are a couple of things you _can_ customize and a couple of things you _should_ customize.

### Could

You can choose different Ruby and Node versions by updating the `devcontainer.json` file. Currently, it will install Ruby 3.1.3 and Node 19.2.0. You can also change the PostgreSQL username and password, although I don't think it matters too much.

You can also change the name of the project under `devcontainer.json` and `docker-compose.yml` if you want to. I've left it as `Your Project Name` for now.

If you decided to change the `service` name (defaults to `app` right now) remember to also update the `app` section in `docker-compose.yml`. They have to match.

### Should

You should, however, update your `database.yml` file if you use one. Here is what mine looks like:

```yaml
default: &default
  adapter: postgresql
  encoding: unicode
  host: postgres
  username: postgres
  password: postgres
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

Notice the `host: postgres`? That's the name of the container in the `docker-compose.yml` file. If you change it to, say, `db`, you'll have to update it here as well.

## How to ssh into the devcontainer?

```bash
ssh -p 2222 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o GlobalKnownHostsFile=/dev/null vscode@localhost
```

The password is `vscode`, configured under `boot.sh`
