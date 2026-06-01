# AGENTS.md — AndyPortfolio

Repo-local guidance for coding agents. Only commands and conventions observable in this repository are documented here; do not invent toolchain steps.

## Stack (detected from repo files)

- Ruby on Rails application.
- Ruby version pinned to `3.2.0` (see `.ruby-version`).
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

Prerequisite: a working Ruby 3.2.0 toolchain and a reachable PostgreSQL instance configured per `config/database.yml`.

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

Prerequisites for local test execution:

- Ruby `3.2.0`, matching `.ruby-version`.
- Bundler with the gems in `Gemfile.lock`.
- PostgreSQL reachable by Rails. The default test database is `AndyPortfolio_test` (see `config/database.yml`).

### Toolchain-limited / Ruby-less verification

Some Multica worker runtimes do not include Ruby 3.2.0, Bundler, native `pg` build dependencies, or a reachable PostgreSQL service. In that environment, do not mark Rails work as fully verified locally. Use this fallback standard instead:

1. Record the missing prerequisite exactly, for example `ruby: command not found`, `bundle: command not found`, or the PostgreSQL connection error.
2. Run only checks that do not require the missing toolchain. Useful dry checks include `git diff --check` for whitespace errors and focused file inspection for syntax-visible mistakes.
3. If Ruby is available but PostgreSQL is not, prefer parser-level checks before stopping:

   ```sh
   ruby -c app/path/to/file.rb
   ruby -c test/path/to/test_file.rb
   ```

   Do not use `ruby -c` on ERB templates as a substitute for Rails rendering tests.
4. Include the exact owner/CI commands that still need to run:

   ```sh
   bin/rails db:prepare
   bin/rails test
   bin/rails test test/integration/
   bundle exec rake test
   bundle exec rake test TEST=test/integration/
   ```

5. Treat GitHub Actions Rails CI as the authoritative verification when local Ruby/PostgreSQL is unavailable. The checked-in workflow is `.github/workflows/rails.yml`; on pull requests it runs `bundle install`, `bin/rails db:prepare`, `bin/rails test`, and production asset precompilation.

### Handoff Evidence

When handing off Rails work without full local verification, include this evidence block in the issue or PR comment:

```text
Handoff Evidence:
- Local runtime: <Ruby/Bundler/PostgreSQL availability, including exact blocker output>
- Local checks run: <commands and pass/fail result, e.g. git diff --check>
- Rails tests not run locally because: <specific missing prerequisite>
- Required verification: bin/rails db:prepare; bin/rails test; bin/rails test test/integration/; bundle exec rake test; bundle exec rake test TEST=test/integration/
- CI: <GitHub Actions Rails CI status or "pending/not observed">
- Risk notes: <files or behavior most likely affected>
```

## Lint

No lint tool, config, or gem declared in `Gemfile`/`Gemfile.lock`. There is no documented lint command.

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

## CI

GitHub Actions Rails CI is checked in at `.github/workflows/rails.yml` and runs on pull requests. It provisions PostgreSQL 16, sets `RAILS_ENV=test`, installs Ruby dependencies with Bundler, prepares the database, runs `bin/rails test`, and precompiles production assets with `SECRET_KEY_BASE=dummy`.

## Known gaps

- Local verification still requires agents to have Ruby 3.2.0, Bundler, and PostgreSQL available; not every Multica runtime currently has that toolchain.
