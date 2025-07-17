# Codespace on Rails

## Why?

I've been trying to get some Ruby on Rails projects I have set up on Codespaces. After many tries, I've finally got it working (at least the way I wanted it to), so now I'm creating this repository to keep these changes and copy them to other projects whenever needed.

I mostly copied what was done [here](https://github.com/microsoft/vscode-dev-containers/tree/main/containers/ruby-rails-postgres) and fixed some things that were not working for me or that I didn't need.

## How?

1. Copy the `.devcontainer` folder to your project
2. Copy `.env.example` to `.env` and customize environment variables
3. Customize the files to your needs
4. Open the project in Codespaces

## What's in the box?

- Ruby 3.4.5
- PostgreSQL 17 (exposed locally on port 5433)
- Valkey 8 (Redis-compatible, exposed locally on port 6379)
- Node LTS
- ZSH and Oh My Zsh
- Mise version manager
- Non root user

## Security & Performance Features

This configuration includes several security and performance improvements:

### Security
- **Environment-based credentials**: Database and Redis passwords use environment variables
- **Valkey authentication**: Password protection enabled by default
- **Pinned versions**: All Docker images and features use specific versions
- **Non-root user**: Runs as `vscode` user for better security

### Performance & Reliability
- **Service dependencies**: App waits for database and Redis to be healthy before starting
- **Health checks**: Robust health monitoring with proper startup periods
- **Resource limits**: Memory limits prevent resource exhaustion (PostgreSQL: 512M, Valkey: 128M)
- **Optimized volumes**: Named volumes with explicit drivers for better persistence

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

## Environment Variables

This devcontainer configuration supports customization through environment variables. Copy `.env.example` to `.env` and adjust the values as needed:

### Database Configuration
- `POSTGRES_USER`: PostgreSQL username (default: `postgres`)
- `POSTGRES_DB`: PostgreSQL database name (default: `postgres`)
- `POSTGRES_PASSWORD`: PostgreSQL password (default: `postgres`)

### Valkey/Redis Configuration
- `VALKEY_PASSWORD`: Valkey password (default: `devpassword`)
- `VALKEY_PORT`: Host port for Valkey (default: `6379`)

### Rails Configuration
- `RAILS_ENV`: Rails environment (default: `development`)
- `SECRET_KEY_BASE`: Rails secret key base
- `RAILS_MASTER_KEY`: Rails master key for credentials

## Service Connection Examples

### Connecting to Valkey (Redis) from Rails

Configure in `config/application.rb` or an initializer:
```ruby
# config/initializers/redis.rb
Redis.current = Redis.new(
  host: 'valkey',  # Service name from docker-compose.yml
  port: 6379,
  password: ENV['VALKEY_PASSWORD'] || 'devpassword'
)
```

Using with Rails cache:
```ruby
# config/environments/development.rb
config.cache_store = :redis_cache_store, {
  url: "redis://:#{ENV['VALKEY_PASSWORD'] || 'devpassword'}@valkey:6379/0"
}
```

Using with Sidekiq:
```ruby
# config/initializers/sidekiq.rb
Sidekiq.configure_server do |config|
  config.redis = {
    url: "redis://:#{ENV['VALKEY_PASSWORD'] || 'devpassword'}@valkey:6379/0"
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
    url: "redis://:#{ENV['VALKEY_PASSWORD'] || 'devpassword'}@valkey:6379/0"
  }
end
```

### Connecting to PostgreSQL from Rails

Your `database.yml` should use the service name and environment variables:
```yaml
default: &default
  adapter: postgresql
  encoding: unicode
  host: postgres
  username: <%= ENV['POSTGRES_USER'] || 'postgres' %>
  password: <%= ENV['POSTGRES_PASSWORD'] || 'postgres' %>
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
```

## How do I SSH into the Codespace instance?

This configuration includes an SSH server. To access your codespace instance, you should install the `gh` CLI and run `gh codespace ssh` and select your codespace.

## How do I attach to my container if I'm not using Codespaces?

```bash
docker exec -it --user vscode app /bin/zsh
```

or

```bash
devcontainer exec --workspace-folder . zsh
```

(or use DevContainer VSCode extension)

## Using devcontainer CLI

Install with `npm install -g @devcontainers/cli`

### Setting it up
```bash
devcontainer up --workspace-folder .
```

### Checking for outdated dependencies

```bash
devcontainer --workspace-folder . outdated
```

### Upgrading your dependencies

```bash
devcontainer upgrade --workspace-folder .
```

### Removing everything

```bash
docker stop $(docker ps -q)
docker system prune -a --volumes --force
```
