---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Nginx: Установка'
description: ''
images:
  - 'https://images.unsplash.com/photo-1640552435388-a54879e72b28'
categories:
  - 'linux'
  - 'terminal'
tags:
  - 'debian'
  - 'apt'
  - 'nginx'
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

date: '2025-02-07T23:40:57+03:00'
publishDate: '2025-02-07T23:40:57+03:00'
lastMod: '2025-02-07T23:40:57+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: 'b1575a3b752b4fdf7e6b2ec04979e0f80f2c2fd7'
uuid: 'b1575a3b-752b-5fdf-be6b-2ec04979e0f8'
slug: 'b1575a3b-752b-5fdf-be6b-2ec04979e0f8'

draft: 1
---



<!--more-->

## Репозиторий

### GPG

- Скачать и установить ключ репозитория:

```bash
curl -fsSLo '/etc/apt/keyrings/nginx.gpg' 'https://packages.sury.org/nginx-mainline/apt.gpg'
```

{{< alert "tip" >}}
Если оригинальный репозиторий недоступен, ключ можно скачать с зеркала:

```bash
curl -fsSLo '/etc/apt/keyrings/nginx.gpg' 'https://mirror.yandex.ru/mirrors/packages.sury.org/nginx-mainline/apt.gpg'
```
{{< /alert >}}

### APT

- Создать файл репозитория `/etc/apt/sources.list.d/nginx.sources` со следующим содержимым:

```bash
. '/etc/os-release' && echo -e "X-Repolib-Name: Nginx\nEnabled: yes\nTypes: deb\nURIs: https://packages.sury.org/nginx-mainline\n#URIs: https://mirror.yandex.ru/mirrors/packages.sury.org/nginx-mainline\nSuites: ${VERSION_CODENAME}\nComponents: main\nArchitectures: $( dpkg --print-architecture )\nSigned-By: /etc/apt/keyrings/nginx.gpg\n" | tee '/etc/apt/sources.list.d/nginx.sources'
```

## Установка

- Установить пакеты:

```bash
apt update && apt install --yes nginx libnginx-mod-brotli
```
