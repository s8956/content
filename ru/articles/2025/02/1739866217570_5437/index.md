---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'iRedMail: Миграция'
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

date: '2025-02-18T11:10:20+03:00'
publishDate: '2025-02-18T11:10:20+03:00'
lastMod: '2025-02-18T11:10:20+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '7deb49abbb4ff0e6719682b4a9778a2d7166c1bb'
uuid: '7deb49ab-bb4f-50e6-b196-82b4a9778a2d'
slug: '7deb49ab-bb4f-50e6-b196-82b4a9778a2d'

draft: 1
---



<!--more-->

- Скачать и распаковать iRedMail:

```bash
v='1.7.2'; curl -fSLo "${HOME}/iRedMail-${v}.tar.gz" "https://github.com/iredmail/iRedMail/archive/refs/tags/${v}.tar.gz" && tar -xzf "${HOME}/iRedMail-${v}.tar.gz" && cd "${HOME}/iRedMail-${v}"
```

- Создать файл `config` в корневой директории iRedMail со следующим содержимым:

{{< file "irm.config" "bash" >}}

- Сделать экспорт базы данных текущей установки:

```bash
f='iRedMail.backup.sql'; mysqldump --user='root' --password --single-transaction --databases 'amavisd' 'fail2ban' 'iredadmin' 'iredapd' 'roundcubemail' 'vmail' --result-file="${f}" && xz "${f}" && rm -f "${f}"
```

- Отключить Nginx:

```bash
systemctl disable --now nginx.service
```

- Установить Angie по материалу {{< uuid "b825cd19-f0f5-5a63-acb2-00784311b738" >}}.
- Создать файл `/etc/angie/http.d/iredmail.ssl.conf` со следующим содержимым:

{{< file "irm.angie.conf" "nginx" >}}

- Создать файл `/etc/php/8.2/fpm/pool.d/iredmail.conf` со следующим содержимым:

{{< file "irm.php.pool.conf" "ini" >}}

- Удалить пакеты СУБД MariaDB:

```bash
apt purge "mariadb-*" && apt autoremove
```

- Установить новую версию версию СУБД MariaDB по материалу {{< uuid "0068df20-232a-55a2-a487-52dc746a4f47" >}}.
- Установить пакеты для работы Dovecot и Postfix с базой данных:

```bash
apt install --yes dovecot-mysql postfix-mysql && systemctl restart dovecot.service postfix.service postfix@-.service
```

- Импортировать ранее созданный файл базы данных `iRedMail.backup.sql`:

```bash
f='iRedMail.backup.sql'; xz -d "${f}.xz" && mariadb --user='root' --password < "${f}"
```

- Создать технических пользователей iRedMail при помощи импорта файла:

{{< file "irm.mariadb.users.sql" "sql" >}}
