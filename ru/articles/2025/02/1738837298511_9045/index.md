---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'MongoDB: Установка и настройка'
description: ''
images:
  - 'https://images.unsplash.com/photo-1640552435388-a54879e72b28'
categories:
  - 'linux'
  - 'terminal'
tags:
  - 'debian'
  - 'apt'
  - 'mongodb'
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

date: '2025-02-06T13:21:41+03:00'
publishDate: '2025-02-06T13:21:41+03:00'
lastMod: '2025-02-06T13:21:41+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '08fbbde770fc06d52a9e2f27ea376109f75fc22b'
uuid: '08fbbde7-70fc-56d5-aa9e-2f27ea376109'
slug: '08fbbde7-70fc-56d5-aa9e-2f27ea376109'

draft: 0
---

Инструкция по установке и первичной настройке {{< tag "MongoDB" >}}.

<!--more-->

## Репозиторий

- Скачать и установить ключ репозитория:

```bash
v='8.0'; curl -fsSL "https://lib.onl/ru/2025/02/08fbbde7-70fc-56d5-aa9e-2f27ea376109/mongodb-${v}.asc" | gpg --dearmor -o '/etc/apt/keyrings/mongodb.gpg'
```

- Создать файл репозитория `/etc/apt/sources.list.d/mongodb.sources` со следующим содержимым:

```bash
v='8.0'; . '/etc/os-release' && echo -e "X-Repolib-Name: MongoDB\nEnabled: yes\nTypes: deb\nURIs: http://repo.mongodb.org/apt/${ID}\n#URIs: https://mirror.yandex.ru/mirrors/repo.mongodb.org/apt/${ID}\nSuites: ${VERSION_CODENAME}/mongodb-org/${v}\nComponents: main\nArchitectures: $( dpkg --print-architecture )\nSigned-By: /etc/apt/keyrings/mongodb.gpg\n" | tee '/etc/apt/sources.list.d/mongodb.sources' > '/dev/null'
```

## Установка

- Установить пакеты:

```bash
apt update && apt install --yes mongodb-org
```

## Настройка

В этом разделе приведена конфигурация с моими предпочтениями.

### Основная конфигурация

- Сохранить оригинальный файл конфигурации:

```bash
f='/etc/mongod.conf'; [[ -f "${f}" && ! -f "${f}.orig" ]] && mv "${f}" "${f}.orig"
```

- Создать файл основной конфигурации `/etc/mongod.conf` со следующим содержимым:

{{< file "mongod.conf" "yml" >}}
