---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Caddy: Установка'
description: ''
images:
  - 'https://images.unsplash.com/photo-1640552435388-a54879e72b28'
categories:
  - 'linux'
  - 'terminal'
tags:
  - 'debian'
  - 'apt'
  - 'caddy'
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

date: '2025-02-07T23:31:30+03:00'
publishDate: '2025-02-07T23:31:30+03:00'
lastMod: '2025-02-07T23:31:30+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: 'b0b74e5bd8a4f9067c86e4e5d9c5d2e37eca0b1b'
uuid: 'b0b74e5b-d8a4-5906-ac86-e4e5d9c5d2e3'
slug: 'b0b74e5b-d8a4-5906-ac86-e4e5d9c5d2e3'

draft: 1
---



<!--more-->

## Репозиторий

### GPG

- Скачать и установить ключ репозитория:

```bash
curl -fsSL 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | gpg --dearmor -o '/etc/apt/keyrings/caddy.gpg'
```

### APT

- Создать файл репозитория `/etc/apt/sources.list.d/caddy.sources` со следующим содержимым:

```bash
. '/etc/os-release' && echo -e "X-Repolib-Name: Caddy\nEnabled: yes\nTypes: deb\nURIs: https://dl.cloudsmith.io/public/caddy/stable/deb/${ID}\nSuites: any-version\nComponents: main\nArchitectures: $( dpkg --print-architecture )\nSigned-By: /etc/apt/keyrings/caddy.gpg\n" | tee '/etc/apt/sources.list.d/caddy.sources'
```

## Установка

- Установить пакеты:

```bash
apt update && apt install --yes caddy
```
