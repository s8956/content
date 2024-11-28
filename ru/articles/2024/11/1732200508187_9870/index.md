---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Zabbix: Установка и обновление'
description: ''
images:
  - 'https://images.unsplash.com/photo-1585776245991-cf89dd7fc73a'
categories:
  - 'cat_01'
  - 'cat_02'
  - 'cat_03'
tags:
  - 'tag_01'
  - 'tag_02'
  - 'tag_03'
authors:
  - 'JohnDoe'
  - 'JaneDoe'
sources:
  - ''
license: 'CC-BY-SA-4.0'
complexity: '0'
toc: 1
comments: 1

# -------------------------------------------------------------------------------------------------------------------- #
# DATE
# -------------------------------------------------------------------------------------------------------------------- #

date: '2024-11-21T17:48:32+03:00'
publishDate: '2024-11-21T17:48:32+03:00'
lastMod: '2024-11-21T17:48:32+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '160a7005882dd037cd1fe0739a879ce6dbd15a0b'
uuid: '160a7005-882d-5037-9d1f-e0739a879ce6'
slug: '160a7005-882d-5037-9d1f-e0739a879ce6'

draft: 1
---



<!--more-->

## Установка пакетов

### Angie

```bash
. /etc/os-release; curl -fsSLo '/etc/apt/keyrings/angie.gpg' 'https://angie.software/keys/angie-signing.gpg' && echo "deb [signed-by=/etc/apt/keyrings/angie.gpg] https://download.angie.software/angie/${ID}/${VERSION_ID} ${VERSION_CODENAME} main" | tee '/etc/apt/sources.list.d/angie.list' && apt update && apt install --yes angie angie-module-brotli
```

### PHP

```bash
. /etc/os-release; curl -fsSLo '/etc/apt/keyrings/php.gpg' 'https://packages.sury.org/php/apt.gpg' && echo "deb [signed-by=/etc/apt/keyrings/php.gpg] https://packages.sury.org/php ${VERSION_CODENAME} main" | tee '/etc/apt/sources.list.d/php.list' && apt update && apt install --yes php8.3-fpm php8.3-bcmath php8.3-bz2 php8.3-cli php8.3-curl php8.3-gd php8.3-gmp php8.3-imagick php8.3-imap php8.3-intl php8.3-ldap php8.3-mbstring php8.3-memcached php8.3-mysql php8.3-odbc php8.3-opcache php8.3-pgsql php8.3-redis php8.3-uploadprogress php8.3-xml php8.3-zip php8.3-zstd
```

### PostgreSQL

- Установить PostgreSQL:

```bash
. /etc/os-release; curl -fsSL 'https://www.postgresql.org/media/keys/ACCC4CF8.asc' | gpg --dearmor -o '/etc/apt/keyrings/pgsql.gpg' && echo "deb [signed-by=/etc/apt/keyrings/pgsql.gpg] https://apt.postgresql.org/pub/repos/apt ${VERSION_CODENAME}-pgdg main" | tee '/etc/apt/sources.list.d/pgsql.list' && apt update && apt install --yes postgresql-16
```

### TimescaleDB

- Установить TimescaleDB:

```bash
. /etc/os-release; curl -fsSL 'https://packagecloud.io/timescale/timescaledb/gpgkey' | gpg --dearmor -o '/etc/apt/keyrings/timescaledb.gpg' && echo "deb [signed-by=/etc/apt/keyrings/timescaledb.gpg] https://packagecloud.io/timescale/timescaledb/debian/ ${VERSION_CODENAME} main" | tee '/etc/apt/sources.list.d/timescaledb.list' && apt update && apt install --yes timescaledb-2-postgresql-16='2.17.*' timescaledb-2-loader-postgresql-16='2.17.*' timescaledb-tools
```

### Zabbix

```bash
. /etc/os-release; curl -fsSLo '/etc/apt/keyrings/zabbix.gpg' 'https://uaik.github.io/config/zabbix/zabbix.gpg' && echo "deb [signed-by=/etc/apt/keyrings/zabbix.gpg] https://repo.zabbix.com/zabbix/7.0/debian ${VERSION_CODENAME} main" | tee '/etc/apt/sources.list.d/zabbix.list' && apt update && apt install --yes zabbix-server-pgsql zabbix-frontend-php zabbix-sql-scripts zabbix-agent
```

## Установка Zabbix

- Создание пользователя и базы данных, импортирование схемы базы данных:

```bash
sudo -u 'postgres' createuser --pwprompt 'zabbix' && sudo -u 'postgres' createdb -O 'zabbix' 'zabbix' && zcat '/usr/share/zabbix-sql-scripts/postgresql/server.sql.gz' | sudo -u 'zabbix' psql 'zabbix'
```

- Добавление расширения и импортирование схемы TimescaleDB:

```bash
echo 'CREATE EXTENSION IF NOT EXISTS timescaledb CASCADE;' | sudo -u 'postgres' psql 'zabbix' && cat '/usr/share/zabbix-sql-scripts/postgresql/timescaledb/schema.sql' | sudo -u 'zabbix' psql 'zabbix'
```

- Обновление схемы TimescaleDB:

```bash
echo "ALTER EXTENSION timescaledb UPDATE;" | sudo -u 'postgres' psql 'zabbix'
```

## Резервное копирование

```bash
d='backup.db'; pg_dump -Fd --host='127.0.0.1' --port='5432' --username='zabbix' --password --dbname='zabbix' -f "${d}"
```

## Восстановление

```bash
sudo -u 'postgres' dropdb 'zabbix'
sudo -u 'postgres' createdb -O 'zabbix' 'zabbix'
echo 'CREATE EXTENSION IF NOT EXISTS timescaledb CASCADE;' | sudo -u 'postgres' psql 'zabbix'
echo 'SELECT timescaledb_pre_restore();' | sudo -u 'postgres' psql 'zabbix'
pg_restore --host='127.0.0.1' --port='5432' --username='zabbix' --password --dbname='zabbix' 'backup.db'
echo 'SELECT timescaledb_post_restore();' | sudo -u 'postgres' psql 'zabbix'
```
