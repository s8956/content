---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'DB: Резервное копирование и восстановление базы данных'
description: ''
images:
  - 'https://images.unsplash.com/photo-1540396792185-d6bdfdc4cd3c'
categories:
  - 'linux'
  - 'scripts'
  - 'inDev'
tags:
  - 'debian'
  - 'gpg'
  - 'mariadb'
  - 'mysql'
  - 'openssl'
  - 'pgsql'
  - 'postgresql'
  - 'rsync'
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

Написал [скрипт](https://github.com/pkgstore/bash-backup-db), при помощи которого можно делать резервные копии баз данных {{< tag "PgSQL" >}} / {{< tag "MariaDB" >}} и отправлять их в удалённое хранилище через {{< tag "Rsync" >}}.

<!--more-->

## Установка

- Установить пакеты:

```bash
apt install --yes sshpass
```

- Скачать и распаковать скрипт:

```bash
export GH_NAME='bash-backup-db'; export GH_URL="https://github.com/pkgstore/${GH_NAME}/archive/refs/heads/main.tar.gz"; curl -Lo "${GH_NAME}-main.tar.gz" "${GH_URL}" && tar -xzf "${GH_NAME}-main.tar.gz" && chmod +x "${GH_NAME}-main"/*.sh
```

- Скопировать файлы `app.backup.db.conf` и `app.backup.db.sh` в директорию `/root/apps/backup/`.
- Скопировать файл `app_backup_db` в директорию `/etc/cron.d/`.
- Настроить параметры скрипта в файле `app.backup.db.conf`.

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

- `app.backup.db.conf` - файл с настройками.
- `app.backup.db.sh` - приложение.
- `app_backup_db` - задание для CRON.

### Настройка

{{< alert "tip" >}}
Некоторые параметры, указанные здесь, отсутствуют в конфигурационном файле. Это означает, что они имеют значения, установленные по умолчанию. Для переопределения этих значений, необходимо добавить отсутствующие параметры в конфигурационный файл.
{{< /alert >}}

- `DB_SRC` - массив названий баз данных для резервного копирования. Название базы данных должно содержать имя DBMS, разделённое точкой.
  - `mysql` - MySQL / MariaDB.
  - `pgsql` - PostgreSQL.
- `DB_DST` - директория для хранения дампов баз данных.
- `DB_HOST` - хост для соединения с DBMS. По умолчанию: `127.0.0.1`.
- `DB_PORT` - порт для соединения с DBMS. По умолчанию: `3306` (`mysql`) / `5432` (`pgsql`).
- `DB_USER` - имя пользователь для соединения с DBMS. По умолчанию: `root` (`mysql`) / `postgres` (`pgsql`).
- `DB_PASS` - пароль для соединения с DBMS.
- `FS_DAYS` - дни, по прошествии которых, старые файлы будут удалены. По умолчанию: `30`.
- `ENC_ON` - включение / отключение функции шифрования.
  - `0` - шифрование отключено.
  - `1` - шифрование включено.
- `ENC_APP` - приложение для шифрования.
  - `gpg` - для шифрования использовать OpenGPG.
  - `ssl` - для шифрования использовать OpenSSL.
- `ENC_PASS` - секретная фраза для шифрования.
- `ENC_GPG_CIPHER` - алгоритм симметричного шифрования GPG. По умолчанию: `AES256`.
- `ENC_GPG_DIGEST` - алгоритм хеша для преобразования секретной фразы при симметричном шифровании GPG. По умолчанию: `SHA512`.
- `ENC_GPG_COUNT` - указать, сколько циклов преобразования будет проходить секретная фраза для симметричного шифрования GPG. По умолчанию: `65536`.
- `ENC_SSL_CIPHER` - алгоритм симметричного шифрования SSL. По умолчанию: `aes-256-cfb`.
- `ENC_SSL_DIGEST` - алгоритм хеша для преобразования секретной фразы при симметричном шифровании SSL. По умолчанию: `sha512`.
- `ENC_SSL_COUNT` - указать, сколько циклов преобразования будет проходить секретная фраза для симметричного шифрования SSL. По умолчанию: `65536`.
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

### Задание

Задание запускает скрипт каждый день в `22:15` (после рабочего дня).

## Восстановление

Набор команд, описывающий алгоритм восстановления резервной копии базы данных.

### GPG

- Расшифровать архив базы данных `DB_NAME.sql.xz.gpg` при помощи секретной фразы `SECRET`:

```bash
f='DB_NAME.sql.xz.gpg'; p='SECRET'; gpg --batch --passphrase "${p}" --output "${f%.*}" --decrypt "${f}"
```

### OpenSSL

{{< alert "important" >}}
При использовании OpenSSL параметры дешифрования должны соответствовать параметрам шифрования. Без знания параметров шифрования, дешифровать данные не получится.
{{< /alert >}}

- Расшифровать архив базы данных `DB_NAME.sql.xz.ssl` при помощи секретной фразы `SECRET`, дайджеста (`-md`) `sha512` и количества итераций (`-iter`) `65536`:

```bash
f='DB_NAME.sql.xz.ssl'; p='SECRET'; openssl enc -aes-256-cfb -in "${f}" -out "${f%.*}" -pass "pass:${p}" -d -md 'sha512' -iter '65536' -salt -pbkdf2
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
