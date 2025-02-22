---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'OpenSearch: Установка и настройка'
description: ''
images:
  - 'https://images.unsplash.com/photo-1640552435388-a54879e72b28'
categories:
  - 'linux'
  - 'terminal'
tags:
  - 'debian'
  - 'apt'
  - 'opensearch'
  - 'aws'
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

draft: 0
---

Инструкция по установке и первичной настройке {{< tag "OpenSearch" >}}.

<!--more-->

## Репозиторий

- Скачать и установить ключ репозитория:

```bash
curl -fsSL 'https://artifacts.opensearch.org/publickeys/opensearch.pgp' | gpg --dearmor -o '/etc/apt/keyrings/opensearch.gpg'
```

- Создать файл репозитория `/etc/apt/sources.list.d/opensearch.sources` со следующим содержимым:

```bash
v='2'; . '/etc/os-release' && echo -e "X-Repolib-Name: OpenSearch\nEnabled: yes\nTypes: deb\nURIs: https://artifacts.opensearch.org/releases/bundle/opensearch/${v}.x/apt\nSuites: stable\nComponents: main\nArchitectures: $( dpkg --print-architecture )\nSigned-By: /etc/apt/keyrings/opensearch.gpg\n" | tee '/etc/apt/sources.list.d/opensearch.sources' > '/dev/null'
```

## Установка

- Установить пакеты:

```bash
v='2.15.0'; apt update && apt install --yes opensearch=${v} && apt-mark hold opensearch=${v}
```

## Настройка

В этом разделе приведена конфигурация с моими предпочтениями.

### Основная конфигурация

- Сохранить оригинальный файл конфигурации:

```bash
f='/etc/opensearch/opensearch.yml'; [[ -f "${f}" && ! -f "${f}.orig" ]] && mv "${f}" "${f}.orig"
```

- Создать файл основной конфигурации `/etc/opensearch/opensearch.yml` со следующим содержимым:

{{< file "opensearch.yml" "yaml" >}}

### Дополнительная конфигурация

- Создать файл дополнительной конфигурации `/etc/opensearch/jvm.options.d/99-jvm.local.options` со следующим содержимым:

{{< file "opensearch.jvm.local.options" >}}
