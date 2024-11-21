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

- Создание пользователя и базы данных:

```bash
sudo -u 'postgres' createuser --pwprompt 'zabbix' && sudo -u 'postgres' createdb -O 'zabbix' 'zabbix'
```

- Импортирование схемы базы данных:

```bash
zcat '/usr/share/zabbix-sql-scripts/postgresql/server.sql.gz' | sudo -u 'zabbix' psql 'zabbix'
```

- Добавление расширения TimescaleDB:

```bash
echo 'CREATE EXTENSION IF NOT EXISTS timescaledb CASCADE;' | sudo -u 'postgres' psql 'zabbix'
```

- Импортирование схемы TimescaleDB:

```bash
cat '/usr/share/zabbix-sql-scripts/postgresql/timescaledb/schema.sql' | sudo -u 'zabbix' psql 'zabbix'
```

- Обновление схемы TimescaleDB:

```bash
echo "ALTER EXTENSION timescaledb UPDATE;" | sudo -u 'postgres' psql 'zabbix'
```
