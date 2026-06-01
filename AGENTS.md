# AGENTS.md — AndyPortfolio

Repo-local guidance for coding agents. Only commands and conventions observable in this repository are documented here; do not invent toolchain steps.

## Stack (detected from repo files)

- Ruby on Rails application.
- Ruby version pinned to `3.2.3` (see `.ruby-version`).
- Rails `~> 7.0.4`, Sprockets, importmap-rails, Turbo, Stimulus, Jbuilder (see `Gemfile`, `Gemfile.lock`).
- Web server: Puma `~> 5.0`.
- Database: PostgreSQL (`pg ~> 1.1`). Development DB name `AndyPortfolio_development` (see `config/database.yml`).
- Cache/queue: Redis `~> 4.0` declared.
- Boot caching: `bootsnap`.
- Dev/test gems: `debug`, `ffaker`. Dev-only: `web-console`.

## Setup

```sh
bin/setup
```

`bin/setup` runs (in order, observable in `bin/setup`):

1. `gem install bundler --conservative`
2. `bundle check` → `bundle install` on miss
3. `bin/rails db:prepare`
4. `bin/rails log:clear tmp:clear`
5. `bin/rails restart`

Prerequisite: a working Ruby 3.2.3 toolchain and a reachable PostgreSQL instance configured per `config/database.yml`.

## Run

```sh
bin/rails server
```

Routes (`config/routes.rb`): `root "blogs#index"` and `resources :blogs`.

## Rails / Rake

- `bin/rails <command>` — Rails CLI (`bin/rails`).
- `bin/rake <task>` — Rake (`bin/rake`, `Rakefile`).

## Tests

```sh
bin/rails test
bin/rails test test/integration/
```

Checked-in tests use Rails Minitest under `test/`, with integration coverage in `test/integration/`.

## Lint

```sh
bundle exec rubocop
```

Uses RuboCop with Rails extensions. Configured in `.rubocop.yml`.

## Build (production assets)

```sh
bin/render-build.sh
```

`bin/render-build.sh` runs (in order):

1. `bundle install`
2. `bundle exec rails assets:precompile`
3. `bundle exec rails assets:clean`

This is the build command referenced by `render.yaml` (`buildCommand: ./bin/render-build.sh`).

## Deploy / Deploy-preflight

Render-managed deploy is declared in `render.yaml`:

- `buildCommand: ./bin/render-build.sh`
- `preDeployCommand: bundle exec rails db:migrate`
- `startCommand: bundle exec puma -C config/puma.rb`
- `healthCheckPath: /`

Required env vars (from `render.yaml`): `DATABASE_URL` (from `andyportfolio-db`), `RAILS_ENV=production`, `RAILS_LOG_TO_STDOUT=1`, `RAILS_SERVE_STATIC_FILES=1`, `RAILS_MASTER_KEY` (manual), `BLOG_ADMIN_TOKEN` (manual), `SECRET_KEY_BASE` (generated).

Deploy-preflight references:

- `docs/deployment-render.md` — Render blueprint setup and required env vars.
- `docs/qa-smoke-checklist.md` — local and live `curl` smoke probes (root, `/blogs`, anonymous write-denial checks).

## Conventions

- Frontend assets via `importmap-rails` and Sprockets; no Node/webpack toolchain in repo.
- ERB views under `app/views/`; layouts in `app/views/layouts/`.
- Database migrations under `db/migrate/`; schema in `db/schema.rb`.
- Default Rails directory layout (`app/`, `config/`, `db/`, `lib/`, `public/`, `vendor/`).

## Known gaps

- README is the default Rails placeholder; it does not document install/build/test/lint/run.
- No CI configuration is checked in.
