---
# -------------------------------------------------------------------------------------------------------------------- #
# General settings.
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Установка и настройка Asterisk'
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
  - 'KaiKimera'
sources:
  - ''
license: 'CC-BY-SA-4.0'
complexity: '0'
toc: 1
comments: 1

# -------------------------------------------------------------------------------------------------------------------- #
# Date settings.
# -------------------------------------------------------------------------------------------------------------------- #

date: '2024-04-04T14:44:11+03:00'
publishDate: '2024-04-04T14:44:11+03:00'
expiryDate: ''
lastMod: '2024-04-04T14:44:11+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# Meta settings.
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '2e00b43bb0da79c28e9260dcf2ba1d5255b468e9'
uuid: '2e00b43b-b0da-59c2-ae92-60dcf2ba1d52'
slug: '2e00b43b-b0da-59c2-ae92-60dcf2ba1d52'

draft: 1
---



<!--more-->

## Обновление ОС и установка пакетов

```sh
apt update && apt --yes upgrade && apt --yes install git curl wget subversion build-essential
```

## Установка Asterisk

### Установка библиотеки декодера MP3

```sh
bash contrib/scripts/get_mp3_source.sh
```

### Установка требуемых для сборки пакетов

```sh
bash contrib/scripts/install_prereq install
```

### Конфигурация сборки

```sh
./configure
```

### Выбор компонентов Asterisk

```sh
make menuselect
```

Выбрать:

- Applications
  - `app_macro`
- Core Sound Packages
  - `CORE-SOUNDS-EN-GSM`
  - `CORE-SOUNDS-RU-GSM`

### Сборка и установка Asterisk

```sh
make && make install && make config && ldconfig
```

```sh
make basic-pbx
```

## Настройка Asterisk

### Настройка пользователя

```sh
groupadd asterisk && useradd -r -d /var/lib/asterisk -g asterisk asterisk && usermod -aG audio,dialout asterisk && chown -R asterisk:asterisk /etc/asterisk && chown -R asterisk:asterisk /var/{lib,log,spool}/asterisk && chown -R asterisk:asterisk /usr/lib/asterisk
```

### Редактирование конфигурации

```sh
sed -i 's|#AST_USER="asterisk"|AST_USER="asterisk"|g' '/etc/default/asterisk' && sed -i 's|#AST_GROUP="asterisk"|AST_GROUP="asterisk"|g' '/etc/default/asterisk'
```

```sh
sed -i 's|;runuser = asterisk|runuser = asterisk|g' '/etc/asterisk/asterisk.conf' && sed -i 's|;rungroup = asterisk|rungroup = asterisk|g' '/etc/asterisk/asterisk.conf'
```

## Запуск Asterisk


```sh
systemctl enable --now asterisk
```
