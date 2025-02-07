---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'MariaDB: Установка и настройка'
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

date: '2025-02-07T14:49:15+03:00'
publishDate: '2025-02-07T14:49:15+03:00'
lastMod: '2025-02-07T14:49:15+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '0068df20232a95a2548752dc746a4f472515fd55'
uuid: '0068df20-232a-55a2-a487-52dc746a4f47'
slug: '0068df20-232a-55a2-a487-52dc746a4f47'

draft: 1
---



<!--more-->

## Репозиторий

### GPG

- Скачать и установить ключ репозитория:

```bash
curl -fsSLo '/etc/apt/keyrings/mariadb.gpg' 'https://mariadb.org/mariadb_release_signing_key.pgp'
```

### APT

- Создать файл репозитория `/etc/apt/sources.list.d/mariadb.sources` со следующим содержимым:

```bash
. '/etc/os-release'; v='11.4'; echo -e "X-Repolib-Name: MariaDB\nEnabled: yes\nTypes: deb\nURIs: https://mirror.netcologne.de/mariadb/repo/${v}/${ID}\n#URIs: https://mirror.yandex.ru/mirrors/mariadb/repo/${v}/${ID}\nSuites: ${VERSION_CODENAME}\nComponents: main\nArchitectures: $( dpkg --print-architecture )\nSigned-By: /etc/apt/keyrings/mariadb.gpg" | tee '/etc/apt/sources.list.d/mariadb.sources'
```

## Установка

- Установить пакеты:

```bash
apt update && apt install --yes mariadb-server
```
