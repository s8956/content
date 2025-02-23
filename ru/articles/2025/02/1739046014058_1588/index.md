---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Rsyslog: Установка и настройка'
description: ''
images:
  - 'https://images.unsplash.com/photo-1640552435388-a54879e72b28'
categories:
  - 'linux'
  - 'terminal'
tags:
  - 'debian'
  - 'apt'
  - 'rsyslog'
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

draft: 0
---

Инструкция по установке и первичной настройке {{< tag "Rsyslog" >}}.

<!--more-->

## Репозиторий

- Скачать и установить ключ репозитория:

```bash
. '/etc/os-release' && curl -fsSL "https://download.opensuse.org/repositories/home:rgerhards/Debian_${VERSION_ID}/Release.key" | gpg --dearmor -o '/etc/apt/keyrings/rsyslog.gpg'
```

- Создать файл репозитория `/etc/apt/sources.list.d/rsyslog.sources`:

```bash
. '/etc/os-release' && echo -e "X-Repolib-Name: Rsyslog\nEnabled: yes\nTypes: deb\nURIs: http://download.opensuse.org/repositories/home:/rgerhards/Debian_${VERSION_ID}/\nSuites: /\nArchitectures: $( dpkg --print-architecture )\nSigned-By: /etc/apt/keyrings/rsyslog.gpg\n" | tee '/etc/apt/sources.list.d/rsyslog.sources' > '/dev/null'
```

## Установка

- Установить пакеты:

```bash
apt update && apt install --yes rsyslog
```

## Настройка

- Создать файл локальной конфигурации `/etc/rsyslog.d/99-rsyslog.local.conf` со следующим содержимым:

{{< file "rsyslog.local.conf" >}}
