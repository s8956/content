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
  - 'pgsql'
  - 'postgresql'
  - 'rsync'
  - 'openssl'
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

draft: 0
---

Написал скрипт, при помощи которого можно делать резервные копии баз данных {{< tag "PgSQL" >}} / {{< tag "MariaDB" >}} и отправлять их в удалённое хранилище через {{< tag "Rsync" >}}.

<!--more-->

## Установка

- Экспортировать параметры в переменные окружения и установить необходимые пакеты:

```bash
export LIB_SRC='https://lib.onl/ru/2025/05/57f8f8c0-b963-5708-b310-129ea98a2423' && apt install --yes sshpass
```

- Скопировать файлы `app.backup.sql.conf` и `app.backup.sql.sh` в директорию `/root/apps/backup/`.

```bash
f=('app.backup.sql.conf' 'app.backup.sql.sh'); d='/root/apps/backup'; [[ ! -d "${d}" ]] && mkdir -p "${d}"; [[ -f "${d}/${i}" && ! -f "${d}/${i}.orig" ]] && mv "${d}/${i}" "${d}/${i}.orig"; for i in "${f[@]}"; do curl -fsSLo "${d}/${i}" "${LIB_SRC}/${i}"; done && chmod +x "${d}"/*.sh
```

- Скопировать файл `app_backup_sql` в директорию `/etc/cron.d/`.

```bash
f=('app_backup_sql'); d='/etc/cron.d'; [[ -f "${d}/${i}" && ! -f "${d}/${i}.orig" ]] && mv "${d}/${i}" "${d}/${i}.orig"; for i in "${f[@]}"; do curl -fsSLo "${d}/${i}" "${LIB_SRC}/${i}"; done
```

- Настроить параметры скрипта в файле `app.backup.sql.conf`.

### MariaDB

- Создать пользователя `backup@127.0.0.1` с паролем `PASSWORD` и дать ему разрешения на все базы данных:

```bash
echo "create user 'backup'@'127.0.0.1' identified by 'PASSWORD'; grant all on *.* to 'backup'@'127.0.0.1'; flush privileges;" | mariadb --user='root' --password
```

### PostgreSQL

- Создать пользователя `backup` и сделать его супер-пользователем:

```bash
sudo -u 'postgres' createuser --pwprompt 'backup' && sudo -u 'postgres' psql -c 'alter role backup superuser;'
```

## Скрипт

Скрипт состоит из трёх компонентов:

- Файл с настройками.
- Приложение.
- Задание для CRON.

### Настройка

{{< file "app.backup.sql.conf" "ini" >}}

#### Параметры

{{< alert "tip" >}}
Некоторые параметры, указанные здесь, отсутствуют в конфигурационном файле. Это означает, что они имеют значения, установленные по умолчанию. Для переопределения этих значений, необходимо добавить отсутствующие параметры в конфигурационный файл.
{{< /alert >}}

- `SQL_SRC` - массив названий баз данных для резервного копирования. Название базы данных должно содержать имя DBMS, разделённое точкой.
  - `mysql` - MySQL / MariaDB.
  - `pgsql` - PostgreSQL.
- `SQL_DST` - директория для хранения дампов баз данных.
- `SQL_HOST` - хост для соединения с DBMS. По умолчанию: `127.0.0.1`.
- `SQL_PORT` - порт для соединения с DBMS. По умолчанию: `3306` (`mysql`) / `5432` (`pgsql`).
- `SQL_USER` - имя пользователь для соединения с DBMS. По умолчанию: `root` (`mysql`) / `postgres` (`pgsql`).
- `SQL_PASS` - пароль для соединения с DBMS.
- `SQL_DAYS` - дни, по прошествии которых, старые файлы будут удалены. По умолчанию: `30`.
- `ENC_PASS` - секретная фраза для шифрования.
- `ENC_S2K_CIPHER` - алгоритм симметричного шифрования. По умолчанию: `AES256`.
- `ENC_S2K_DIGEST` - алгоритм хеша для преобразования фраз-паролей при симметричном шифровании. По умолчанию: `SHA512`.
- `ENC_S2K_COUNT` - указать, сколько циклов преобразования будут проходить фразы-пароли для симметричного шифрования. По умолчанию: `65536`.
- `SYNC_ON` - включение / отключение функции синхронизации.
  - `0` - синхронизация отключена.
  - `1` - синхронизация включена.
- `SYNC_HOST` - IP-адрес удалённого хранилища для соединения по SSH.
- `SYNC_PORT` - порт удалённого хранилища для соединения по SSH. По умолчанию: `22`.
- `SYNC_USER` - имя пользователя удалённого хранилища для соединения по SSH. По умолчанию: `root`.
- `SYNC_PASS` - пароль пользователя удалённого хранилища для соединения по SSH.
- `SYNC_DST` - директория удалённого хранилища для синхронизации дампов базы данных.
- `SYNC_DEL` - параметр добавляет опцию `--delete`, которая удаляет посторонние файлы на удалённом хранилище.
  - `0` - опция отключена.
  - `1` - опция включена.
- `SYNC_RSF` - параметр добавляет опцию `--remove-source-files`, которая удаляет исходные файлы после синхронизации с удалённым хранилищем.
  - `0` - опция отключена.
  - `1` - опция включена.
- `SYNC_PED` - параметр добавляет опцию `--prune-empty-dirs`, которая исключает из процесса синхронизации пустые директории.
  - `0` - опция отключена.
  - `1` - опция включена.
- `SYNC_CVS` - параметр добавляет опцию `--cvs-exclude`, которая исключает из процесса синхронизации нежелательные элементы, например: `CWRCS`, `SCCS`, `CVS`, `CVS.adm`, `RCSLOG`, `cvslog.*`, `tags`, `TAGS`, `.make.state`, `.nse_depinfo`, `*~`, `#*`, `.#*`, `,*`, `_$*`, `*$`, `*.old`, `*.bak`, `*.BAK`, `*.orig`, `*.rej`, `.del-*`, `*.a`, `*.olb`, `*.o`, `*.obj`, `*.so`, `*.exe`, `*.Z`, `*.elc`, `*.ln`, `core`, `.svn/`, `.git/`, `.bzr/`.
  - `0` - опция отключена.
  - `1` - опция включена.

### Приложение

Приложение забирает параметры из файла настроек и обрабатывает значения.

{{< file "app.backup.sql.sh" "bash" >}}

### Задание

Задание запускает скрипт каждый день в `22:15` (после рабочего дня).

{{< file "app_backup_sql" "bash" >}}

## Восстановление

Набор команд, описывающий алгоритм восстановления резервной копии базы данных.

### GPG

- Расшифровать архив базы данных `DB_NAME.sql.xz.gpg` при помощи секретной фразы `SECRET`:

```bash
f='DB_NAME.sql.xz.gpg'; p='SECRET'; gpg --batch --passphrase "${p}" --output "${f%.*}" --decrypt "${f}"
```

### OpenSSL

- Расшифровать архив базы данных `DB_NAME.sql.xz.enc` при помощи секретной фразы `SECRET`:

```bash
f='DB_NAME.sql.xz.enc'; p='SECRET'; openssl enc -aes-256-cbc -d -salt -pbkdf2 -in "${f}" -out "${f%.*}" -pass "pass:${p}"
```

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
