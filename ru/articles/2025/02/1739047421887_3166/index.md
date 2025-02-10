---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Syslog-NG: Установка'
description: ''
images:
  - 'https://images.unsplash.com/photo-1640552435388-a54879e72b28'
categories:
  - 'linux'
  - 'terminal'
tags:
  - 'debian'
  - 'apt'
  - 'syslog-ng'
  - 'syslog'
  - 'log'
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

date: '2025-02-08T23:43:42+03:00'
publishDate: '2025-02-08T23:43:42+03:00'
lastMod: '2025-02-08T23:43:42+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '24f7d6b6531f528386934ca9d034f604a509542a'
uuid: '24f7d6b6-531f-5283-b693-4ca9d034f604'
slug: '24f7d6b6-531f-5283-b693-4ca9d034f604'

draft: 1
---



<!--more-->

## Репозиторий

### GPG

- Скачать и установить ключ репозитория:

```bash
curl -fsSL 'https://ose-repo.syslog-ng.com/apt/syslog-ng-ose-pub.asc' | gpg --dearmor -o '/etc/apt/keyrings/syslog-ng.gpg'
```

### APT

- Создать файл репозитория `/etc/apt/sources.list.d/syslog-ng.sources` со следующим содержимым:

```bash
. '/etc/os-release' && echo -e "X-Repolib-Name: Syslog-NG\nEnabled: yes\nTypes: deb\nURIs: https://ose-repo.syslog-ng.com/apt\nSuites: stable\nComponents: ${ID}-${VERSION_CODENAME}\nArchitectures: $( dpkg --print-architecture )\nSigned-By: /etc/apt/keyrings/syslog-ng.gpg\n" | tee '/etc/apt/sources.list.d/syslog-ng.sources' > '/dev/null'
```

## Установка

- Установить пакеты:

```bash
apt update && apt install --yes syslog-ng
```

## Настройка

### Основная конфигурация

- Создать файл основной конфигурации `/etc/syslog-ng/conf.d/99-syslog-ng.local.conf` со следующим содержимым:

{{< file "syslog-ng.local.conf" "text" >}}
