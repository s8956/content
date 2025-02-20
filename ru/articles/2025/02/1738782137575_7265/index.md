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
  - 'inDev'
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

Добавляем официальный репозиторий разработчиков и далее по шагам выполним установку и настройку {{< tag "PHP" >}} и PHP-FPM.

### GPG

- Скачать и установить ключ репозитория с оригинального репозитория:

```bash
curl -x 'http://user:password@proxy.example.com:8080' -fsSLo '/etc/apt/keyrings/php.gpg' 'https://packages.sury.org/php/apt.gpg'
```

{{< alert "tip" >}}
Если оригинальный репозиторий недоступен, ключ можно скачать с зеркала:

```bash
curl -fsSLo '/etc/apt/keyrings/php.gpg' 'https://packages.sury.su/php/apt.gpg'
```

Или воспользоваться ключом `-x 'http://user:password@proxy.example.com:8080'` для **cURL**.
{{< /alert >}}

### APT

- Создать файл репозитория `/etc/apt/sources.list.d/php.sources` со следующим содержимым:

```bash
. '/etc/os-release' && echo -e "X-Repolib-Name: PHP\nEnabled: yes\nTypes: deb\nURIs: https://packages.sury.org/php\n#URIs: https://packages.sury.su/php\nSuites: ${VERSION_CODENAME}\nComponents: main\nArchitectures: $( dpkg --print-architecture )\nSigned-By: /etc/apt/keyrings/php.gpg\n" | tee '/etc/apt/sources.list.d/php.sources' > '/dev/null'
```

## Установка

- Установить пакеты:

```bash
v='8.4'; apt update && apt install --yes php${v} php${v}-{fpm,bcmath,bz2,cli,curl,gd,gmp,imagick,imap,intl,ldap,mbstring,memcached,mysql,odbc,opcache,pgsql,redis,uploadprogress,xml,zip,zstd}
```

## Настройка

В этом разделе приведена конфигурация с моими предпочтениями.

### PHP

- Создать файл `/etc/php/8.4/fpm/conf.d/99-php.local.ini` со следующим содержимым:

{{< file "php.local.ini" "ini" >}}

### PHP-FPM

- Сохранить оригинальный файл конфигурации:

```bash
f='/etc/php/8.4/fpm/pool.d/www.conf'; [[ -f "${f}" && ! -f "${f}.orig" ]] && mv "${f}" "${f}.orig"
```

- Создать файл `/etc/php/8.4/fpm/pool.d/www.conf` со следующим содержимым:

{{< file "php.pool.www.conf" "ini" >}}
