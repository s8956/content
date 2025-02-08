---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'ElasticSearch: Установка и настройка'
description: ''
images:
  - 'https://images.unsplash.com/photo-1640552435388-a54879e72b28'
categories:
  - 'linux'
  - 'terminal'
tags:
  - 'debian'
  - 'apt'
  - 'elastic'
  - 'elasticsearch'
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

date: '2025-02-06T11:31:25+03:00'
publishDate: '2025-02-06T11:31:25+03:00'
lastMod: '2025-02-06T11:31:25+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '6542fa1441f4330978c0a3bac519b93d875214a4'
uuid: '6542fa14-41f4-5309-98c0-a3bac519b93d'
slug: '6542fa14-41f4-5309-98c0-a3bac519b93d'

draft: 1
---



<!--more-->

## Репозиторий

### GPG

- Скачать и установить ключ репозитория:

```bash
curl -fsSL 'https://artifacts.elastic.co/GPG-KEY-elasticsearch' | gpg --dearmor -o '/etc/apt/keyrings/elasticsearch.gpg'
```

### APT

- Создать файл репозитория `/etc/apt/sources.list.d/elasticsearch.sources` со следующим содержимым:

```bash
. '/etc/os-release'; v='8'; echo -e "X-Repolib-Name: ElasticSearch\nEnabled: yes\nTypes: deb\nURIs: https://artifacts.elastic.co/packages/${v}.x/apt\n#URIs: https://mirror.yandex.ru/mirrors/elastic/${v}\nSuites: stable\nComponents: main\nArchitectures: $( dpkg --print-architecture )\nSigned-By: /etc/apt/keyrings/elasticsearch.gpg" | tee '/etc/apt/sources.list.d/elasticsearch.sources'
```

## Установка

- Установить пакеты:

```bash
apt update && apt install --yes elasticsearch
```

## Настройка

### Основная конфигурация

- Сохранить оригинальный файл конфигурации:

```bash
f='/etc/elasticsearch/elasticsearch.yml'; [[ -f "${f}" && ! -f "${f}.orig" ]] && mv "${f}" "${f}.orig"
```

- Создать файл основной конфигурации `/etc/elasticsearch/elasticsearch.yml` со следующим содержимым:

{{< file "elasticsearch.yml" >}}

### Дополнительная конфигурация

- Создать файл дополнительной конфигурации `/etc/elasticsearch/jvm.options.d/00.main.options` со следующим содержимым:

{{< file "elasticsearch.jvm.main.options" "text" >}}
