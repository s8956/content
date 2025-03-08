---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'GitLab: Установка и настройка'
description: ''
images:
  - 'https://images.unsplash.com/photo-1531030874896-fdef6826f2f7'
categories:
  - 'linux'
  - 'terminal'
tags:
  - 'debian'
  - 'apt'
  - 'gitlab'
  - 'install'
authors:
  - 'KaiKimera'
sources:
  - 'https://gitlab.com/gitlab-org/gitlab/-/tree/master/lib/support/nginx'
license: 'CC-BY-SA-4.0'
complexity: '0'
toc: 1
comments: 1

# -------------------------------------------------------------------------------------------------------------------- #
# DATE
# -------------------------------------------------------------------------------------------------------------------- #

date: '2025-02-06T18:28:09+03:00'
publishDate: '2025-02-06T18:28:09+03:00'
lastMod: '2025-02-06T18:28:09+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: 'f2d035758435b182025dac2a22100055e6b81721'
uuid: 'f2d03575-8435-5182-925d-ac2a22100055'
slug: 'f2d03575-8435-5182-925d-ac2a22100055'

draft: 0
---

Инструкция по установке и первичной настройке {{< tag "GitLab" >}}.

<!--more-->

## Репозиторий

- Скачать и установить ключ репозитория:

```bash
 curl -fsSL 'https://lib.onl/ru/2025/02/f2d03575-8435-5182-925d-ac2a22100055/gitlab.asc' | gpg --dearmor -o '/etc/apt/keyrings/gitlab.gpg'
```

- Создать файл репозитория `/etc/apt/sources.list.d/gitlab.sources`:

```bash
 . '/etc/os-release' && echo -e "X-Repolib-Name: GitLab\nEnabled: yes\nTypes: deb\nURIs: https://packages.gitlab.com/gitlab/gitlab-ee/${ID}\n#URIs: https://mirror.yandex.ru/mirrors/packages.gitlab.com/gitlab/gitlab-ce\nSuites: ${VERSION_CODENAME}\nComponents: main\nArchitectures: $( dpkg --print-architecture )\nSigned-By: /etc/apt/keyrings/gitlab.gpg\n" | tee '/etc/apt/sources.list.d/gitlab.sources' > '/dev/null'
```

## Установка

- Установить пакеты:

```bash
 apt update && apt install --yes gitlab-ee
```

## Настройка

- Добавить в конец файла `/etc/gitlab/gitlab.rb` вызов локальной конфигурации:

```bash
 f='/etc/gitlab/gitlab.rb'; [[ -f "${f}" && ! -f "${f}.orig" ]] && mv "${f}" "${f}.orig" && cp "${f}.orig" "${f}" && echo -e '\nfrom_file "/etc/gitlab/gitlab.local.rb"\n' | tee -a "${f}" > '/dev/null'
```

- Скачать файл локальной конфигурации в `/etc/gitlab/`:

```bash
 f=('gitlab'); d='/etc/gitlab'; p='https://lib.onl/ru/2025/02/f2d03575-8435-5182-925d-ac2a22100055'; for i in "${f[@]}"; do curl -fsSLo "${d}/${i}.local.rb" "${p}/${i}.rb"; done
```

## Миграция на внешний Angie

- Установить {{< tag "Angie" >}} по материалу {{< uuid "b825cd19-f0f5-5a63-acb2-00784311b738" >}}.
- Скачать файл сайта `gitlab-ssl.conf` в `/etc/angie/http.d/`:

```bash
 f=('gitlab-ssl'); d='/etc/angie/http.d'; p='https://lib.onl/ru/2025/02/f2d03575-8435-5182-925d-ac2a22100055'; for i in "${f[@]}"; do curl -fsSLo "${d}/${i}.conf" "${p}/${i}.conf"; done
```

## Миграция на внешний PostgreSQL

- Установить {{< tag "PostgreSQL" >}} по материалу {{< uuid "9c234b3c-704e-599f-9fd9-b3fbb70f7897" >}}.

{{< alert "important" >}}
Необходимо внимательно подбирать версию PostgreSQL под [рекомендуемые требования](https://docs.gitlab.com/install/requirements/#postgresql) GitLab.
{{< /alert >}}

- Остановить все сервисы GitLab, кроме {{< tag "PostgreSQL" >}}:

```bash
gitlab-ctl stop && gitlab-ctl start postgresql && gitlab-ctl status
```

- Экспортировать базу данных `gitlabhq_production` в файл `/tmp/gitlabhq_production.sql`:

```bash
sudo -u 'gitlab-psql' /opt/gitlab/embedded/bin/pg_dump --host='/var/opt/gitlab/postgresql' --username='gitlab-psql' --dbname='gitlabhq_production' --clean --create --file='/tmp/gitlabhq_production.sql'
```

- Создать роль `gitlab` на внешнем {{< tag "PostgreSQL" >}}:

```bash
sudo -u 'postgres' createuser --pwprompt 'gitlab'
```

- Импортировать файл `/tmp/gitlabhq_production.sql` во внешний {{< tag "PostgreSQL" >}}:

```bash
sudo -u 'postgres' psql --file='/tmp/gitlabhq_production.sql'
```

- Создать расширения для базы данных `gitlabhq_production` во внешнем {{< tag "PostgreSQL" >}}:

```bash
echo 'create extension if not exists pg_trgm; create extension if not exists btree_gist; create extension if not exists plpgsql;' | sudo -u 'postgres' psql 'gitlabhq_production'
```

- Добавить настройки в файл конфигурации `/etc/gitlab/gitlab.rb`:

```ruby
postgresql['enable'] = false
gitlab_rails['db_adapter'] = 'postgresql'
gitlab_rails['db_encoding'] = 'unicode'
gitlab_rails['db_host'] = '/run/postgresql'
gitlab_rails['db_password'] = '*****'
```
