---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'iRedMail: Миграция на Angie и MariaDB 11'
description: ''
images:
  - 'https://images.unsplash.com/photo-1596563910641-86f6aebaab9a'
categories:
  - 'linux'
  - 'terminal'
tags:
  - 'debian'
  - 'apt'
  - 'install'
  - 'email'
  - 'iredmail'
authors:
  - 'KaiKimera'
sources:
  - ''
license: 'CC-BY-SA-4.0'
complexity: '1'
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

## Установка iRedMail

- Скачать и распаковать последнюю версию iRedMail:

```bash
url="$( curl -fsSL 'https://api.github.com/repos/iredmail/iRedMail/tags' | grep 'tarball_url' | head -n 1 | cut -d '"' -f 4 )"; v="$( echo "${url}" | cut -d '/' -f 10 )"; curl -fSLo "${HOME}/iRedMail-${v}.tar.gz" "${url}" && tar -xzf "${HOME}/iRedMail-${v}.tar.gz" && cd "${HOME}/iredmail-iRedMail-"* || exit
```

{{< alert "tip" >}}
Если требуется конкретная версия iRedMail, то можно воспользоваться следующей командой:

```bash
v='1.7.2'; curl -fSLo "${HOME}/iRedMail-${v}.tar.gz" "https://github.com/iredmail/iRedMail/archive/refs/tags/${v}.tar.gz" && tar -xzf "${HOME}/iRedMail-${v}.tar.gz" && cd "${HOME}/iRedMail-${v}"
```
{{< /alert >}}

- Создать файл `config` в корневой директории iRedMail со следующим содержимым:

{{< file "irm.config" "bash" >}}

- Сделать экспорт базы данных текущей установки:

```bash
f='iRedMail.backup.sql'; mysqldump --user='root' --password --single-transaction --databases 'amavisd' 'fail2ban' 'iredadmin' 'iredapd' 'roundcubemail' 'vmail' --result-file="${f}" && xz "${f}" && rm -f "${f}"
```

## Миграция на Angie

- Отключить Nginx:

```bash
systemctl disable --now nginx.service
```

- Установить Angie по материалу {{< uuid "b825cd19-f0f5-5a63-acb2-00784311b738" >}}.
- Создать файл `/etc/angie/http.d/iredmail.ssl.conf` со следующим содержимым:

{{< file "irm.angie.conf" "nginx" >}}

- Создать файл `/etc/php/8.2/fpm/pool.d/iredmail.conf` со следующим содержимым:

{{< file "irm.php.pool.conf" "ini" >}}

## Миграция на MariaDB 11

- Удалить пакеты СУБД MariaDB:

```bash
apt purge "mariadb-*" && apt autoremove
```

- Установить новую версию версию СУБД MariaDB по материалу {{< uuid "0068df20-232a-55a2-a487-52dc746a4f47" >}}.
- Установить пакеты совместимости MariaDB с MySQL и пакеты для работы Dovecot и Postfix с базой данных:

```bash
apt install --yes mariadb-server-compat mariadb-client-compat dovecot-mysql postfix-mysql && systemctl restart dovecot.service postfix.service postfix@-.service
```

- Импортировать ранее созданный файл базы данных `iRedMail.backup.sql`:

```bash
f='iRedMail.backup.sql'; xz -d "${f}.xz" && mariadb --user='root' --password < "${f}"
```

{{< alert tip >}}
Если при импорте файла появляется ошибка `ERROR 1231 (42000) at line *: Variable 'sql_mode' can't be set to the value of 'NO_AUTO_CREATE_USER'`, то её можно исправить путём удаления директивы `NO_AUTO_CREATE_USER` из файла:

```bash
sed -i 's/NO_AUTO_CREATE_USER//' 'iRedMail.backup.sql'
```
{{< /alert >}}

- Создать технических пользователей iRedMail и присвоить им привилегии импортировав следующий файл:

{{< file "irm.mariadb.users.sql" "sql" >}}

- Перенаправить вывод от команды `fail2ban_banned_db unban_db` в `/dev/null`:

```bash
crontab -l | sed -e 's|fail2ban_banned_db unban_db|fail2ban_banned_db unban_db >/dev/null|g' | crontab -
```
