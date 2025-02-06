---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'OpenSearch: Установка и настройка'
description: ''
images:
  - 'https://images.unsplash.com/photo-1585776245991-cf89dd7fc73a'
categories:
  - 'linux'
  - 'terminal'
tags:
  - 'debian'
  - 'apt'
  - 'opensearch'
  - 'aws'
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

date: '2025-02-06T11:52:10+03:00'
publishDate: '2025-02-06T11:52:10+03:00'
lastMod: '2025-02-06T11:52:10+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '0c18558eb4e197131ead9b767d14e99c6d9ab85f'
uuid: '0c18558e-b4e1-5713-aead-9b767d14e99c'
slug: '0c18558e-b4e1-5713-aead-9b767d14e99c'

draft: 1
---



<!--more-->

## Репозиторий

### GPG

- Скачать и установить ключ репозитория:

```bash
curl -fsSL 'https://artifacts.opensearch.org/publickeys/opensearch.pgp' | gpg --dearmor -o '/etc/apt/keyrings/opensearch.gpg'
```

### APT

- Создать файл репозитория `/etc/apt/sources.list.d/opensearch.sources` со следующим содержимым:

{{< file "opensearch.sources" "text" >}}

## Установка

- Установить пакеты:

```bash
v='2.15.0'; apt update && apt install --yes opensearch=${v} && apt-mark hold opensearch=${v}
```

## Настройка

### Основная конфигурация

- Сохранить оригинальный файл конфигурации:

```bash
f='/etc/opensearch/opensearch.yml'; [[ -f "${f}" && ! -f "${f}.orig" ]] && mv "${f}" "${f}.orig"
```

- Создать файл основной конфигурации `/etc/opensearch/opensearch.yml` со следующим содержимым:

{{< file "opensearch.yml" >}}

### Дополнительная конфигурация

- Создать файл дополнительной конфигурации `/etc/opensearch/jvm.options.d/00.main.options` со следующим содержимым:

{{< file "opensearch.jvm.main.options" "text" >}}
