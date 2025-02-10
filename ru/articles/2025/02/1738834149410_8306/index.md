---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'TimescaleDB: Установка'
description: ''
images:
  - 'https://images.unsplash.com/photo-1640552435388-a54879e72b28'
categories:
  - 'linux'
  - 'terminal'
tags:
  - 'debian'
  - 'apt'
  - 'timescale'
  - 'timescaledb'
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

date: '2025-02-06T12:29:15+03:00'
publishDate: '2025-02-06T12:29:15+03:00'
lastMod: '2025-02-06T12:29:15+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '5dfddacbebc0fc96f59839649fa484bc51568a83'
uuid: '5dfddacb-ebc0-5c96-9598-39649fa484bc'
slug: '5dfddacb-ebc0-5c96-9598-39649fa484bc'

draft: 1
---



<!--more-->

## Репозиторий

### GPG

- Скачать и установить ключ репозитория:

```bash
curl -fsSL 'https://packagecloud.io/timescale/timescaledb/gpgkey' | gpg --dearmor -o '/etc/apt/keyrings/timescaledb.gpg'
```

### APT

- Создать файл репозитория `/etc/apt/sources.list.d/timescaledb.sources` со следующим содержимым:

```bash
. '/etc/os-release' && echo -e "X-Repolib-Name: TimescaleDB\nEnabled: yes\nTypes: deb\nURIs: https://packagecloud.io/timescale/timescaledb/${ID}\nSuites: ${VERSION_CODENAME}\nComponents: main\nArchitectures: $( dpkg --print-architecture )\nSigned-By: /etc/apt/keyrings/timescaledb.gpg\n" | tee '/etc/apt/sources.list.d/timescaledb.sources' > '/dev/null'
```

## Установка

- Установить пакеты:

```bash
pgsql='17'; v='2.17.*'; apt update && apt install --yes timescaledb-2-postgresql-${pgsql}=${v} timescaledb-2-loader-postgresql-${pgsql}=${v} timescaledb-tools
```
