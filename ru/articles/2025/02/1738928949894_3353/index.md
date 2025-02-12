---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'MariaDB: Установка и настройка'
description: ''
images:
  - 'https://images.unsplash.com/photo-1640552435388-a54879e72b28'
categories:
  - 'linux'
  - 'terminal'
tags:
  - 'debian'
  - 'apt'
  - 'mariadb'
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

date: '2025-02-07T14:49:15+03:00'
publishDate: '2025-02-07T14:49:15+03:00'
lastMod: '2025-02-07T14:49:15+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '0068df20232a95a2548752dc746a4f472515fd55'
uuid: '0068df20-232a-55a2-a487-52dc746a4f47'
slug: '0068df20-232a-55a2-a487-52dc746a4f47'

draft: 1
---



<!--more-->

## Репозиторий

### GPG

- Скачать и установить ключ репозитория:

```bash
curl -fsSLo '/etc/apt/keyrings/mariadb.gpg' 'https://mariadb.org/mariadb_release_signing_key.pgp'
```

### APT

- Создать файл репозитория `/etc/apt/sources.list.d/mariadb.sources` со следующим содержимым:

```bash
v='11.4'; . '/etc/os-release' && echo -e "X-Repolib-Name: MariaDB\nEnabled: yes\nTypes: deb\nURIs: https://mirror.netcologne.de/mariadb/repo/${v}/${ID}\n#URIs: https://mirror.yandex.ru/mirrors/mariadb/repo/${v}/${ID}\nSuites: ${VERSION_CODENAME}\nComponents: main\nArchitectures: $( dpkg --print-architecture )\nSigned-By: /etc/apt/keyrings/mariadb.gpg\n" | tee '/etc/apt/sources.list.d/mariadb.sources' > '/dev/null'
```

## Установка

- Установить пакеты:

```bash
apt update && apt install --yes mariadb-server && systemctl stop mariadb.service
```

## Настройка

### Основная конфигурация

- Создать файл `/etc/mysql/mariadb.conf.d/99-server.local.cnf` для конфигурации `mariadbd` со следующим содержимым:

{{< file "mariadb.server.local.cnf" "ini" >}}

- Создать файл `/etc/mysql/mariadb.conf.d/99-mariadb-clients.local.cnf` для конфигурации клиентов со следующим содержимым:

{{< file "mariadb.mariadb-clients.local.cnf" "ini" >}}

- Удалить файлы в директории `/var/lib/mysql` и инициализировать стандартные базы данных:

```bash
rm -rf /var/lib/mysql/* && mariadb-install-db --user='mysql' && systemctl start mariadb.service
```

- Запустить скрипт безопасной установки:

```bash
mariadb-secure-installation && systemctl restart mariadb.service
```
