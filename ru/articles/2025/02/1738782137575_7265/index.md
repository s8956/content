---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'PHP: Установка и настройка'
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

date: '2025-02-05T22:02:21+03:00'
publishDate: '2025-02-05T22:02:21+03:00'
lastMod: '2025-02-05T22:02:21+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '9bd1261d38420859e2022e1d7a5ba9f44360148d'
uuid: '9bd1261d-3842-5859-8202-2e1d7a5ba9f4'
slug: '9bd1261d-3842-5859-8202-2e1d7a5ba9f4'

draft: 1
---



<!--more-->

## Репозиторий

### GPG

- Скачать и установить ключ репозитория:

```bash
curl -fSLo '/etc/apt/keyrings/php.gpg' 'https://packages.sury.org/php/apt.gpg'
```

### APT

- Создать файл репозитория `/etc/apt/sources.list.d/php.sources` со следующим содержимым:

{{< file "php.sources" "text" >}}

## Установка

- Установить пакеты:

```bash
v='8.4'; apt update && apt install --yes php${v}-fpm php${v}-bcmath php${v}-bz2 php${v}-cli php${v}-curl php${v}-gd php${v}-gmp php${v}-imagick php${v}-imap php${v}-intl php${v}-ldap php${v}-mbstring php${v}-memcached php${v}-mysql php${v}-odbc php${v}-opcache php${v}-pgsql php${v}-redis php${v}-uploadprogress php${v}-xml php${v}-zip php${v}-zstd
```

## Настройка

### Настройка PHP

- Создать файл `/etc/php/8.4/fpm/conf.d/php.local.ini` со следующим содержимым:

{{< file "php.local.ini" >}}

### Настройка PHP-FPM

{{< file "pool.www.conf" "ini" >}}
