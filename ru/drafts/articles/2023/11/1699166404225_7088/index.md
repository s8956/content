---
# -------------------------------------------------------------------------------------------------------------------- #
# General settings.
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Автоматическая установка Linux'
description: ''
images:
  - 'https://images.unsplash.com/photo-1585776245991-cf89dd7fc73a'
categories:
  - 'linux'
tags:
  - 'unattend'
  - 'preseed'
  - 'kickstart'
  - 'alma'
  - 'debian'
  - 'rocky'
  - 'oracle'
authors:
  - 'KitsuneSolar'
sources:
  - ''
license: 'CC-BY-SA-4.0'
complexity: '0'
toc: 1
comments: 1

# -------------------------------------------------------------------------------------------------------------------- #
# Date settings.
# -------------------------------------------------------------------------------------------------------------------- #

date: '2023-11-05T09:40:04+03:00'
publishDate: '2023-11-05T09:40:04+03:00'
expiryDate: ''
lastMod: '2023-11-05T09:40:04+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# Meta settings.
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '999048b252b3c085db4794f20db5edb73472fa84'
uuid: '999048b2-52b3-5085-8b47-94f20db5edb7'
slug: '999048b2-52b3-5085-8b47-94f20db5edb7'

draft: 0
---



<!--more-->

## Запуск автоматической установки

### RHEL / Fedora

```
url=https://lib.onl/auto/[id].ini
```

### Debian / Ubuntu

```
inst.ks=https://lib.onl/auto/[id].ini
```

## Пользователи по умолчанию

- ROOT
  - Name: `root`
  - Password: `cDFy mu2a ML`
- USER-0000
  - Name: `user-0000`
  - Password: `7Jxs 6PKV Ak`

## Скрипт первичной настройки

{{< file "auto/unix.setup.sh" >}}

## Сценарии автоматической установки

### Alma Linux

#### Server

{{< resource "cb16cbb8-5964-5591-83ab-b2d9c6042dcc" "alma.srv.bios.ini" >}}
{{< resource "cb16cbb8-5964-5591-83ab-b2d9c6042dcc" "alma.srv.uefi.ini" >}}

### Debian

#### Server

{{< resource "cb16cbb8-5964-5591-83ab-b2d9c6042dcc" "debian.srv.bios.ini" >}}
{{< resource "cb16cbb8-5964-5591-83ab-b2d9c6042dcc" "debian.srv.uefi.ini" >}}

### Fedora Linux

#### Server

{{< resource "cb16cbb8-5964-5591-83ab-b2d9c6042dcc" "fedora.srv.bios.ini" >}}
{{< resource "cb16cbb8-5964-5591-83ab-b2d9c6042dcc" "fedora.srv.uefi.ini" >}}

### Oracle Linux

#### Server

{{< resource "cb16cbb8-5964-5591-83ab-b2d9c6042dcc" "oracle.srv.bios.ini" >}}
{{< resource "cb16cbb8-5964-5591-83ab-b2d9c6042dcc" "oracle.srv.uefi.ini" >}}

### Rocky Linux

#### Server

{{< resource "cb16cbb8-5964-5591-83ab-b2d9c6042dcc" "rocky.srv.bios.ini" >}}
{{< resource "cb16cbb8-5964-5591-83ab-b2d9c6042dcc" "rocky.srv.uefi.ini" >}}
