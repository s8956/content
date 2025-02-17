---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'GitLab: Миграция базы данных на внешний PostgreSQL'
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

date: '2025-02-17T14:04:35+03:00'
publishDate: '2025-02-17T14:04:35+03:00'
lastMod: '2025-02-17T14:04:35+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: 'c3cbba06c7067aa68be73de44ec51cf5f1a2e5b7'
uuid: 'c3cbba06-c706-5aa6-9be7-3de44ec51cf5'
slug: 'c3cbba06-c706-5aa6-9be7-3de44ec51cf5'

draft: 1
---



<!--more-->

- Останавливаем все сервисы GitLab, кроме PostgreSQL:

```bash
gitlab-ctl stop && gitlab-ctl start postgresql && gitlab-ctl status
```

- Экспортируем базу данных `gitlabhq_production` в файл `/tmp/gitlabhq_production.sql`:

```bash
sudo -u 'gitlab-psql' /opt/gitlab/embedded/bin/pg_dump --host='/var/opt/gitlab/postgresql' --username='gitlab-psql' --dbname='gitlabhq_production' --clean --create --file='/tmp/gitlabhq_production.sql'
```

- Создаём роль `gitlab` на внешнем PostgreSQL:

```bash
sudo -u 'postgres' createuser --pwprompt 'gitlab'
```

- Импортируем файл `/tmp/gitlabhq_production.sql` во внешний PostgreSQL:

```bash
sudo -u 'postgres' psql --file='/tmp/gitlabhq_production.sql'
```

- Создаём расширения для базы данных `gitlabhq_production` во внешнем PostgreSQL:

```bash
echo 'CREATE EXTENSION IF NOT EXISTS pg_trgm; CREATE EXTENSION IF NOT EXISTS btree_gist; CREATE EXTENSION IF NOT EXISTS plpgsql;' | sudo -u 'postgres' psql 'gitlabhq_production'
```

- Добавляем настройки в файл конфигурации `/etc/gitlab/gitlab.rb`:

```ruby
postgresql['enable'] = false
gitlab_rails['db_adapter'] = 'postgresql'
gitlab_rails['db_encoding'] = 'unicode'
gitlab_rails['db_host'] = '/run/postgresql'
gitlab_rails['db_password'] = '*****'
```
