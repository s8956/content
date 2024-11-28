---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Работа с PostgreSQL'
description: ''
images:
  - 'https://images.unsplash.com/photo-1544383835-bda2bc66a55d'
categories:
  - 'linux'
  - 'terminal'
  - 'inDev'
tags:
  - 'postgresql'
authors:
  - 'KaiKimera'
sources:
  - 'https://www.postgresql.org/docs/current/app-createuser.html'
  - 'https://www.postgresql.org/docs/current/app-dropuser.html'
  - 'https://www.postgresql.org/docs/current/app-createdb.html'
  - 'https://www.postgresql.org/docs/current/app-pgdump.html'
  - 'https://www.postgresql.org/docs/current/app-pgrestore.html'
license: 'CC-BY-SA-4.0'
complexity: '0'
toc: 1
comments: 1

# -------------------------------------------------------------------------------------------------------------------- #
# DATE
# -------------------------------------------------------------------------------------------------------------------- #

date: '2024-11-28T11:57:34+03:00'
publishDate: '2024-11-28T11:57:34+03:00'
lastMod: '2024-11-28T11:57:34+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '3297173ead39b74fbcc6e4f5500968510a45dd71'
uuid: '3297173e-ad39-574f-9cc6-e4f550096851'
slug: '3297173e-ad39-574f-9cc6-e4f550096851'

draft: 0
---

Небольшая шпаргалка по работе с {{< tag "PostgreSQL" >}}.

<!--more-->

## Создание пользователя и БД 

- Создать пользователя `DB_USER` с паролем:

```bash
sudo -u 'postgres' createuser --pwprompt 'DB_USER'
```

- Создать базу данных `DB_NAME` с владельцем `DB_USER`:

```bash
sudo -u 'postgres' createdb -O 'DB_USER' 'DB_NAME'
```
## Удаление БД и пользователя

- Удалить базу данных `DB_NAME`:

```bash
sudo -u 'postgres' dropdb 'DB_NAME'
```

- Удалить пользователя `DB_USER`:

```bash
sudo -u 'postgres' dropuser 'DB_USER'
```

## Резервное копирование

- Создать резервную копию базы данных:

```bash
pg_dump --host='127.0.0.1' --port='5432' --username='DB_USER' --password --dbname='DB_NAME' | xz > 'backup.sql.xz'
```

## Восстановление

- Удалить старую базу данных `DB_NAME` (при необходимости):

```bash
sudo -u 'postgres' dropdb 'DB_NAME'
```

- Создать новую базу данных `DB_NAME` с владельцем `DB_USER`:

```bash
sudo -u 'postgres' createdb -O 'DB_USER' 'DB_NAME'
```

- Восстановить данные в новую базу данных:

```bash
xzcat 'backup.sql.xz' | sudo -u 'postgres' psql 'DB_NAME'
```