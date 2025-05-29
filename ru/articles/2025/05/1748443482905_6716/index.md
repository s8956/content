---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Установка и настройка Bind9'
description: ''
images:
  - 'https://images.unsplash.com/photo-1585776245991-cf89dd7fc73a'
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

date: '2025-05-28T17:44:46+03:00'
publishDate: '2025-05-28T17:44:46+03:00'
lastMod: '2025-05-28T17:44:46+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '2e155edf9a477f8bf968a27047debf562a15d45e'
uuid: '2e155edf-9a47-5f8b-9968-a27047debf56'
slug: '2e155edf-9a47-5f8b-9968-a27047debf56'

draft: 1
---



<!--more-->

## Исходные данные

- IP-адрес DNS-сервера `NS01`: `192.168.1.2`.
- IP-адрес DNS-сервера `NS02`: `192.168.1.3`.
- IP-адрес домена `example.com`: `192.168.1.5`.
- IP-адрес домена `mail.example.com`: `192.168.1.6`.

## Установка

- Установить пакеты:

```bash
apt install --yes bind9
```

## Настройка

- Настроить Bind9 на режим работы только с адресами IPv4:

```bash
mv '/etc/default/named' '/etc/default/named.orig' && cp '/etc/default/named.orig' '/etc/default/named' && sed -i 's|-u bind|-u bind -4|g' '/etc/default/named'
```

### Первичный сервер DNS

- Сделать резервную копию файлов `named.conf.options` и `named.conf.default-zones`:

```bash
for i in 'named.conf.options' 'named.conf.default-zones'; do mv "/etc/bind/${i}" "/etc/bind/${i}.orig" && touch "/etc/bind/${i}"; done
```

- Привести файл `/etc/bind/named.conf.options` к следующему виду:

{{< file "named.conf.options" >}}

- Привести файл `/etc/bind/named.conf.default-zones` к следующему виду:

{{< file "named.conf.default-zones" >}}

- Добавить в файл `/etc/bind/named.conf.local` описание прямой и обратной зоны `example.com`:

{{< file "named.conf.local.master" >}}

- Создать файл прямой зоны `/etc/bind/db.example.com` со следующим содержанием:

{{< file "db.example.com" "dns" >}}

- Создать файл обратной зоны `/etc/bind/db.192.168.1` со следующим содержанием:

{{< file "db.192.168.1" "dns" >}}

### Вторичный сервер DNS

{{< file "named.conf.local.slave" >}}
