# vvveb_template

This project sets up a **Vvveb CMS** instance using Docker Compose with:
- **vvveb/vvvebcms** (app)
- **Caddy** (TLS reverse proxy)
- **MariaDB** (database)
- optional **Kopia** (backups)
- optional **vvvebcli** tools profile for CLI automation

## Structure

This repository follows the same file/folder layout used in [`j3fnkr/wordpress_template`](https://github.com/j3fnkr/wordpress_template):

- `.env.example`
- `docker-compose.yml`
- `docker-compose.core.yml`
- `run.sh`
- `backup.sh`
- `conf/Caddyfile.template`

## Configuration

Copy and edit environment variables:

```bash
cp .env.example .env
```

Required variables:

- `HOSTNAME`, `EMAIL`
- `DB_ENGINE` (default `mysqli`)
- `DB_HOST`, `DB_PORT`, `DB_DATABASE`, `DB_USER`, `DB_PASSWORD`
- `DB_ROOT_PASSWORD`
- `KOPIA_PASSWORD`

## Run the stack

```bash
./run.sh
```

Caddy renders `conf/Caddyfile` from `conf/Caddyfile.template` using values from `.env`.

## Vvveb install behavior (vs WordPress WP-CLI)

Unlike WordPress + WP-CLI, `vvveb/vvvebcms` does **not** use WP-CLI. It works like this:

1. Container entrypoint prepares `/var/www/html`.
2. If not installed, Vvveb redirects to the web installer (`/install/index.php`).
3. You can automate first install with Vvveb's built-in `cli.php`.

### Web installer flow

Open your site and complete installer in browser.

### CLI-based first install (similar goal as `wp core install`)

With services running:

```bash
docker compose --profile tools run --rm vvvebcli install \
  engine=mysqli host=db user=vvveb your-db-password database=vvveb \
  'admin[email]=admin@example.com' \
  'admin[username]=admin' \
  'admin[password]=change-me'
```

SQLite example:

```bash
docker compose --profile tools run --rm vvvebcli install \
  engine=sqlite \
  'admin[email]=admin@example.com' \
  'admin[username]=admin' \
  'admin[password]=change-me'
```

So there is equivalent automation functionality, but it is provided by Vvveb's internal `cli.php` command interface rather than WP-CLI.

## Backups

Run on-demand backups with Kopia:

```bash
./backup.sh
```

Backs up:
- `/backup/vvveb`
- `/backup/db`
- `/backup/caddy_data`
- `/backup/caddy_config`
