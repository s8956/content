---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Redis: Установка'
description: ''
images:
  - 'https://images.unsplash.com/photo-1640552435388-a54879e72b28'
categories:
  - 'linux'
  - 'terminal'
tags:
  - 'debian'
  - 'apt'
  - 'redis'
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

date: '2025-02-07T16:30:03+03:00'
publishDate: '2025-02-07T16:30:03+03:00'
lastMod: '2025-02-07T16:30:03+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '0b81ff23999199ccdc64370b86ad2263b5533c06'
uuid: '0b81ff23-9991-59cc-8c64-370b86ad2263'
slug: '0b81ff23-9991-59cc-8c64-370b86ad2263'

draft: 1
---



<!--more-->

## Репозиторий

### GPG

- Скачать и установить ключ репозитория:

```bash
curl -fsSL 'https://packages.redis.io/gpg' | gpg --dearmor -o '/etc/apt/keyrings/redis.gpg'
```

{{< alert "tip" >}}
Если оригинальный репозиторий недоступен, можно попробовать воспользоваться ключом `-x 'http://user:password@proxy.example.com:8080'` для **cURL**.
{{< /alert >}}

### APT

- Создать файл репозитория `/etc/apt/sources.list.d/redis.sources` со следующим содержимым:

```bash
. '/etc/os-release' && echo -e "X-Repolib-Name: Redis\nEnabled: yes\nTypes: deb\nURIs: https://packages.redis.io/deb\n#URIs: https://mirror.yandex.ru/mirrors/packages.redis.io\nSuites: ${VERSION_CODENAME}\nComponents: main\nArchitectures: $( dpkg --print-architecture )\nSigned-By: /etc/apt/keyrings/redis.gpg\n" | tee '/etc/apt/sources.list.d/redis.sources'
```

## Установка

- Установить пакеты:

```bash
apt update && apt install --yes redis
```
