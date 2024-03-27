---
# -------------------------------------------------------------------------------------------------------------------- #
# General settings.
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Первичная настройка FreeBSD'
description: ''
images:
  - 'https://images.unsplash.com/photo-1578307898411-f6930dadea39'
cover:
  crop: 'top'
categories:
  - 'bsd'
tags:
  - 'freebsd'
  - 'zfs'
  - 'zsh'
  - 'syncthing'
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

date: '2024-02-08T11:59:09+03:00'
publishDate: '2024-02-08T11:59:09+03:00'
expiryDate: ''
lastMod: '2024-02-17T04:49:00+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# Meta settings.
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: 'f97dc3109a6a12f7a441bf7eb02087c24ad6a343'
uuid: 'f97dc310-9a6a-52f7-8441-bf7eb02087c2'
slug: 'f97dc310-9a6a-52f7-8441-bf7eb02087c2'

draft: 0
---

Надумал я как-то на днях изучить ОС {{< tag "FreeBSD" >}}. Система обладает своими особенностями, но кто работает в {{< tag "Linux" >}}, тот легко разберётся в FreeBSD.

<!--more-->

## Обновление системы

После установки базовой системы, рекомендуется запустить обновление.

1. Запросить и применить обновления:

```
freebsd-update fetch && freebsd-update install
```

## Обновление пакетов

1. Запросить и применить обновления пакетов:

```
pkg update -f && pkg upgrade
```

## Переключение ветки пакетов

По умолчанию, {{< tag "FreeBSD" >}} берёт обновления пакетов из квартальной (`quarterly`) ветки. Если хочется получить свежие пакеты здесь и сейчас, то нужно переключить ветку на `latest`.

1. Создать файл `/usr/local/etc/pkg/repos/FreeBSD.conf`:

```
mkdir -p /usr/local/etc/pkg/repos && echo 'FreeBSD: { url: "pkg+http://pkg.FreeBSD.org/${ABI}/latest" }' > /usr/local/etc/pkg/repos/FreeBSD.conf
```

2. Обновить базу данных пакетов и обновить пакеты:

```
pkg update -f && pkg upgrade
```

## Установка пакетов

Для установки пакетов используется пакетный менеджер `pkg`. В интернете есть информация о том, что не рекомендуется смешивать пакеты и порты. То есть, если вы уже начали использовать пакеты, то надо продолжать только ими пользоваться.

### Установка сервиса обновления микрокода CPU

1. Установить пакет.
2. Добавить в `rc.conf` автозапуск сервиса.
3. Запустить сервис.

```
pkg install cpu-microcode && sysrc microcode_update_enable=YES && service microcode_update start
```

### Установка дополнительных пакетов

Для работы на сервере, я устанавливаю следующие пакеты:

```
pkg install bash ca_root_nss curl git gnupg htop mc nano smartmontools wget zsh
```

## Настройка ядра

### Увеличение числа дескрипторов файлов

У меня используется синхронизация данных при помощи {{< tag "Syncthing" >}}, данных много. Иногда случается ступор из-за лимита на дескрипторы файлов. Открываем `/etc/sysctl.conf`, добавляем:

```ini
kern.maxfiles=500000
kern.maxfilesperproc=500000
```

Перезагружаем систему:

```
shutdown -r now
```

## Настройка терминала

В своей работе я предпочитаю {{< tag "Zsh" >}}.

### Установка Zsh для пользователей

1. Изменить стандартную оболочку на {{< tag "Zsh" >}} для **root**:

```
chsh -s zsh root
```

2. Изменить стандартную оболочку на {{< tag "Zsh" >}} для **обычного пользователя**:

```
chsh -s zsh user
```

Где:
- `user` - логин пользователя.

### Конфигурация Zsh

Использую конфигурацию от {{< tag "GRML" >}}.

1. Скачиваем конфигурацию:

```
wget -O ~/.zshrc.grml https://git.grml.org/f/grml-etc-core/etc/zsh/zshrc
```

2. Открываем файл `~/.zshrc` и добавляем следующие строки:


```sh
. "${HOME}/.zshrc.grml"
export GPG_TTY=$(tty)
```

Я работаю на ОС Windows и к серверам подключаюсь через {{< tag "KiTTY" >}}. При работе с {{< tag "GPG" >}}, она иногда не понимает куда ей выбрасывать запрос на парольную фразу. Поэтому, у меня здесь добавлен фикс `export GPG_TTY=$(tty)`.

## Настройка файловой системы

### Отключение `atime`

`atime` это время доступа к файлу. В обычной работе такая метрика бесполезна. На диск могут быть тысячи файлов и для каждого файла ядро ОС будет фиксировать и обновлять время доступа. Подобная операция весьма дорогая.

```
zfs set atime=off zroot
```

Где:
- `zroot` - пул файловой системы {{< tag "ZFS" >}}.