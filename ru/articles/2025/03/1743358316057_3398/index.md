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
  - 'https://forum.iredmail.org/post88511.html#p88511'
  - 'https://github.com/grosjo/fts-xapian'
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

- Создать файл `/usr/lib/dovecot/decode2text.sh` со следующим содержанием:

{{< file "decode2text.sh" "bash" >}}

- Применить к файлу `/usr/lib/dovecot/decode2text.sh` бит исполнения:

```bash
chmod +x '/usr/lib/dovecot/decode2text.sh'
```

- В файле `/etc/dovecot/dovecot.conf` к директиве `mail_plugins` добавить `fts fts_xapian`.
- В файл `/etc/dovecot/dovecot.conf` добавить следующее содержимое:

{{< file "dovecot.conf" >}}

- Перезапустить сервис `dovecot` и запустить индексирование писем:

```bash
systemctl restart dovecot.service && doveadm index -A -q \*
```

## Задание

- Создать файл `/etc/cron.d/dovecot_fts_optimize` со следующим содержанием:

{{< file "dovecot_fts_optimize" "bash" >}}
