# AndyPortfolio

AndyPortfolio is a Ruby on Rails portfolio application. The root route renders
the blog index, and blog pages are backed by standard Rails resources.

## Stack

- Ruby 3.2.0
- Rails 7.0.4
- PostgreSQL
- Puma
- Sprockets, importmap-rails, Turbo, Stimulus, and Jbuilder
- Redis is declared for production Action Cable support

There is no Node, webpack, or separate frontend package manager configured in
this repository.

## Prerequisites

- Ruby 3.2.0, matching `.ruby-version`
- Bundler
- PostgreSQL reachable by Rails

The development database is `AndyPortfolio_development`; the test database is
`AndyPortfolio_test`. See `config/database.yml` for the local PostgreSQL
configuration. Local readiness checks should use Rails commands such as
`bin/rails db:prepare` or `bin/rails db:migrate:status`; the `psql` CLI is not
required by this repository.

## Setup

```sh
bin/setup
```

`bin/setup` installs Bundler conservatively, runs `bundle check` or
`bundle install`, prepares the database, clears logs and temporary files, and
restarts Rails.

## Run Locally

```sh
bin/rails server
```

Useful Rails entrypoints:

```sh
bin/rails <command>
bin/rake <task>
```

## Tests

```sh
bin/rails test
bin/rails test test/integration/
```

Tests use Rails Minitest under `test/`.

## Lint

No lint tool, config, gem, or documented lint command is currently checked in.

## Production Build

```sh
bin/render-build.sh
```

This script runs `bundle install`, `bundle exec rails assets:precompile`, and
`bundle exec rails assets:clean`.

## Deployment

Render deployment is configured by `render.yaml`. The deployment handoff,
required environment variables, build command, pre-deploy migration command, and
start command are documented in `docs/deployment-render.md`.
