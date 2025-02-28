---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'iRedMail: Миграция на новые компоненты'
description: ''
images:
  - 'https://images.unsplash.com/photo-1596563910641-86f6aebaab9a'
categories:
  - 'linux'
  - 'terminal'
  - 'inDev'
tags:
  - 'debian'
  - 'apt'
  - 'install'
  - 'email'
  - 'iredmail'
  - 'roundcube'
  - 'iredadmin'
  - 'iredapd'
  - 'mlmmjadmin'
  - 'clamav'
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

draft: 0
---

Инструкция, которая позволит мигрировать компоненты {{< tag "iRedMail" >}}, устанавливаемые из стандартных репозиториев {{< tag "Debian" >}} на более новые версии из официальных репозиториев разработчиков. Все действия необходимо выполнять предельно аккуратно, понимая за что отвечает та или иная команда.

<!--more-->

## Установка iRedMail

- Скачать и распаковать последнюю версию {{< tag "iRedMail" >}}:

```bash
export GH_NAME='iRedMail'; export GH_API="gh.api.${GH_NAME}.json"; export IRM_DIR="${HOME}/iRM.iRedMail.$( date +%s )"; mkdir "${IRM_DIR}" && cd "${IRM_DIR}" && curl -fsSL "https://api.github.com/repos/iredmail/${GH_NAME}/tags" | tee "${GH_API}" > '/dev/null'; url="$( grep '"tarball_url":' < "${GH_API}" | head -n 1 | awk -F '"' '{ print $(NF-1) }' )"; ver="$( echo "${url}" | awk -F '/' '{ print $(NF) }' )"; cid="$( grep '"sha":' < "${GH_API}" | head -n 1 | awk -F '"' '{ print $(NF-1) }' | head -c 7 )"; curl -fSLOJ "${url}" && tar -xzf ./*"${cid}.tar.gz" && mv ./*"${cid}" "${GH_NAME}-${ver}" && cd "${GH_NAME}-${ver}" && curl -fsSLo 'config' 'https://lib.onl/ru/2025/02/7deb49ab-bb4f-50e6-b196-82b4a9778a2d/irm.config' || return
```

{{< alert "tip" >}}
Если требуется конкретная версия iRedMail, то можно воспользоваться командой:

```bash
v='1.7.2'; curl -fSLo "iRedMail-${v}.tar.gz" "https://github.com/iredmail/iRedMail/archive/refs/tags/${v}.tar.gz" && tar -xzf "iRedMail-${v}.tar.gz" && cd "iRedMail-${v}" || exit
```
{{< /alert >}}

- Создать файл `config` в корневой директории {{< tag "iRedMail" >}} со следующим шаблоном:

{{< file "irm.config" "bash" >}}

- Заполнить шаблон `config` своими параметрами.

{{< alert "tip" >}}
Для генерации паролей можно воспользоваться командой:

```bash
u=('MYSQL_ROOT_PASSWD' 'DOMAIN_ADMIN_PASSWD_PLAIN' 'SOGO_SIEVE_MASTER_PASSWD' 'AMAVISD_DB_PASSWD' 'FAIL2BAN_DB_PASSWD' 'IREDADMIN_DB_PASSWD' 'IREDAPD_DB_PASSWD' 'NETDATA_DB_PASSWD' 'RCM_DB_PASSWD' 'SOGO_DB_PASSWD' 'VMAIL_DB_ADMIN_PASSWD' 'VMAIL_DB_BIND_PASSWD'); for i in "${u[@]}"; do printf "%-25s = %s\n" "${i}" "$( < '/dev/urandom' tr -dc 'a-zA-Z0-9' | head -c "${1:-32}"; echo; )"; done
```
{{< /alert >}}

- Запустить установку {{< tag "iRedMail" >}}:

```bash
bash ./iRedMail.sh
```

## Миграция компонентов

Миграция со стандартных компонентов {{< tag "iRedMail" >}} на новые от официальных разработчиков.

### Angie

- Отключить {{< tag "Nginx" >}}:

```bash
systemctl disable --now nginx.service
```

- Установить {{< tag "Angie" >}} по материалу {{< uuid "b825cd19-f0f5-5a63-acb2-00784311b738" >}}.
- Создать файл `/etc/angie/http.d/iredmail-ssl.conf` со следующим содержимым:

{{< file "irm.angie.conf" "nginx" >}}

### PHP

