---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Rsyslog: Установка и настройка'
description: ''
images:
  - 'https://images.unsplash.com/photo-1640552435388-a54879e72b28'
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

date: '2025-02-08T23:20:14+03:00'
publishDate: '2025-02-08T23:20:14+03:00'
lastMod: '2025-02-08T23:20:14+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: 'a931d52d3358f7f79c66b2bad6d3dcac838c0fb8'
uuid: 'a931d52d-3358-57f7-8c66-b2bad6d3dcac'
slug: 'a931d52d-3358-57f7-8c66-b2bad6d3dcac'

draft: 1
---



<!--more-->

## Репозиторий

### GPG

- Скачать и установить ключ репозитория:

```bash
. '/etc/os-release' && curl -fsSL "https://download.opensuse.org/repositories/home:rgerhards/Debian_${VERSION_ID}/Release.key" | gpg --dearmor -o '/etc/apt/keyrings/rsyslog.gpg'
```

### APT

- Создать файл репозитория `/etc/apt/sources.list.d/rsyslog.sources` со следующим содержимым:

```bash
. '/etc/os-release' && echo -e "X-Repolib-Name: Rsyslog\nEnabled: yes\nTypes: deb\nURIs: http://download.opensuse.org/repositories/home:/rgerhards/Debian_${VERSION_ID}/\nSuites: /\nArchitectures: $( dpkg --print-architecture )\nSigned-By: /etc/apt/keyrings/rsyslog.gpg\n" | tee '/etc/apt/sources.list.d/rsyslog.sources'
```

## Установка

- Установить пакеты:

```bash
apt update && apt install --yes rsyslog
```

## Настройка

### Основная конфигурация

- Создать файл основной конфигурации `/etc/rsyslog.d/00.main.conf` со следующим содержимым:

{{< file "rsyslog.main.conf" "text" >}}
