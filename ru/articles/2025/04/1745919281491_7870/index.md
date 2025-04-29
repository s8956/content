---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: '1745919281491_7870'
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

date: '2025-04-29T12:34:44+03:00'
publishDate: '2025-04-29T12:34:44+03:00'
lastMod: '2025-04-29T12:34:44+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '96bdcb5ca58b88ae8e6b536b49bf1c512075ee8c'
uuid: '96bdcb5c-a58b-58ae-9e6b-536b49bf1c51'
slug: '96bdcb5c-a58b-58ae-9e6b-536b49bf1c51'

draft: 1
---



<!--more-->

- Установить пакеты:

```bash
apt install --yes clamdscan python3-venv
```

- Создать директорию `/var/lib/fangfrisch` и окружение:

```bash
d='/var/lib/fangfrisch'; mkdir -m 0770 "${d}" && chgrp 'clamav' "${d}" && cd "${d}" && python3 -m 'venv' 'venv' && source 'venv/bin/activate'
```

- Создать файл `/etc/fangfrisch.conf` со следующим содержанием:

{{< file "fangfrisch.conf" "ini" >}}

- Инициализировать базу данных:

```bash
sudo -u 'clamav' '/var/lib/fangfrisch/venv/bin/fangfrisch' --conf '/etc/fangfrisch.conf' initdb
```

- Обновить базу данных:

```bash
sudo -u 'clamav' '/var/lib/fangfrisch/venv/bin/fangfrisch' --conf '/etc/fangfrisch.conf' refresh
```

- Скачать файлы сервиса и таймера в `/etc/systemd/system`:

```bash
f=('fangfrisch.service' 'fangfrisch.timer'); d='/etc/systemd/system'; p='https://lib.onl/ru/2025/04/96bdcb5c-a58b-58ae-9e6b-536b49bf1c51'; for i in "${f[@]}"; do curl -fsSLo "${d}/${i}" "${p}/${i}"; done
```