- Установить новую версию {{< tag "PHP" >}} по материалу {{< uuid "9bd1261d-3842-5859-8202-2e1d7a5ba9f4" >}}.
- Создать файл `/etc/php/8.4/fpm/pool.d/iredmail.conf` со следующим содержимым:

{{< file "irm.php.pool.conf" "ini" >}}

- Удалить пакеты старой версии {{< tag "PHP" >}}:

```bash
apt purge --yes 'php8.2*' && apt autoremove
```

### MariaDB

- Сделать экспорт баз данных СУБД {{< tag "MariaDB" >}} в файл `iRedMail.backup.sql.xz`:

```bash
f='iRedMail.backup.sql.xz'; mysqldump --user='root' --password --single-transaction --databases 'amavisd' 'fail2ban' 'iredadmin' 'iredapd' 'roundcubemail' 'vmail' | xz -9 > "${f}"
```

- Удалить пакеты старой версии СУБД {{< tag "MariaDB" >}}:

```bash
apt purge --yes 'mariadb-*' && apt autoremove && rm -rf '/etc/mysql'
```

- Установить новую версию СУБД {{< tag "MariaDB" >}} по материалу {{< uuid "0068df20-232a-55a2-a487-52dc746a4f47" >}}.
- Установить пакеты совместимости {{< tag "MariaDB" >}} с {{< tag "MySQL" >}} (`mariadb-*-compat`) и пакеты для работы {{< tag "Dovecot" >}} (`dovecot-mysql`), {{< tag "Postfix" >}} (`postfix-mysql`) и {{< tag "Amavis" >}} (`libdbd-mysql-perl`) с базой данных:

```bash
apt install --yes mariadb-server-compat mariadb-client-compat dovecot-mysql postfix-mysql libdbd-mysql-perl && systemctl restart dovecot.service postfix.service postfix@-.service amavis.service
```

- Импортировать ранее созданный файл `iRedMail.backup.sql.xz` в новую версию СУБД {{< tag "MariaDB" >}}:

```bash
f='iRedMail.backup.sql.xz'; xzcat "${f}" | mariadb --user='root' --password
```

- Импортировать шаблон для создания технических пользователей {{< tag "iRedMail" >}}:

{{< file "irm.mariadb.create.user.sql" "sql" >}}

#### Особенности

Если на почтовый адрес присылаются уведомления `mysql: Deprecated program name. It will be removed in a future release, use '/usr/bin/mariadb' instead`, то необходимо выполнить команды для исправления файлов.

- Исправление файла `/usr/local/bin/fail2ban_banned_db`:

```bash
sed -i -e 's|CMD_SQL="mysql |CMD_SQL="mariadb |g' '/usr/local/bin/fail2ban_banned_db'
```

- Исправление файла `/var/vmail/backup/backup_mysql.sh`:

```bash
sed -i -e 's|CMD_MYSQL="mysql |CMD_MYSQL="mariadb |g' -e 's|CMD_MYSQLDUMP="mysqldump |CMD_MYSQLDUMP="mariadb-dump |g' '/var/vmail/backup/backup_mysql.sh'
```

## Миграция данных

Миграция данных со старого сервера на новый сервер.

### Миграция файлов

- Переместить ключи **DKIM** со старого сервера на новый сервер:

```bash
d='/var/lib/dkim/'; rsync -a -e 'ssh -p 22' "${d}" "root@192.168.1.2:${d}"
```

- Переместить базу данных **Fail2Ban** со старого сервера на новый сервер:

```bash
d='/var/lib/fail2ban/'; rsync -a -e 'ssh -p 22' "${d}" "root@192.168.1.2:${d}"
```

- Переместить профили пользователей и письма со старого сервера на новый сервер:

```bash
d='/var/vmail/vmail1/'; rsync -a -e 'ssh -p 22' "${d}" "root@192.168.1.2:${d}"
```

### Миграция баз данных

- Экспортировать базы данных старого сервера в файл `iRedMail.backup.sql.xz` и переместить на новый сервер:

```bash
f='iRedMail.backup.sql.xz'; mysqldump --user='root' --password --single-transaction --databases 'amavisd' 'fail2ban' 'iredadmin' 'iredapd' 'roundcubemail' 'vmail' | xz -9 > "${f}" && rsync -a -e 'ssh -p 22' "${f}" 'root@192.168.1.2:/root/'
```

- Удалить текущие пустые базы данных на новом сервере:

