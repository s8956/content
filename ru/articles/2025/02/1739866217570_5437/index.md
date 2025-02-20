---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'iRedMail: Миграция на Angie и MariaDB'
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
a="$( curl -fsSL 'https://api.github.com/repos/iredmail/iRedMail/tags' )"; l="$( echo "${a}" | grep '"tarball_url":' | head -n 1 | cut -d '"' -f 4 )"; c="$( echo "${a}" | grep '"sha":' | head -n 1 | cut -d '"' -f 4 | head -c 7 )"; curl -fSLOJ "${l}" && tar -xzf ./*"${c}.tar.gz" && cd ./*"${c}" || exit
```

{{< alert "tip" >}}
Если требуется конкретная версия iRedMail, то можно воспользоваться следующей командой:

```bash
v='1.7.2'; curl -fSLo "iRedMail-${v}.tar.gz" "https://github.com/iredmail/iRedMail/archive/refs/tags/${v}.tar.gz" && tar -xzf "iRedMail-${v}.tar.gz" && cd "iRedMail-${v}" || exit
```
{{< /alert >}}

- Создать файл `config` в корневой директории iRedMail со следующим содержимым:

{{< file "irm.config" "bash" >}}

- Сделать экспорт базы данных текущей установки:

```bash
f='iRedMail.backup.sql'; mysqldump --user='root' --password --single-transaction --databases 'amavisd' 'fail2ban' 'iredadmin' 'iredapd' 'roundcubemail' 'vmail' | xz -9 > "${f}.xz"
```

## Миграция

### Angie

- Отключить Nginx:

```bash
systemctl disable --now nginx.service
```

- Установить Angie по материалу {{< uuid "b825cd19-f0f5-5a63-acb2-00784311b738" >}}.
- Создать файл `/etc/angie/http.d/iredmail.ssl.conf` со следующим содержимым:

{{< file "irm.angie.conf" "nginx" >}}

### PHP

- Удалить пакеты старой версии PHP:

```bash
apt purge --yes 'php8*' && apt autoremove && rm -rf '/etc/php'
```

- Установить новую версию PHP по материалу {{< uuid "9bd1261d-3842-5859-8202-2e1d7a5ba9f4" >}}.
- Создать файл `/etc/php/8.4/fpm/pool.d/iredmail.conf` со следующим содержимым:

{{< file "irm.php.pool.conf" "ini" >}}

### MariaDB

- Удалить пакеты старой версии СУБД MariaDB:

```bash
apt purge --yes 'mariadb-*' && apt autoremove && rm -rf '/etc/mysql'
```

- Установить новую версию СУБД MariaDB по материалу {{< uuid "0068df20-232a-55a2-a487-52dc746a4f47" >}}.
- Установить пакеты совместимости MariaDB с MySQL (`mariadb-*-compat`) и пакеты для работы Dovecot (`dovecot-mysql`), Postfix (`postfix-mysql`) и Amavis (`libdbd-mysql-perl`) с базой данных:

```bash
apt install --yes mariadb-server-compat mariadb-client-compat dovecot-mysql postfix-mysql libdbd-mysql-perl && systemctl restart dovecot.service postfix.service postfix@-.service
```

- Импортировать ранее созданный файл базы данных `iRedMail.backup.sql`:

```bash
f='iRedMail.backup.sql'; xzcat "${f}.xz" | mariadb --user='root' --password
```

{{< alert tip >}}
Если при импорте файла появляется ошибка `ERROR 1231 (42000) at line *: Variable 'sql_mode' can't be set to the value of 'NO_AUTO_CREATE_USER'`, то её можно исправить путём удаления директивы `NO_AUTO_CREATE_USER` из файла:

```bash
sed -i 's/NO_AUTO_CREATE_USER//' 'iRedMail.backup.sql'
```
{{< /alert >}}

- Создать технических пользователей iRedMail и присвоить им привилегии импортировав следующий файл:

{{< file "irm.mariadb.users.sql" "sql" >}}

### RoundCube

- Экспортировать заранее подготовленные параметры в переменные окружения, которые содержат информацию о старой версии `RC_OLD` и новой версии `RC_NEW` RoundCube:

```bash
export RC_OLD='1.6.9'; export RC_NEW='1.6.10'
```

- Запустить команду обновления RoundCube:

```bash
curl -fSLOJ "https://github.com/roundcube/roundcubemail/releases/download/${RC_NEW}/roundcubemail-${RC_NEW}-complete.tar.gz" && tar -xzf "roundcubemail-${RC_NEW}-complete.tar.gz" && mv "roundcubemail-${RC_NEW}" '/opt/www' && cp "/opt/www/roundcubemail-${RC_OLD}/config/config.inc.php" "/opt/www/roundcubemail-${RC_NEW}/config/config.inc.php" && "/opt/www/roundcubemail-${RC_NEW}/bin/update.sh" -v "${RC_OLD}" && chown -R root:root "/opt/www/roundcubemail-${RC_NEW}" && chown www-data:www-data "/opt/www/roundcubemail-${RC_NEW}"/{logs,temp,config/config.inc.php} && unlink '/opt/www/roundcubemail' && ln -s "/opt/www/roundcubemail-${RC_NEW}" '/opt/www/roundcubemail'
```

## Корректировка

### Fail2Ban

Если на почтовый адрес присылается уведомление `mysql: Deprecated program name. It will be removed in a future release, use '/usr/bin/mariadb' instead`, то необходимо выполнить следующую команду:

```bash
sed -i -e 's|CMD_SQL="mysql|CMD_SQL="mariadb|g' '/usr/local/bin/fail2ban_banned_db'
```

### ClamAV

Выполнить настройку российского зеркала обновлений ClamAV можно при помощи следующей команды:

```bash
sed -i -e 's|ScriptedUpdates yes|ScriptedUpdates no|g' '/etc/clamav/freshclam.conf' && echo -e 'PrivateMirror https://clamav-mirror.ru/\nPrivateMirror https://mirror.truenetwork.ru/clamav/\nPrivateMirror http://mirror.truenetwork.ru/clamav/\n' | tee -a '/etc/clamav/freshclam.conf' > '/dev/null' && rm -rf '/var/lib/clamav/freshclam.dat' && systemctl stop clamav-freshclam.service && freshclam -vvv && systemctl restart clamav-freshclam.service && systemctl restart clamav-daemon.service
```
