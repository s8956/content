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

draft: 0
---

Инструкция по установке и первичной настройке {{< tag "PHP" >}}.

<!--more-->

## Репозиторий

- Скачать и установить ключ репозитория:

```bash
curl -fsSLo '/etc/apt/keyrings/php.gpg' 'https://lib.onl/ru/2025/02/9bd1261d-3842-5859-8202-2e1d7a5ba9f4/php.gpg'
```

{{< alert "tip" >}}
Ключ можно скачать с зеркала:

```bash
curl -fsSLo '/etc/apt/keyrings/php.gpg' 'https://packages.sury.su/php/apt.gpg'
```
{{< /alert >}}

- Создать файл репозитория `/etc/apt/sources.list.d/php.sources`:

```bash
. '/etc/os-release' && echo -e "X-Repolib-Name: PHP\nEnabled: yes\nTypes: deb\nURIs: https://packages.sury.org/php\n#URIs: https://packages.sury.su/php\nSuites: ${VERSION_CODENAME}\nComponents: main\nArchitectures: $( dpkg --print-architecture )\nSigned-By: /etc/apt/keyrings/php.gpg\n" | tee '/etc/apt/sources.list.d/php.sources' > '/dev/null'
```

## Установка

- Установить пакеты:

```bash
v='8.4'; apt update && apt install --yes php${v} php${v}-{fpm,bcmath,bz2,cli,curl,gd,gmp,imagick,imap,intl,ldap,mbstring,memcached,mysql,odbc,opcache,pgsql,redis,uploadprogress,xml,zip,zstd}
```

## Настройка

- Создать файл локальной конфигурации `/etc/php/8.4/fpm/conf.d/90-php.local.ini` со следующим содержимым:

{{< file "php.local.ini" "ini" >}}

- Сохранить оригинальный файл конфигурации:

```bash
f='/etc/php/8.4/fpm/pool.d/www.conf'; [[ -f "${f}" && ! -f "${f}.orig" ]] && mv "${f}" "${f}.orig"
```

- Создать файл `/etc/php/8.4/fpm/pool.d/www.conf` со следующим содержимым:

{{< file "php.pool.www.conf" "ini" >}}
