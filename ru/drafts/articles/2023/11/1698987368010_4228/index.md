---
title: 'Автоматическая установка ОС Windows'
description: ''
images:
  - 'https://images.unsplash.com/photo-1585776245991-cf89dd7fc73a'
cover:
  crop: 'entropy'
  fit: 'crop'
categories:
  - 'windows'
tags:
  - 'diskpart'
  - 'tpm'
  - 'unattend'
authors:
  - 'KitsuneSolar'
sources:
  - 'https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/windows-setup-automation-overview'
license: 'CC-BY-SA-4.0'
complexity: '0'
toc: 1
comments: 1

date: '2023-11-03T07:56:08+03:00'
publishDate: '2023-11-03T07:56:08+03:00'
expiryDate: ''
lastMod: '2023-11-03T07:56:08+03:00'

type: 'articles'
hash: 'e06f18417479a0cc55281aca56d91d502f322c53'
uuid: 'e06f1841-7479-50cc-a528-1aca56d91d50'
slug: 'e06f1841-7479-50cc-a528-1aca56d91d50'

draft: 0
---

Многие системные администраторы обслуживают большой парк компьютеров и без автоматизации управлять всем этим затратно по времени. Поэтому, всегда нужно стараться автоматизировать шаблонные действия. К пример, установку и настройку ОС.

<!--more-->

За автоматизацию установки ОС отвечает файл `AutoUnattend.xml`. В этом файле описываются этапы установки ОС:

1. Конфигурация разметки SSD.
2. Установка и настройка ОС.

В моём случае, я решил разбить эти этапы на два отдельных файла:

- `auto.diskpart.cmd`.
- `AutoUnattend.xml`.

Зачем я так сделал? Для того, чтобы уменьшить основной `AutoUnattend.xml`. Дело в том, что этап по разметке SSD занимает довольно много места в `AutoUnattend.xml`, поэтому я решил вынести его в отдельный файл. За разметку SSD у меня отвечает утилита `diskpart`, которая позволяет весьма тонко настроить создаваемую разметку. В самом же `AutoUnattend.xml` прописан вызов командной строки с запуском сценария из файла `auto.diskpart.cmd`.

## Разметка диска

Файл `auto.diskpart.cmd` содержит сценарий по разметке SSD. Разметка SSD различается в зависимости от прошивки материнской платы. Например, если материнская плата поддерживает установку ОС в режиме UEFI, то на SSD появляется раздел `EFI`. Если установка происходит в режиме совместимости с UEFI или вовсе на старый компьютер без UEFI, то раздел `EFI` будет отсутствовать. Поэтому я рекомендую сделать два файла .iso с образами ОС, который будут включать в себя файлы под различные типы установок.

- `auto.diskpart.BIOS.cmd` - файл с командами разбивки SSD под старые материнские платы, или платы, работающие в режиме совместимости UEFI.
- `auto.diskpart.UEFI.cmd` - файл с командами разбивки SSD под новые материнские платы.

### BIOS

{{< alert "important" >}}
Файл `auto.diskpart.BIOS.cmd` предназначен для разметки SSD под старые материнские платы с прошивкой **BIOS**. Его необходимо переименовать в `auto.diskpart.cmd` и помесить в корень файла `.iso` с дистрибутивом ОС.
{{< /alert >}}

{{< file "auto.diskpart.BIOS.bat" >}}

### UEFI

{{< alert "important" >}}
Файл `auto.diskpart.UEFI.cmd` предназначен для разметки SSD под новые материнские платы с прошивкой **UEFI**. Его необходимо переименовать в `auto.diskpart.cmd` и помесить в корень файла `.iso` с дистрибутивом ОС.
{{< /alert >}}

{{< file "auto.diskpart.UEFI.bat" >}}

## MS Windows 10

### BIOS

{{< alert "important" >}}
Файл `WIN.10.AutoUnattend.BIOS.xml` предназначен для автоматической установки ОС под старые материнские платы с прошивкой **BIOS**. Его необходимо переименовать в `AutoUnattend.xml` и помесить в корень файла `.iso` с дистрибутивом ОС.
{{< /alert >}}

{{< file "WIN.10.AutoUnattend.BIOS.xml" >}}

### UEFI

{{< alert "important" >}}
Файл `WIN.10.AutoUnattend.UEFI.xml` предназначен для автоматической установки ОС под новые материнские платы с прошивкой **UEFI**. Его необходимо переименовать в `AutoUnattend.xml` и помесить в корень файла `.iso` с дистрибутивом ОС.
{{< /alert >}}

{{< file "WIN.10.AutoUnattend.UEFI.xml" >}}

## MS Windows 11

### Обход ограничений

{{< file "auto.tpm.bat" >}}

### BIOS

{{< alert "important" >}}
Файл `WIN.11.AutoUnattend.BIOS.xml` предназначен для автоматической установки ОС под старые материнские платы с прошивкой **BIOS**. Его необходимо переименовать в `AutoUnattend.xml` и помесить в корень файла `.iso` с дистрибутивом ОС.
{{< /alert >}}

{{< file "WIN.11.AutoUnattend.BIOS.xml" >}}

### UEFI

{{< alert "important" >}}
Файл `WIN.11.AutoUnattend.UEFI.xml` предназначен для автоматической установки ОС под новые материнские платы с прошивкой **UEFI**. Его необходимо переименовать в `AutoUnattend.xml` и помесить в корень файла `.iso` с дистрибутивом ОС.
{{< /alert >}}

{{< file "WIN.11.AutoUnattend.UEFI.xml" >}}