---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'SQL: Резервное копирование и восстановление базы данных'
description: ''
images:
  - 'https://images.unsplash.com/photo-1540396792185-d6bdfdc4cd3c'
categories:
  - 'linux'
  - 'scripts'
  - 'inDev'
tags:
  - 'mariadb'
  - 'mysql'
  - 'postgresql'
authors:
  - 'KaiKimera'
sources:
  - 'https://dev.mysql.com/doc/refman/en/mysql.html'
  - 'https://dev.mysql.com/doc/refman/en/mysqldump.html'
  - 'https://mariadb.com/kb/en/mariadb-command-line-client'
  - 'https://mariadb.com/kb/en/mariadb-dump'
  - 'https://www.postgresql.org/docs/current/app-pgdump.html'
  - 'https://www.postgresql.org/docs/current/app-psql.html'
license: 'CC-BY-SA-4.0'
complexity: '0'
toc: 1
comments: 1

# -------------------------------------------------------------------------------------------------------------------- #
# DATE
# -------------------------------------------------------------------------------------------------------------------- #

date: '2025-05-07T23:39:24+03:00'
publishDate: '2025-05-07T23:39:24+03:00'
lastMod: '2025-05-07T23:39:24+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '57f8f8c0b963e708d310129ea98a2423766812bb'
uuid: '57f8f8c0-b963-5708-b310-129ea98a2423'
slug: '57f8f8c0-b963-5708-b310-129ea98a2423'

draft: 1
---



<!--more-->

## Установка

- Скопировать файлы `app.sql.backup.conf` и `app.sql.backup.sh` в директорию `/root/apps/sql/`.
- Указать бит выполнения для `*.sh` скриптов: `chmod +x /root/apps/sql/*.sh`.
- Скопировать файл `app_sql_backup` в директорию `/etc/cron.d/`.
- Настроить параметры скрипта в файле `app.sql.backup.conf`.

### MariaDB

- Создать пользователя `backup@127.0.0.1` с паролем `PASSWORD`:

```bash
echo "create user 'backup'@'127.0.0.1' identified by 'PASSWORD';" | mariadb --user='root' --password
```

- Дать все разрешения на все базы данных пользователю `backup@127.0.0.1`:

```bash
echo "grant all on *.* to 'backup'@'127.0.0.1'; flush privileges;" | mariadb --user='root' --password
```

### PostgreSQL

- Создать пользователя `backup` и сделать его супер-пользователем:

```bash
sudo -u 'postgres' createuser --pwprompt 'backup' && sudo -u 'postgres' psql -c 'alter role backup superuser;'
```

Создать файл `/root/.pgpass` со следующим содержанием (`PASSWORD` заменить на пароль пользователя `backup`):

```
127.0.0.1:5432:*:backup:PASSWORD
```

## Скрипт

Скрипт состоит из трёх компонентов:

- Файл с настройками.
- Приложение.
- Задание для CRON.

### Настройка

{{< file "app.sql.backup.conf" "ini" >}}

#### Параметры

{{< alert "tip" >}}
Некоторые параметры, указанные здесь, отсутствуют в конфигурационном файле. Это означает, что они имеют значения, установленные по умолчанию. Для переопределения этих значений, необходимо добавить отсутствующие параметры в конфигурационный файл.
{{< /alert >}}

- `SQL_TYPE` - тип базы данных.
  - `mysql` - MySQL / MariaDB.
  - `pgsql` - PostgreSQL.
- `SQL_DATA` - директория для хранения дампов базы данных.
- `SQL_DAYS` - дни, по прошествии которых, старые файлы будут удалены. По умолчанию: `30`.
- `SQL_HOST` - хост для соединения с базой данных. По умолчанию: `127.0.0.1`.
- `SQL_PORT` - порт для соединения с базой данных. По умолчанию: `3306` (`mysql`) / `5432` (`pgsql`).
- `SQL_USER` - имя пользователь для соединения с базой данных. По умолчанию: `root` (`mysql`) / `postgres` (`pgsql`).
- `SQL_PASS` - пароль для соединения с базой данных.
- `SQL_DB` - массив названий баз данных для резервного копирования.
- `SYNC_ON` - включение / отключение функции синхронизации.
  - `0` - синхронизация отключена.
  - `1` - синхронизация включена.
- `SYNC_HOST` - IP-адрес удалённого хранилища для соединения по SSH.
- `SYNC_PORT` - порт удалённого хранилища для соединения по SSH. По умолчанию: `22`.
- `SYNC_USER` - имя пользователя удалённого хранилища для соединения по SSH. По умолчанию: `root`.
- `SYNC_PASS` - пароль пользователя удалённого хранилища для соединения по SSH.
- `SYNC_DST` - директория удалённого хранилища для синхронизации дампов базы данных.

### Приложение

Приложение забирает параметры из файла настроек и обрабатывает значения.

{{< file "app.sql.backup.sh" "bash" >}}

### Задание

Задание запускает скрипт каждый день в `6:00` (перед рабочим днём) и в `22:00` (после рабочего дня).

{{< file "app_sql_backup" "bash" >}}

## Восстановление

Набор команд, описывающий алгоритм восстановления резервной копии базы данных.

### MariaDB

- Удалить базу данных `DB_NAME`:

```bash
echo 'drop database if exists DB_NAME;' | mariadb --user='root' --password
```

- Создать базу данных `DB_NAME` с кодировкой `utf8mb4` и сопоставлением `utf8mb4_unicode_ci`:

```bash
echo "create database if not exists DB_NAME character set 'utf8mb4' collate 'utf8mb4_unicode_ci';" | mariadb --user='root' --password
```

- Дать все права на базу данных `DB_NAME` пользователю `DB_USER`:

```bash
echo "grant all privileges on DB_NAME.* to 'DB_USER'@'127.0.0.1'; flush privileges;" | mariadb --user='root' --password
```

- Импортировать данные в новую базу данных `DB_NAME` из файла `DB_NAME.sql.xz`:

```bash
d='DB_NAME'; f="${d}.sql"; xz -d "${f}.xz" && mariadb --user='root' --password --database="${d}" < "${f}"
```

### PostgreSQL

- Удалить базу данных `DB_NAME`:

```bash
sudo -u 'postgres' dropdb --if-exists 'DB_NAME'
```

- Создать базу данных `DB_NAME` с владельцем `DB_USER`:

```bash
sudo -u 'postgres' createdb --owner='DB_USER' 'DB_NAME'
```

- Восстановить базу данных `DB_NAME` под пользователем `DB_USER` из файла `DB_NAME.sql.xz`:

```bash
u='DB_USER'; d='DB_NAME'; f="${d}.sql"; xz -d "${f}.xz" && psql --host='127.0.0.1' --port='5432' --username="${u}" --password --dbname="${d}" --file="${f}" --no-psqlrc --single-transaction
```
