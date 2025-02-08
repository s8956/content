---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'PHP: Установка и настройка'
description: ''
images:
  - 'https://images.unsplash.com/photo-1640552435388-a54879e72b28'
categories:
  - 'linux'
  - 'terminal'
tags:
  - 'debian'
  - 'apt'
  - 'php'
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

- Скачать и установить ключ репозитория с оригинального репозитория:

```bash
curl -x 'http://user:password@proxy.example.com:8080' -fsSLo '/etc/apt/keyrings/php.gpg' 'https://packages.sury.org/php/apt.gpg'
```

{{< alert "tip" >}}
Если оригинальный репозиторий недоступен, ключ можно скачать с зеркала:

```bash
curl -fsSLo '/etc/apt/keyrings/php.gpg' 'https://mirror.yandex.ru/mirrors/packages.sury.org/php/apt.gpg'
```

Или воспользоваться ключом `-x 'http://user:password@proxy.example.com:8080'` для **cURL**.
{{< /alert >}}

### APT

- Создать файл репозитория `/etc/apt/sources.list.d/php.sources` со следующим содержимым:

```bash
. '/etc/os-release' && echo -e "X-Repolib-Name: PHP\nEnabled: yes\nTypes: deb\nURIs: https://packages.sury.org/php\n#URIs: https://mirror.yandex.ru/mirrors/packages.sury.org/php\nSuites: ${VERSION_CODENAME}\nComponents: main\nArchitectures: $( dpkg --print-architecture )\nSigned-By: /etc/apt/keyrings/php.gpg\n" | tee '/etc/apt/sources.list.d/php.sources'
```

## Установка

- Установить пакеты:

```bash
v='8.4'; apt update && apt install --yes php${v}-fpm php${v}-bcmath php${v}-bz2 php${v}-cli php${v}-curl php${v}-gd php${v}-gmp php${v}-imagick php${v}-imap php${v}-intl php${v}-ldap php${v}-mbstring php${v}-memcached php${v}-mysql php${v}-odbc php${v}-opcache php${v}-pgsql php${v}-redis php${v}-uploadprogress php${v}-xml php${v}-zip php${v}-zstd
```

## Настройка

### Настройка PHP

- Создать файл `/etc/php/8.4/fpm/conf.d/00.main.ini` со следующим содержимым:

{{< file "php.main.ini" >}}

### Настройка PHP-FPM

- Создать файл `/etc/php/8.4/fpm/pool.d/www.conf` со следующим содержимым:

{{< file "php.pool.www.conf" "ini" >}}
