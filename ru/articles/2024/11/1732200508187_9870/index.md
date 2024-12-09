---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Zabbix: Установка и обновление'
description: ''
images:
  - 'https://images.unsplash.com/photo-1622533277534-e2b5f311bb60'
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
complexity: '1'
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

- Добавить репозиторий и установить пакеты Angie:

```bash
. /etc/os-release; curl -fsSLo '/etc/apt/keyrings/angie.gpg' 'https://angie.software/keys/angie-signing.gpg' && echo "deb [signed-by=/etc/apt/keyrings/angie.gpg] https://download.angie.software/angie/${ID}/${VERSION_ID} ${VERSION_CODENAME} main" | tee '/etc/apt/sources.list.d/angie.list' && apt update && apt install --yes angie angie-module-brotli
```

### PHP

- Добавить репозиторий и установить пакеты PHP-FPM:

```bash
. /etc/os-release; curl -fsSLo '/etc/apt/keyrings/php.gpg' 'https://packages.sury.org/php/apt.gpg' && echo "deb [signed-by=/etc/apt/keyrings/php.gpg] https://packages.sury.org/php ${VERSION_CODENAME} main" | tee '/etc/apt/sources.list.d/php.list' && apt update && apt install --yes php8.3-fpm php8.3-bcmath php8.3-bz2 php8.3-cli php8.3-curl php8.3-gd php8.3-gmp php8.3-imagick php8.3-imap php8.3-intl php8.3-ldap php8.3-mbstring php8.3-memcached php8.3-mysql php8.3-odbc php8.3-opcache php8.3-pgsql php8.3-redis php8.3-uploadprogress php8.3-xml php8.3-zip php8.3-zstd
```

### PostgreSQL

- Добавить репозиторий и установить пакеты PostgreSQL:

```bash
. /etc/os-release; curl -fsSL 'https://www.postgresql.org/media/keys/ACCC4CF8.asc' | gpg --dearmor -o '/etc/apt/keyrings/pgsql.gpg' && echo "deb [signed-by=/etc/apt/keyrings/pgsql.gpg] https://apt.postgresql.org/pub/repos/apt ${VERSION_CODENAME}-pgdg main" | tee '/etc/apt/sources.list.d/pgsql.list' && apt update && apt install --yes postgresql-16
```

### TimescaleDB

- Добавить репозиторий и установить пакеты TimescaleDB `2.18.*`:

```bash
. /etc/os-release; curl -fsSL 'https://packagecloud.io/timescale/timescaledb/gpgkey' | gpg --dearmor -o '/etc/apt/keyrings/timescaledb.gpg' && echo "deb [signed-by=/etc/apt/keyrings/timescaledb.gpg] https://packagecloud.io/timescale/timescaledb/debian/ ${VERSION_CODENAME} main" | tee '/etc/apt/sources.list.d/timescaledb.list' && apt update && apt install --yes timescaledb-2-postgresql-16='2.18.*' timescaledb-2-loader-postgresql-16='2.18.*' timescaledb-tools
```

### Zabbix

- Добавить репозиторий и установить пакеты Zabbix:

```bash
. /etc/os-release; curl -fsSLo '/etc/apt/keyrings/zabbix.gpg' 'https://uaik.github.io/config/zabbix/zabbix.gpg' && echo "deb [signed-by=/etc/apt/keyrings/zabbix.gpg] https://repo.zabbix.com/zabbix/7.0/debian ${VERSION_CODENAME} main" | tee '/etc/apt/sources.list.d/zabbix.list' && apt update && apt install --yes zabbix-server-pgsql zabbix-frontend-php zabbix-sql-scripts zabbix-agent2
```

## Установка Zabbix

### Настройка базы данных

- Создать пользователя и базу данных `zabbix`, импортировать схему для базы данных `zabbix`:

```bash
u='zabbix'; sudo -u 'postgres' createuser --pwprompt "${u}" && sudo -u 'postgres' createdb -O "${u}" "${u}" && zcat '/usr/share/zabbix-sql-scripts/postgresql/server.sql.gz' | sudo -u "${u}" psql "${u}"
```

- Добавить расширение, импортировать схему TimescaleDB для базы данных `zabbix`:

```bash
u='zabbix'; echo 'CREATE EXTENSION IF NOT EXISTS timescaledb CASCADE;' | sudo -u 'postgres' psql "${u}" && cat '/usr/share/zabbix-sql-scripts/postgresql/timescaledb/schema.sql' | sudo -u "${u}" psql "${u}"
```

### Настройка Nginx

- Создать файл `zabbix.conf` со следующем содержимым:

{{< file "nginx.conf" "nginx" >}}

### Настройка PHP-FPM

- Создать файл `zabbix.conf` со следующем содержимым:

{{< file "php-fpm.conf" "ini" >}}

## Резервное копирование

```bash
f='zabbix.backup.sql'; pg_dump --host='127.0.0.1' --port='5432' --username='zabbix' --password --dbname='zabbix' --file="${f}" && xz "${f}" && rm -f "${f}"
```

## Восстановление

```bash
sudo -u 'postgres' dropdb 'zabbix'
```

```bash
sudo -u 'postgres' createdb -O 'zabbix' 'zabbix'
```

```bash
echo 'CREATE EXTENSION IF NOT EXISTS timescaledb CASCADE;' | sudo -u 'postgres' psql 'zabbix'
```

```bash
echo 'SELECT timescaledb_pre_restore();' | sudo -u 'postgres' psql 'zabbix'
```

```bash
f='zabbix.backup.sql'; xz -d "${f}.xz" && sudo -u 'postgres' psql --dbname='zabbix' --file="${f}"
```

```bash
echo 'SELECT timescaledb_post_restore();' | sudo -u 'postgres' psql 'zabbix'
```

```bash
sudo -u 'postgres' vacuumdb --all --analyze
```

## Обновление Zabbix

### Обновление пакетов

- Остановка служб Zabbix:

```bash
systemctl stop zabbix-server zabbix-agent2
```

- Обновление пакетов Zabbix:

```bash
apt update && apt install --only-upgrade zabbix-server-pgsql zabbix-frontend-php zabbix-sql-scripts zabbix-agent2
```

- Запуск служб Zabbix:

```bash
systemctl start zabbix-server zabbix-agent2
```

- Остановка служб Zabbix:

```bash
systemctl stop zabbix-server zabbix-agent2
```

- Обновление схемы TimescaleDB:

```bash
cat '/usr/share/zabbix-sql-scripts/postgresql/timescaledb/schema.sql' | sudo -u 'zabbix' psql 'zabbix'
```

{{< alert "tip" >}}
Если обновляются пакеты TimescaleDB, то по завершении процесса обновления, необходимо выполнить следующую команду:

```bash
echo "ALTER EXTENSION timescaledb UPDATE;" | sudo -u 'postgres' psql 'zabbix'
```

Эта команда обновит расширение TimescaleDB, подключённое к базе данных `zabbix`.
{{< /alert >}}

- Запуск служб Zabbix:

```bash
systemctl start zabbix-server zabbix-agent2
```
