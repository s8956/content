---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'NodeJS: Установка'
description: ''
images:
  - 'https://images.unsplash.com/photo-1640552435388-a54879e72b28'
categories:
  - 'linux'
  - 'terminal'
tags:
  - 'debian'
  - 'apt'
  - 'nodejs'
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

date: '2025-02-08T00:00:51+03:00'
publishDate: '2025-02-08T00:00:51+03:00'
lastMod: '2025-02-08T00:00:51+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '138218c7d9a9aeeb44cf31ba8dc24896cc15f418'
uuid: '138218c7-d9a9-5eeb-a4cf-31ba8dc24896'
slug: '138218c7-d9a9-5eeb-a4cf-31ba8dc24896'

draft: 0
---

Инструкция по установке и первичной настройке {{< tag "NodeJS" >}}.

<!--more-->

## Репозиторий

- Скачать и установить ключ репозитория:

```bash
curl -fsSL 'https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key' | gpg --dearmor -o '/etc/apt/keyrings/nodesource.gpg'
```

- Создать файл репозитория `/etc/apt/sources.list.d/nodesource.sources`:

```bash
v='22'; echo -e "X-Repolib-Name: Node.js\nEnabled: yes\nTypes: deb\nURIs: https://deb.nodesource.com/node_${v}.x\nSuites: nodistro\nComponents: main\nArchitectures: $( dpkg --print-architecture )\nSigned-By: /etc/apt/keyrings/nodesource.gpg\n" | tee '/etc/apt/sources.list.d/nodesource.sources' > '/dev/null'
```

- Создать файлы предпочтений `/etc/apt/preferences.d/nsolid.pref` и `/etc/apt/preferences.d/nodejs.pref`:

```bash
echo -e "Package: nsolid\nPin: origin deb.nodesource.com\nPin-Priority: 600\n" | tee '/etc/apt/preferences.d/nsolid.pref' > '/dev/null' && echo -e "Package: nodejs\nPin: origin deb.nodesource.com\nPin-Priority: 600\n" | tee '/etc/apt/preferences.d/nodejs.pref' > '/dev/null'
```

## Установка

- Установить пакеты:

```bash
apt update && apt install --yes nodejs
```
