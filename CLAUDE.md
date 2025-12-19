# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Dev Container setup for Redmine development. The Redmine source code is mounted from a sibling directory (configured via `REDMINE_PATH` in `.devcontainer/.env`). The workspace folder inside the container is `/workspaces/redmine`.

## Services Architecture

The dev container runs 4 services on a shared `devcontainer` network:

| Service | Host | Purpose |
|---------|------|---------|
| app | `app` | Rails development (Ruby 3.4, mise for version management) |
| db | `db:5432` | PostgreSQL (user: postgres, password: postgres) |
| selenium | `selenium:4444` | Chromium for system tests (ARM-compatible seleniarm image) |
| maildev | `maildev:1025` | SMTP capture (Web UI at localhost:1080) |

## Common Commands

All commands run inside the container at `/workspaces/redmine`:

```bash
# Start Rails server
bundle exec rails server

# Run all tests
bundle exec rails test

# Run a single test file
bundle exec rails test test/unit/issue_test.rb

# Run a specific test method
bundle exec rails test test/unit/issue_test.rb -n test_method_name

# Run System Specs (browser tests via Selenium)
SELENIUM_REMOTE_URL=http://selenium:4444 \
CAPYBARA_SERVER_HOST=0.0.0.0 \
CAPYBARA_SERVER_PORT=3001 \
CAPYBARA_APP_HOST=http://app:3001 \
GOOGLE_CHROME_OPTS_ARGS=headless,disable-gpu,no-sandbox,disable-dev-shm-usage \
bin/rails test:system

# Database operations
bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake redmine:load_default_data RAILS_ENV=development
```

## Database Configuration

For Redmine's `config/database.yml`:

```yaml
development:
  adapter: postgresql
  database: redmine_development
  host: db
  username: postgres
  password: postgres
```

## Environment Variables

Set in `.devcontainer/.env`:
- `REDMINE_PATH` - Path to Redmine source (relative to this repo, e.g., `../redmine`)
- `INSTALL_CLAUDE_CODE` - Enable/disable Claude Code installation (default: true)
- `INSTALL_OPENAI_CODEX` - Enable/disable OpenAI Codex installation (default: true)

## Commit Convention

This project uses **Conventional Commits**. All commit messages must follow this format:

```
<type>(<scope>): <description>

[optional body]
```

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

Examples:
- `feat(docker): add Redis service`
- `fix(selenium): correct ARM image configuration`
- `docs(readme): update setup instructions`

## Key Files

- `.devcontainer/docker-compose.yml` - Service definitions
- `.devcontainer/devcontainer.json` - VS Code container settings
- `scripts/postCreateCommand.sh` - Container initialization (mise, bash-it, tools)
- `scripts/init.sh` - Pre-container setup (GitHub CLI token)
