# AGENTS.md — AndyPortfolio

Personal portfolio site built with Ruby. Agents working in this repo follow this file.

## Setup
```bash
bundle install
```

## Build / Test / Lint
```bash
bundle exec rake          # default task — runs the full check pipeline
bundle exec rake test     # tests only
bundle exec rubocop       # lint only
```

## Run locally
```bash
bundle exec rackup        # if config.ru is used
# or, for Rails:
bundle exec rails server
```

Re-detect the actual entry point from `config.ru` / `bin/` / `Gemfile` before running.

## Code style
- Ruby version pinned in `.ruby-version`; match it
- Follow `.rubocop.yml`; do not introduce new violations
- Match existing module / class / file naming around the change
- Keep commits atomic and scoped

## PR conventions
- Branch: `agent/<role>/and-<n>-<short-slug>` (e.g. `agent/frontend/and-5078-language-metadata`)
- Title: `AND-<n>: <imperative summary>` (e.g. `AND-5078: Add language metadata to Rails HTML roots`)
- Body: link the Multica issue ID, summarize the change, list verification steps run
- One issue → one focused PR; do NOT bundle unrelated changes

## Boundaries

### ALWAYS
- Run `bundle exec rubocop` and `bundle exec rake test` before requesting review
- Use feature branches; never push to `main`
- Match the surrounding code style on every edit
- Keep PRs review-ready: small, focused, with a passing test plan

### ASK FIRST (record on the issue + wait for Jyro)
- Dependency bumps that touch `Gemfile.lock`
- New gems
- Database migrations or schema changes
- Switching Ruby version, build system, or test runner
- Visual changes that affect the live portfolio's brand surface

### NEVER
- Commit secrets, API keys, or tokens
- Force-push to shared branches
- Bypass tests/lint to ship
- Touch `vendor/` or `tmp/` checked-in content
- Modify CI workflows without explicit approval

## How agents collaborate here
- Coordinate via the assigned Multica issue (comments, status); do not @-mention other agents to hand off — that's the squad leader's job
- For visual bugs: include a brief observation + reproduction note on the issue before pushing a fix
- For architectural changes: pause and route to Jyro (Implementation Squad leader) for a decision before implementing
- `ultrareview` is a manual user-run Claude Code cloud review — prepare review-ready branches; Andy triggers ultrareview himself

## Where to start when picking up an issue
1. Read the issue, all comments, and metadata
2. Read this AGENTS.md
3. Read `README.md` for product context
4. Inspect the change surface in the repo before writing code
5. Run setup + tests once on the current branch to confirm the baseline passes
