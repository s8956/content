---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Zabbix: Установка и обновление'
description: ''
images:
  - 'https://images.unsplash.com/photo-1622533277534-e2b5f311bb60'
categories:
  - 'linux'
  - 'network'
tags:
  - 'zabbix'
  - 'debian'
  - 'angie'
  - 'php'
  - 'postgresql'
  - 'timescale'
  - 'timescaledb'
authors:
  - 'KaiKimera'
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

В этой заметке я устанавливаю Zabbix на ОС Debian с немного изменённым списком пакетов. Вместо Nginx я использую его форк **Angie**.

<!--more-->

## Установка пакетов

Необходимо установить пакеты для Angie, PHP, PostgreSQL, TimescaleDB и самого Zabbix. Пакет `zabbix-nginx-conf` не нужен, так как мы воссоздадим его конфигурацию на **Angie**.

- Добавить репозиторий и установить пакеты **Angie** по материалу {{< uuid "b825cd19-f0f5-5a63-acb2-00784311b738" >}}.
- Добавить репозиторий и установить пакеты **PHP-FPM** по материалу {{< uuid "9bd1261d-3842-5859-8202-2e1d7a5ba9f4" >}}.
- Добавить репозиторий и установить пакеты **PostgreSQL** по материалу {{< uuid "9c234b3c-704e-599f-9fd9-b3fbb70f7897" >}}.
- Добавить репозиторий и установить пакеты **TimescaleDB** по материалу {{< uuid "5dfddacb-ebc0-5c96-9598-39649fa484bc" >}}.
- Добавить репозиторий и установить пакеты **Zabbix**:

```bash
. /etc/os-release; curl -fsSL 'https://repo.zabbix.com/RPM-GPG-KEY-ZABBIX-B5333005' | gpg --dearmor -o '/etc/apt/keyrings/zabbix.gpg' && echo "deb [signed-by=/etc/apt/keyrings/zabbix.gpg] https://repo.zabbix.com/zabbix/7.0/debian ${VERSION_CODENAME} main" | tee '/etc/apt/sources.list.d/zabbix.list' && apt update && apt install --yes zabbix-server-pgsql zabbix-frontend-php zabbix-sql-scripts zabbix-agent2
```

## Установка Zabbix

Установка Zabbix состоит из этапов:

1. Настройка базы данных.
2. Настройка конфигурации Nginx (в данном случае Angie).
3. Настройка конфигурации PHP-FPM.

### Настройка базы данных

- Создать пользователя и базу данных `zabbix`, импортировать схему для базы данных `zabbix`:

```bash
u='zabbix'; sudo -u 'postgres' createuser --pwprompt "${u}" && sudo -u 'postgres' createdb -O "${u}" "${u}" && zcat '/usr/share/zabbix-sql-scripts/postgresql/server.sql.gz' | sudo -u "${u}" psql "${u}"
```

- Добавить расширение, импортировать схему TimescaleDB для базы данных `zabbix`:

```bash
u='zabbix'; echo 'CREATE EXTENSION IF NOT EXISTS timescaledb CASCADE;' | sudo -u 'postgres' psql "${u}" && cat '/usr/share/zabbix-sql-scripts/postgresql/timescaledb/schema.sql' | sudo -u "${u}" psql "${u}"
```

- Открыть файл `/etc/zabbix/zabbix_server.conf` и отредактировать параметр:

```ini
DBPassword=password
```

### Настройка Angie

- Создать файл `/etc/angie/http.d/zabbix.conf` со следующим содержанием:

{{< file "angie.zabbix.conf" "nginx" >}}

### Настройка PHP-FPM

- Создать файл `/etc/php/8.3/fpm/pool.d/zabbix.conf` со следующим содержанием:

{{< file "php-fpm.zabbix.conf" "ini" >}}

### Запуск мастера установки

- Перезапустить сервер Zabbix и сопутствующие службы:

```bash
systemctl restart zabbix-server zabbix-agent2 angie php${v}-fpm
```

- Включить автоматический запуск сервера Zabbix и сопутствующих служб:

```bash
systemctl enable zabbix-server zabbix-agent2 angie php${v}-fpm
```

- Для запуска мастера установки, необходимо в браузере открыть домен, указанный в конфигурации Angie.

## Резервное копирование

- Создать резервную копию базы данных `zabbix`:

```bash
f='zabbix.backup.sql'; pg_dump --host='127.0.0.1' --port='5432' --username='zabbix' --password --dbname='zabbix' --file="${f}" && xz "${f}" && rm -f "${f}"
```

## Восстановление

- Удалить существующую базу данных `zabbix`:

```bash
sudo -u 'postgres' dropdb 'zabbix'
```

- Создать новую базу данных `zabbix` с владельцем `zabbix`:

```bash
sudo -u 'postgres' createdb -O 'zabbix' 'zabbix'
```

- Создать расширение `timescaledb` для базы данных `zabbix`:

```bash
echo 'CREATE EXTENSION IF NOT EXISTS timescaledb CASCADE;' | sudo -u 'postgres' psql 'zabbix'
```

- Остановить процессы `timescaledb` в базе данных `zabbix` перед восстановлением:

```bash
echo 'SELECT timescaledb_pre_restore();' | sudo -u 'postgres' psql 'zabbix'
```

- Восстановить информацию в базе данных `zabbix` из файла `zabbix.backup.sql.xz`:

```bash
f='zabbix.backup.sql'; xz -d "${f}.xz" && sudo -u 'postgres' psql --dbname='zabbix' --file="${f}"
```

- Запустить процессы `timescaledb` после восстановления базы данных `zabbix`:

```bash
echo 'SELECT timescaledb_post_restore();' | sudo -u 'postgres' psql 'zabbix'
```

- Запустить Vacuum после восстановления базы данных `zabbix`:

```bash
sudo -u 'postgres' vacuumdb --all --analyze
```

## Обновление Zabbix

Обновление Zabbix состоит из двух этапов:

1. Остановка сервера Zabbix, обновление пакетов и запуск сервера Zabbix.
2. Остановка сервера Zabbix, обновление схемы TimescaleDB и запуск сервера Zabbix.

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

### Обновление TimescaleDB

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
