---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Базовая конфигурация SQUID'
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

date: '2024-12-09T11:49:29+03:00'
publishDate: '2024-12-09T11:49:29+03:00'
lastMod: '2024-12-09T11:49:29+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '3e75ca13a07aedcd40715db0363ddea637b7879f'
uuid: '3e75ca13-a07a-5dcd-9071-5db0363ddea6'
slug: '3e75ca13-a07a-5dcd-9071-5db0363ddea6'

draft: 1
---



<!--more-->

## Установка

- Установить пакеты SQUID:

```bash
apt update && apt install --yes squid
```

## Конфигурация

- Заменить файл конфигурации `/etc/squid/squid.conf` на:

{{< file "squid.conf" "squid" >}}

### Параметры

Параметры, на которые стоит обратить внимание:

- `auth_param` - параметр авторизации.
  - `basic` - базовый.
    - `program /usr/lib/squid/basic_ncsa_auth /etc/squid/users.conf` - файл с паролями для пользователей.
    - `realm Proxy Server` - строка (название сервера), отображающаяся в форме ввода логина и пароля у клиента. По умолчанию: `Squid proxy-caching web server`.
- `acl` - список доступа.
  - `clients` - название списка доступа для авторизации пользователей БЕЗ ввода логина и пароля.
    - `src` - список IP-адресов пользователей для авторизации БЕЗ ввода логина и пароля.

## Пользователи

{{< file "users.conf" "text" >}}

https://hostingcanada.org/htpasswd-generator/

Bcrypt