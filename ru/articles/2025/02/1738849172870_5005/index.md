---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Graylog: Установка и настройка'
description: ''
images:
  - 'https://images.unsplash.com/photo-1640552435388-a54879e72b28'
categories:
  - 'linux'
  - 'terminal'
tags:
  - 'debian'
  - 'apt'
  - 'graylog'
  - 'mongodb'
  - 'angie'
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

date: '2025-02-06T16:39:35+03:00'
publishDate: '2025-02-06T16:39:35+03:00'
lastMod: '2025-02-06T16:39:35+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '21804a64d47aa563805047029e5cb5a3f5fddb1f'
uuid: '21804a64-d47a-5563-a050-47029e5cb5a3'
slug: '21804a64-d47a-5563-a050-47029e5cb5a3'

draft: 1
---



<!--more-->

## Репозиторий

### GPG

- Скачать и установить ключ репозитория:

```bash
curl -fsSLo '/etc/apt/keyrings/graylog.gpg' 'https://packages.graylog2.org/repo/debian/keyring.gpg'
```

{{< alert "tip" >}}
Если оригинальный репозиторий недоступен, можно попробовать воспользоваться ключом `-x 'http://user:password@proxy.example.com:8080'` для **cURL**.
{{< /alert >}}

### APT

- Создать файл репозитория `/etc/apt/sources.list.d/graylog.sources` со следующим содержимым:

```bash
v='6.1'; . '/etc/os-release' && echo -e "X-Repolib-Name: Graylog\nEnabled: yes\nTypes: deb\nURIs: https://packages.graylog2.org/repo/${ID}\nSuites: stable\nComponents: ${v}\nArchitectures: $( dpkg --print-architecture )\nSigned-By: /etc/apt/keyrings/graylog.gpg\n" | tee '/etc/apt/sources.list.d/graylog.sources'
```

## Установка

- Установить пакеты:

```bash
apt update && apt install --yes graylog-server
```

## Настройка

### Основная конфигурация

- Сохранить оригинальный файл конфигурации:

```bash
f='/etc/graylog/server/server.conf'; [[ -f "${f}" && ! -f "${f}.orig" ]] && mv "${f}" "${f}.orig"
```

- Создать файл основной конфигурации `/etc/graylog/server/server.conf` со следующим содержимым:

{{< file "graylog.server.conf" "ini" >}}

- Создать пароль для `password_secret`:

```bash
< '/dev/urandom' tr -dc 'A-Z-a-z-0-9' | head -c ${1:-96}; echo;
```

- Создать хэш пароля `password_secret` для `root_password_sha2`:

```bash
echo -n 'Enter Password: ' && head -1 < '/dev/stdin' | tr -d '\n' | sha256sum | cut -d ' ' -f1
```

### Конфигурация PROXY-сервера

- Создать файл сайта `/etc/angie/http.d/graylog.conf` со следующим содержимым:

{{< file "angie.http.graylog.conf" "nginx" >}}
