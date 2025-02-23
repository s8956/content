---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'PostgreSQL: Установка и настройка'
description: ''
images:
  - 'https://images.unsplash.com/photo-1640552435388-a54879e72b28'
categories:
  - 'linux'
  - 'terminal'
tags:
  - 'debian'
  - 'apt'
  - 'postgresql'
  - 'install'
authors:
  - 'KaiKimera'
sources:
  - ''
license: 'CC-BY-SA-4.0'
complexity: '0'
toc: 1
comments: 1

# -------------------------------------------------------------------------------------------------------------------- #
# DATE
# -------------------------------------------------------------------------------------------------------------------- #

date: '2025-02-06T12:03:26+03:00'
publishDate: '2025-02-06T12:03:26+03:00'
lastMod: '2025-02-06T12:03:26+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '9c234b3c704e099f8fd9b3fbb70f789767f901b4'
uuid: '9c234b3c-704e-599f-9fd9-b3fbb70f7897'
slug: '9c234b3c-704e-599f-9fd9-b3fbb70f7897'

draft: 0
---

Инструкция по установке и первичной настройке {{< tag "PostgreSQL" >}}.

<!--more-->

## Репозиторий

- Скачать и установить ключ репозитория:

```bash
curl -fsSL 'https://www.postgresql.org/media/keys/ACCC4CF8.asc' | gpg --dearmor -o '/etc/apt/keyrings/pgsql.gpg'
```

- Создать файл репозитория `/etc/apt/sources.list.d/pgsql.sources`:

```bash
. '/etc/os-release' && echo -e "X-Repolib-Name: PostgreSQL\nEnabled: yes\nTypes: deb\nURIs: https://apt.postgresql.org/pub/repos/apt\n#URIs: https://mirror.yandex.ru/mirrors/postgresql\nSuites: ${VERSION_CODENAME}-pgdg\nComponents: main\nArchitectures: $( dpkg --print-architecture )\nSigned-By: /etc/apt/keyrings/pgsql.gpg\n" | tee '/etc/apt/sources.list.d/pgsql.sources' > '/dev/null'
```

## Установка

- Установить пакеты:

```bash
v='17'; apt update && apt install --yes postgresql-${v}
```

## Настройка

- Создать файл локальной конфигурации `/etc/postgresql/17/main/conf.d/99-pgsql.local.conf` со следующим содержимым:

{{< file "pgsql.local.conf" "ini" >}}
