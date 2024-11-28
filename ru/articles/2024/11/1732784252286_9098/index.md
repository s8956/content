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

- Создать пользователя `PG_USER` с паролем:

```bash
sudo -u 'postgres' createuser --pwprompt 'PG_USER'
```

- Создать базу данных `PG_DB` с владельцем `PG_USER`:

```bash
sudo -u 'postgres' createdb -O 'PG_USER' 'PG_DB'
```
## Удаление БД и пользователя

- Удалить базу данных `PG_DB`:

```bash
sudo -u 'postgres' dropdb 'PG_DB'
```

- Удалить пользователя `PG_USER`:

```bash
sudo -u 'postgres' dropuser 'PG_USER'
```

## Резервное копирование

- Создать резервную копию базы данных в формате `directory`:

```bash
u='PG_USER'; db='PG_DB'; d="${HOME}/pgsql.${db}"; pg_dump -Fd --host='127.0.0.1' --port='5432' --username="${u}" --password --dbname="${db}" -f "${d}"
```

## Восстановление

- Удалить старую базу данных `PG_DB` (при необходимости):

```bash
sudo -u 'postgres' dropdb 'PG_DB'
```

- Создать новую базу данных `PG_DB` с владельцем `PG_USER`:

```bash
sudo -u 'postgres' createdb -O 'PG_USER' 'PG_DB'
```

- Восстановить данные новую базу данных из формата `directory`:

```bash
u='PG_USER'; db='PG_DB'; d="${HOME}/pgsql.${db}"; pg_restore -Fd --host='127.0.0.1' --port='5432' --username="${u}" --password --dbname="${db}" "${d}"
```
