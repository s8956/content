---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Passenger: Установка'
description: ''
images:
  - 'https://images.unsplash.com/photo-1585776245991-cf89dd7fc73a'
categories:
  - 'linux'
  - 'terminal'
tags:
  - 'debian'
  - 'apt'
  - 'install'
  - 'phusion'
  - 'passenger'
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

date: '2025-02-12T17:31:31+03:00'
publishDate: '2025-02-12T17:31:31+03:00'
lastMod: '2025-02-12T17:31:31+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '8f5671bc0bad55b3962f1bc9b468b8e91f9456bc'
uuid: '8f5671bc-0bad-55b3-962f-1bc9b468b8e9'
slug: '8f5671bc-0bad-55b3-962f-1bc9b468b8e9'

draft: 1
---



<!--more-->

## Репозиторий

### GPG

- Скачать и установить ключ репозитория:

```bash
curl -fsSL 'https://oss-binaries.phusionpassenger.com/auto-software-signing-gpg-key.txt' | gpg --dearmor -o '/etc/apt/keyrings/phusion.gpg'
```

### APT

- Создать файл репозитория `/etc/apt/sources.list.d/phusion.sources` со следующим содержимым:

```bash
. '/etc/os-release' && echo -e "X-Repolib-Name: Phusion\nEnabled: yes\nTypes: deb\nURIs: https://oss-binaries.phusionpassenger.com/apt/passenger\nSuites: ${VERSION_CODENAME}\nComponents: main\nArchitectures: $( dpkg --print-architecture )\nSigned-By: /etc/apt/keyrings/phusion.gpg\n" | tee '/etc/apt/sources.list.d/phusion.sources'
```

## Установка

- Установить пакеты:

```bash
apt update && apt install --yes passenger
```

## Настройка

### Проверка установки

- После установки пакетов необходимо проверить корректность параметров Phusion Passenger:

```bash
/usr/bin/passenger-config validate-install
```
