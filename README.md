# AndyPortfolio

AndyPortfolio is a personal portfolio and blog application built with Ruby on
Rails. It serves as a public showcase for Andy's blog posts and projects.

## Project Context

This application is designed for simplicity and security:
- **Public Blog**: Visitors can read all blog posts via a clean, server-side
  rendered interface.
- **Admin Gate**: Administrative actions (create, edit, delete) are protected by
  a token-based authorization mechanism. To perform these actions, a valid
  `X-Blog-Admin-Token` header must be provided, matching the `BLOG_ADMIN_TOKEN`
  environment variable.
- **SEO Ready**: Includes a dynamic sitemap and robots.txt configuration.
- **No Heavy Frontend**: Uses Rails standard patterns (Turbo/Stimulus) with no
  Node.js or complex build pipelines.

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
configuration.

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

Tests use Rails Minitest under `test/`. The suite includes integration coverage
for public browsing, admin authorization, and SEO endpoints.

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
