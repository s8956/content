---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Dovecot: Полнотекстовый поиск'
description: ''
images:
  - 'https://images.unsplash.com/photo-1620455800201-7f00aeef12ed'
categories:
  - 'linux'
  - 'terminal'
  - 'inDev'
tags:
  - 'debian'
  - 'email'
  - 'dovecot'
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

date: '2025-03-30T21:11:57+03:00'
publishDate: '2025-03-30T21:11:57+03:00'
lastMod: '2025-03-30T21:11:57+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '7d3b9bd5e43d42a7b662e58a0819c91aa3723680'
uuid: '7d3b9bd5-e43d-52a7-9662-e58a0819c91a'
slug: '7d3b9bd5-e43d-52a7-9662-e58a0819c91a'

draft: 0
---

Чем больше писем у пользователей, тем дольше выполняется поиск по ним. Поэтому, рекомендуется подключать полнотекстовый поиск.

<!--more-->

## Установка

- Установить пакеты:

```bash
apt install --yes -t 'stable-backports' dovecot-fts-xapian && apt install --yes xapian-tools
```

## Настойка

- Копировать файл `decode2text.sh` для расшифровки вложений в письмах в `/usr/local/bin/dovecot-decode2text.sh`:

```bash
cp '/usr/share/doc/dovecot-core/examples/decode2text.sh' '/usr/local/bin/dovecot-decode2text.sh'
```

- В файле `/etc/dovecot/conf.d/10-mail.conf` добавить в переменную `mail_plugins` плагины `fts fts_xapian`.
- Создать файл `/etc/dovecot/conf.d/90-fts.conf` со следующим содержанием:

{{< file "90-fts.conf" >}}

- Перезапустить сервис `dovecot` и запустить индексирование писем:

```bash
systemctl restart dovecot.service && doveadm index -A \*
```

## Задание

- Создать файл `/etc/cron.d/dovecot_fts_optimize` со следующим содержанием:

{{< file "dovecot_fts_optimize" "bash" >}}
