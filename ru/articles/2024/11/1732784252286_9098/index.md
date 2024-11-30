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

## Списки

- Посмотреть список баз данных:

```bash
sudo -u 'postgres' psql -c '\l'
```

- Посмотреть список ролей:

```bash
sudo -u 'postgres' psql -c '\du'
```

- Посмотреть список таблиц схемы `public` в базе данных `DB_NAME`:

```bash
sudo -u 'postgres' psql -c '\c DB_NAME' -c '\dt'
```

- Посмотреть список таблиц всех схем в базе данных `DB_NAME`:

```bash
sudo -u 'postgres' psql -c '\c DB_NAME' -c '\dt *.*'
```

## Создание

- Создать пользователя `DB_USER` с паролем:

```bash
sudo -u 'postgres' createuser --pwprompt 'DB_USER'
```

- Создать базу данных `DB_NAME` с владельцем `DB_USER`:

```bash
sudo -u 'postgres' createdb --owner='DB_USER' 'DB_NAME'
```

- Создать базу данных `DB_NAME` из шаблона `template0` с владельцем `DB_USER`:

```bash
sudo -u 'postgres' createdb --owner='DB_USER' --template='template0' 'DB_NAME'
```

## Удаление

- Удалить базу данных `DB_NAME`:

```bash
sudo -u 'postgres' dropdb 'DB_NAME'
```

- Удалить пользователя `DB_USER`:

```bash
sudo -u 'postgres' dropuser 'DB_USER'
```

## Резервное копирование

- Создать резервную копию базы данных `DB_NAME` при помощи пользователя `DB_USER` и записать в файл `backup.sql.xz`:

```bash
f='backup.sql'; pg_dump --host='127.0.0.1' --port='5432' --username='DB_USER' --password --dbname='DB_NAME' --file="${f}" && xz "${f}" && rm -f "${f}"
```

{{< alert "warning" >}}
Использовать перенаправление для резервного копирования и восстановления базы данных не рекомендуется. Резервная копия базы данных может оказаться повреждённой.
{{< /alert >}}

## Восстановление

- Удалить старую базу данных `DB_NAME` (при необходимости):

```bash
sudo -u 'postgres' dropdb 'DB_NAME'
```

- Создать новую базу данных `DB_NAME` с владельцем `DB_USER`:

```bash
sudo -u 'postgres' createdb --owner='DB_USER' 'DB_NAME'
```

- Восстановить данные в новую базу данных `DB_NAME` из файла `backup.sql.xz`:

```bash
f='backup.sql'; xz -d "${f}.xz" && sudo -u 'postgres' psql --dbname='DB_NAME' --file="${f}"
```

## Очистка и анализ

- Выполнить очистку и собрать статистику базы данных `DB_NAME`:

```bash
sudo -u 'postgres' vacuumdb --dbname='DB_NAME' --analyze
```

- Выполнить очистку и собрать статистику всех баз данных:

```bash
sudo -u 'postgres' vacuumdb --all --analyze
```

## Обновление кластера

{{< alert "important" >}}
В данном примере рассматривается сценарий обновления PostgreSQL **16** до PostgreSQL **17** на ОС **Debian**.
{{< /alert >}}

- Посмотреть список экземпляров PostgreSQL в кластере:

```bash
pg_lsclusters
```

- Установить новую версию PostgreSQL 17:

```bash
apt install postgresql-17
```

{{< accordion-item "TimescaleDB" >}}
- Установить новую версию TimescaleDB для PostgreSQL 17:

```bash
apt install timescaledb-2-postgresql-17 timescaledb-2-loader-postgresql-17
```

- Импортировать настройки TimescaleDB в конфигурацию PostgreSQL 17:

```bash
timescaledb-tune --quiet --yes && systemctl restart postgresql@17-main.service
```
{{< /accordion-item >}}

- Остановить новую версию экземпляра PostgreSQL 17 в кластере:

```bash
pg_dropcluster --stop 17 main
```

- Запустить обновление версии экземпляра PostgreSQL 16 до PostgreSQL 17 в кластере:

```bash
pg_upgradecluster 16 main
```

- Удалить версию экземпляра PostgreSQL 16 из кластера:

```bash
pg_dropcluster 16 main
```

- Посмотреть установленные пакеты для PostgreSQL 16 и удалить ненужные:

```bash
apt list --installed | grep 'postgresql.*-16'
```
