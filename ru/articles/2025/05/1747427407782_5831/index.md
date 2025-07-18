---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'FS: Резервное копирование файловой системы'
description: ''
images:
  - 'https://images.unsplash.com/photo-1721098935189-e3a2d4e1b99e'
categories:
  - 'linux'
  - 'scripts'
  - 'inDev'
tags:
  - 'debian'
  - 'gpg'
  - 'openssl'
  - 'rsync'
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

date: '2025-05-16T23:30:08+03:00'
publishDate: '2025-05-16T23:30:08+03:00'
lastMod: '2025-05-16T23:30:08+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '302e6636dc2135859bc9b8dd757b6ee1a8bc65e2'
uuid: '302e6636-dc21-5585-9bc9-b8dd757b6ee1'
slug: '302e6636-dc21-5585-9bc9-b8dd757b6ee1'

draft: 0
---

Сделал [скрипт](https://github.com/pkgstore/bash-backup-fs) для резервного копировать файловой системы. Скрипт может шифровать полученный архив и передавать его в удалённое хранилище.

<!--more-->

## Скрипт

Скрипт состоит из следующих компонентов:

- `app.backup_fs.conf` - файл с настройками.
- `app.backup_fs.sh` - приложение.
- `job.backup_fs` - задание для CRON.

### Установка

- Скачать и установить скрипт:

```bash
curl -sL 'https://raw.githubusercontent.com/pkgstore/bash-install/refs/heads/main/install.sh' | bash -s -- '/root/apps/backup' 'bash-backup-fs' 'main'
```

### Настройка

{{< alert "tip" >}}
Некоторые параметры, указанные здесь, отсутствуют в конфигурационном файле. Это означает, что они имеют значения, установленные по умолчанию. Для переопределения этих значений, необходимо добавить отсутствующие параметры в конфигурационный файл.
{{< /alert >}}

#### Архивация

- `FS_SRC=('/etc' '/opt')` - массив с путями директорий для резервного копирования.
- `FS_DST='/tmp/backup_fs'` - директория для хранения резервных копий.
- `FS_TPL="$( date -u '+%m' )/$( date -u '+%d' )-$( date -u '+%H' )" `- шаблон структуры директорий для хранения архивов с резервной копией файлов.

#### Шифрование

Параметры шифрования резервной копии файлов.

- `ENC_ON=0` - включение / отключение функции шифрования.
- `ENC_APP='gpg'` - приложение для шифрования.
  - `gpg` - для шифрования использовать OpenGPG.
  - `ssl` - для шифрования использовать OpenSSL.
- `ENC_PASS='SECRET'` - секретная фраза для шифрования.
- `ENC_GPG_CIPHER='AES256'` - алгоритм симметричного шифрования GPG. По умолчанию: `AES256`.
- `ENC_GPG_DIGEST='SHA512'` - алгоритм хеша для преобразования секретной фразы при симметричном шифровании GPG. По умолчанию: `SHA512`.
- `ENC_GPG_COUNT='65536'` - указать, сколько циклов преобразования будет проходить секретная фраза для симметричного шифрования GPG. По умолчанию: `65536`.
- `ENC_SSL_CIPHER='aes-256-cfb'` - алгоритм симметричного шифрования SSL. По умолчанию: `aes-256-cfb`.
- `ENC_SSL_DIGEST='sha512'` - алгоритм хеша для преобразования секретной фразы при симметричном шифровании SSL. По умолчанию: `sha512`.
- `ENC_SSL_COUNT='65536'` - указать, сколько циклов преобразования будет проходить секретная фраза для симметричного шифрования SSL. По умолчанию: `65536`.

#### SSH FS

Параметры монтирования удалённого хранилища при помощи `sshfs`.

- `SSH_ON=0` - включение / отключение функции монтирования удалённого хранилища при помощи `sshfs`.
- `SSH_HOST='192.168.1.2'` - IP-адрес удалённого хранилища для соединения по SSH.
- `SSH_PORT='22'` - порт удалённого хранилища для соединения по SSH. По умолчанию: `22`.
- `SSH_USER='root'` - имя пользователя удалённого хранилища для соединения по SSH. По умолчанию: `root`.
- `SSH_PASS='PASSWORD'` - пароль пользователя удалённого хранилища для соединения по SSH.
- `SSH_DST='/remote/directory'` - директория удалённого хранилища для синхронизации дампов базы данных.
- `SSH_MNT='/mnt/backup'` - директория, в которую будет монтироваться удалённое хранилище.

#### RSYNC

Параметры синхронизации резервной копии файлов с удалённым хранилищем (используется `rsync`).

- `RSYNC_ON=0` - включение / отключение функции синхронизации.
- `RSYNC_HOST='192.168.1.2'` - IP-адрес удалённого хранилища для соединения по SSH.
- `RSYNC_PORT='22'` - порт удалённого хранилища для соединения по SSH. По умолчанию: `22`.
- `RSYNC_USER='root'` - имя пользователя удалённого хранилища для соединения по SSH. По умолчанию: `root`.
- `RSYNC_PASS='PASSWORD'` - пароль пользователя удалённого хранилища для соединения по SSH.
- `RSYNC_DST='/remote/directory'` - директория удалённого хранилища для синхронизации дампов базы данных.
- `RSYNC_DEL=0` - параметр добавляет опцию `--delete`, которая удаляет посторонние файлы на удалённом хранилище.
- `RSYNC_RSF=0` - параметр добавляет опцию `--remove-source-files`, которая удаляет исходные файлы после синхронизации с удалённым хранилищем.
- `RSYNC_PED=0` - параметр добавляет опцию `--prune-empty-dirs`, которая исключает из процесса синхронизации пустые директории.
- `RSYNC_CVS=0` - параметр добавляет опцию `--cvs-exclude`, которая исключает из процесса синхронизации нежелательные элементы, например: `CWRCS`, `SCCS`, `CVS`, `CVS.adm`, `RCSLOG`, `cvslog.*`, `tags`, `TAGS`, `.make.state`, `.nse_depinfo`, `*~`, `#*`, `.#*`, `,*`, `_$*`, `*$`, `*.old`, `*.bak`, `*.BAK`, `*.orig`, `*.rej`, `.del-*`, `*.a`, `*.olb`, `*.o`, `*.obj`, `*.so`, `*.exe`, `*.Z`, `*.elc`, `*.ln`, `core`, `.svn/`, `.git/`, `.bzr/`.

#### Mail

- `MAIL_ON=0` - включение / отключение функции отправки сообщений на электронную почту.
- `MAIL_FROM='mail@example.org'` - адрес отправителя.
- `MAIL_TO=('mail@example.com' 'mail@example.info')` - массив адресов получателей.
- `MAIL_SMTP_SERVER='smtp[s]://[USER[:PASS]@]SERVER[:PORT]'` - адрес внешнего SMTP-сервера с авторизацией.
- `MAIL_SMTP_AUTH='none'` - тип авторизации на внешний SMTP-сервер. По умолчанию: `none`. Принимаемые значения: `none`, `plain`, `login`, `oauthbearer`.

#### GitLab

- `GITLAB_ON=0` - включение / отключение функции отправки сообщений в GitLab.
- `GITLAB_API='http://example.org/api/v4'` - API URL.
- `GITLAB_PROJECT='0'` - ID проекта.
- `GITLAB_TOKEN='TOKEN'` - токен пользователя.

### Приложение

Приложение забирает параметры из файла настроек и обрабатывает значения.

### Задание

Задание запускает скрипт каждое воскресенье в `01:15`.

## Восстановление

Набор команд, описывающий алгоритм восстановления резервной копии файлов.

### GPG

- Расшифровать архив базы данных `FILE_NAME.tar.xz.gpg` при помощи секретной фразы `SECRET`:

```bash
f='FILE_NAME.tar.xz.gpg'; p='SECRET'; gpg --batch --passphrase "${p}" --output "${f%.*}" --decrypt "${f}"
```

### OpenSSL

{{< alert "important" >}}
При использовании OpenSSL параметры дешифрования должны соответствовать параметрам шифрования. Без знания параметров шифрования, дешифровать данные не получится.
{{< /alert >}}

- Расшифровать архив базы данных `DB_NAME.sql.xz.ssl` при помощи секретной фразы `SECRET`, дайджеста (`-md`) `sha512` и количества итераций (`-iter`) `65536`:

```bash
f='FILE_NAME.tar.xz.ssl'; p='SECRET'; openssl enc -aes-256-cfb -in "${f}" -out "${f%.*}" -pass "pass:${p}" -d -md 'sha512' -iter '65536' -salt -pbkdf2
```
