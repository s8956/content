---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Angie: Установка и настройка'
description: ''
images:
  - 'https://images.unsplash.com/photo-1640552435388-a54879e72b28'
categories:
  - 'linux'
  - 'terminal'
tags:
  - 'debian'
  - 'apt'
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

date: '2025-02-05T22:25:26+03:00'
publishDate: '2025-02-05T22:25:26+03:00'
lastMod: '2025-02-05T22:25:26+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: 'b825cd19f0f59a63ecb200784311b73801d0e56a'
uuid: 'b825cd19-f0f5-5a63-acb2-00784311b738'
slug: 'b825cd19-f0f5-5a63-acb2-00784311b738'

draft: 1
---



<!--more-->

## Репозиторий

### GPG

- Скачать и установить ключ репозитория:

```bash
curl -fsSLo '/etc/apt/keyrings/angie.gpg' 'https://angie.software/keys/angie-signing.gpg'
```

### APT

- Создать файл репозитория `/etc/apt/sources.list.d/angie.sources` со следующим содержимым:

```bash
. '/etc/os-release' && echo -e "X-Repolib-Name: Angie\nEnabled: yes\nTypes: deb\nURIs: https://download.angie.software/angie/${ID}/${VERSION_ID}\nSuites: ${ID}\nComponents: ${VERSION_CODENAME}\nArchitectures: $( dpkg --print-architecture )\nSigned-By: /etc/apt/keyrings/angie.gpg\n" | tee '/etc/apt/sources.list.d/angie.sources'
```

## Установка

- Установить пакеты:

```bash
apt update && apt install --yes angie angie-module-brotli angie-module-zstd
```

## Настройка

### Основная конфигурация

- Сохранить оригинальный файл конфигурации:

```bash
f='/etc/angie/angie.conf'; [[ -f "${f}" && ! -f "${f}.orig" ]] && mv "${f}" "${f}.orig"
```

- Создать файл основной конфигурации `/etc/angie/angie.conf` со следующим содержимым:

{{< file "angie.conf" "nginx" >}}

### Дополнительная конфигурация

- Создать директорию для дополнительной конфигурации:

```bash
d='/etc/angie/conf.d'; [[ ! -d "${d}" ]] && mkdir "${d}"
```

- Создать файл дополнительной конфигурации `/etc/angie/conf.d/00.main.conf` со следующим содержимым:

{{< file "angie.main.conf" "nginx" >}}

### Сайты

- Сохранить оригинальный файл стандартного сайта:

```bash
f='/etc/angie/http.d/default.conf'; [[ -f "${f}" && ! -f "${f}.orig" ]] && mv "${f}" "${f}.orig"
```

- Создать файл стандартного сайта (`80`) `/etc/angie/http.d/default.conf` со следующим содержимым:

{{< file "angie.http.default.conf" "nginx" >}}

- Создать файл стандартного сайта (`443`) `/etc/angie/http.d/default.ssl.conf` со следующим содержимым:

{{< file "angie.http.default.ssl.conf" "nginx" >}}