```bash
curl -fsSL 'https://lib.onl/ru/2025/02/7deb49ab-bb4f-50e6-b196-82b4a9778a2d/irm.mariadb.drop.database.sql' | mariadb --user='root' --password
```

- Импортировать файл `iRedMail.backup.sql.xz` с базами данных старого сервера на новом сервере:

```bash
f='iRedMail.backup.sql.xz'; xzcat "${f}" | mariadb --user='root' --password
```

{{< alert tip >}}
Если при импорте файла появляется ошибка `ERROR 1231 (42000) at line *: Variable 'sql_mode' can't be set to the value of 'NO_AUTO_CREATE_USER'`, то её можно исправить путём удаления директивы `NO_AUTO_CREATE_USER` из файла:

```bash
f='iRedMail.backup.sql'; xz -d "${f}.xz" && sed -i 's/NO_AUTO_CREATE_USER//' "${f}" && xz -9 "${f}"
```
{{< /alert >}}

- Импортировать шаблон для создания технических пользователей {{< tag "iRedMail" >}}:

{{< file "irm.mariadb.create.user.sql" "sql" >}}

- [Обновить](#схемы-баз-данных) схемы баз данных.

## Обновление компонентов

Автоматическое обновления стандартных компонентов {{< tag "iRedMail" >}} и обновление схемы БД по версиям.

### Схемы баз данных

Изменения схем баз данных по версиям {{< tag "iRedMail" >}}. Изменения необходимо вносить поэтапно от версии к версии.

- Экспортировать заранее подготовленные параметры в переменные окружения:

```bash
export GH_URL='https://raw.githubusercontent.com/iredmail/iRedMail/refs/heads/master/update'
```

#### Версии iRedMail

- `1.4.0`:

```bash
curl -fsSL "${GH_URL}/1.4.0/iredmail.mysql" | mariadb --user='root' --password --database='vmail'
```

- `1.4.1`:

```bash
curl -fsSL "${GH_URL}/1.4.1/iredmail.mysql" | mariadb --user='root' --password --database='vmail' && curl -fsSL "${GH_URL}/1.4.1/sogo.mysql" | mariadb --user='root' --password --database='sogo'
```

- `1.4.2`:

```bash
curl -fsSL "${GH_URL}/1.4.2/iredmail.mysql" | mariadb --user='root' --password --database='vmail'
```

- `1.6.3`:

```bash
curl -fsSL "${GH_URL}/1.6.3/iredmail.mysql" | mariadb --user='root' --password --database='vmail'
```

- `1.7.0`:

```bash
curl -fsSL "${GH_URL}/1.7.0/fail2ban.mysql" | mariadb --user='root' --password --database='fail2ban'
```

- `1.7.1`:

```bash
curl -fsSL "${GH_URL}/1.7.1/amavisd.mysql" | mariadb --user='root' --password --database='amavisd'
```

- `1.7.2`:

```bash
curl -fsSL "${GH_URL}/1.7.2/vmail.mysql" | mariadb --user='root' --password --database='vmail'
```

### RoundCube

- Экспортировать заранее подготовленные параметры в переменные окружения, которые содержат информацию о старой версии `RC_OLD` и новой версии `RC_NEW` {{< tag "RoundCube" >}}:

```bash
export RC_OLD='1.6.9'; export RC_NEW='1.6.10'
```

- Запустить команду обновления {{< tag "RoundCube" >}}:

```bash
export IRM_DIR="${HOME}/iRM.RoundCube.$( date +%s )"; mkdir "${IRM_DIR}" && cd "${IRM_DIR}" && curl -fSLOJ "https://github.com/roundcube/roundcubemail/releases/download/${RC_NEW}/roundcubemail-${RC_NEW}-complete.tar.gz" && tar -xzf "roundcubemail-${RC_NEW}-complete.tar.gz" && mv "roundcubemail-${RC_NEW}" '/opt/www' && cp "/opt/www/roundcubemail-${RC_OLD}/config/config.inc.php" "/opt/www/roundcubemail-${RC_NEW}/config/config.inc.php" && "/opt/www/roundcubemail-${RC_NEW}/bin/update.sh" -v "${RC_OLD}" && chown -R root:root "/opt/www/roundcubemail-${RC_NEW}" && chown www-data:www-data "/opt/www/roundcubemail-${RC_NEW}"/{logs,temp,config/config.inc.php} && unlink '/opt/www/roundcubemail' && ln -s "/opt/www/roundcubemail-${RC_NEW}" '/opt/www/roundcubemail'
```

### iRedAdmin

- Запустить команду обновления {{< tag "iRedAdmin" >}}:

```bash
export GH_NAME='iRedAdmin'; export GH_API="gh.api.${GH_NAME}.json"; export IRM_DIR="${HOME}/iRM.iRedAdmin.$( date +%s )"; mkdir "${IRM_DIR}" && cd "${IRM_DIR}" && curl -fsSL "https://api.github.com/repos/iredmail/${GH_NAME}/tags" | tee "${GH_API}" > '/dev/null'; url="$( grep '"tarball_url":' < "${GH_API}" | head -n 1 | awk -F '"' '{ print $(NF-1) }' )"; ver="$( echo "${url}" | awk -F '/' '{ print $(NF) }' )"; cid="$( grep '"sha":' < "${GH_API}" | head -n 1 | awk -F '"' '{ print $(NF-1) }' | head -c 7 )"; curl -fSLOJ "${url}" && tar -xzf ./*"${cid}.tar.gz" && mv ./*"${cid}" "${GH_NAME}-${ver}" && cd "${GH_NAME}-${ver}/tools/" && bash "upgrade_$( echo "${GH_NAME}" | tr '[:upper:]' '[:lower:]' ).sh"
```

### iRedAPD

- Запустить команду обновления {{< tag "iRedAPD" >}}:

```bash
export GH_NAME='iRedAPD'; export GH_API="gh.api.${GH_NAME}.json"; export IRM_DIR="${HOME}/iRM.iRedAPD.$( date +%s )"; mkdir "${IRM_DIR}" && cd "${IRM_DIR}" && curl -fsSL "https://api.github.com/repos/iredmail/${GH_NAME}/tags" | tee "${GH_API}" > '/dev/null'; url="$( grep '"tarball_url":' < "${GH_API}" | head -n 1 | awk -F '"' '{ print $(NF-1) }' )"; ver="$( echo "${url}" | awk -F '/' '{ print $(NF) }' )"; cid="$( grep '"sha":' < "${GH_API}" | head -n 1 | awk -F '"' '{ print $(NF-1) }' | head -c 7 )"; curl -fSLOJ "${url}" && tar -xzf ./*"${cid}.tar.gz" && mv ./*"${cid}" "${GH_NAME}-${ver}" && cd "${GH_NAME}-${ver}/tools/" && bash "upgrade_$( echo "${GH_NAME}" | tr '[:upper:]' '[:lower:]' ).sh"
```

### mlmmjadmin

- Запустить команду обновления {{< tag "mlmmjadmin" >}}:

```bash
export GH_NAME='mlmmjadmin'; export GH_API="gh.api.${GH_NAME}.json"; export IRM_DIR="${HOME}/iRM.mlmmjadmin.$( date +%s )"; mkdir "${IRM_DIR}" && cd "${IRM_DIR}" && curl -fsSL "https://api.github.com/repos/iredmail/${GH_NAME}/tags" | tee "${GH_API}" > '/dev/null'; url="$( grep '"tarball_url":' < "${GH_API}" | head -n 1 | awk -F '"' '{ print $(NF-1) }' )"; ver="$( echo "${url}" | awk -F '/' '{ print $(NF) }' )"; cid="$( grep '"sha":' < "${GH_API}" | head -n 1 | awk -F '"' '{ print $(NF-1) }' | head -c 7 )"; curl -fSLOJ "${url}" && tar -xzf ./*"${cid}.tar.gz" && mv ./*"${cid}" "${GH_NAME}-${ver}" && cd "${GH_NAME}-${ver}/tools/" && bash "upgrade_$( echo "${GH_NAME}" | tr '[:upper:]' '[:lower:]' ).sh"
```

### ClamAV

Выполнить настройку российского зеркала обновлений {{< tag "ClamAV" >}} можно при помощи следующей команды:

```bash
sed -i -e 's|ScriptedUpdates yes|ScriptedUpdates no|g' '/etc/clamav/freshclam.conf' && echo -e 'PrivateMirror https://clamav-mirror.ru/\nPrivateMirror https://mirror.truenetwork.ru/clamav/\nPrivateMirror http://mirror.truenetwork.ru/clamav/\n' | tee -a '/etc/clamav/freshclam.conf' > '/dev/null' && rm -rf '/var/lib/clamav/freshclam.dat' && systemctl stop clamav-freshclam.service && freshclam -vvv && systemctl restart clamav-freshclam.service && systemctl restart clamav-daemon.service
```
