---
title: 'PowerShell: Стирание диска'
description: ''
images:
  - 'https://images.unsplash.com/photo-1646226343350-1ee5021e342a'
cover:
  crop: 'entropy'
  fit: 'crop'
categories:
  - 'windows'
  - 'terminal'
  - 'scripts'
tags:
  - 'powershell'
  - 'hdd'
  - 'ssd'
authors:
  - 'KitsuneSolar'
sources:
  - ''
license: 'CC-BY-SA-4.0'
complexity: '0'
toc: 1
comments: 1

date: '2023-10-23T14:03:04+03:00'
publishDate: '2023-10-23T14:03:04+03:00'
expiryDate: ''
lastMod: '2023-10-23T14:03:04+03:00'

hash: '52d75b900637fba661d6b1bff40e1d674e739706'
uuid: '52d75b90-0637-5ba6-91d6-b1bff40e1d67'
slug: '52d75b90-0637-5ba6-91d6-b1bff40e1d67'

draft: 0
---

Небольшой скрипт, который обнуляет HDD/SSD и создаёт файловую систему заново.

<!--more-->

## Параметры

- `-DN` `-P_DiskNumber` - номер диска. Можно узнать командой `Get-Disk`. Но если не ввести номер диска в параметры скрипта при запуске, скрипт сам выведет информацию и спросит номер диска. Обязательный параметр.
- `-DL` `-P_DriveLetter` - буква будущего тома. При создании тома, ОС должна присвоить ему букву. Обязательный параметр.
- `-FS` `-P_FileSystem` - файловая система. Может принимать следующие значения:
  - `'FAT'` - файловая система FAT.
  - `'FAT32'` - файловая система FAT32.
  - `'exFAT'` - файловая система exFAT.
  - `'NTFS'` - файловая система NTFS.
  - `'ReFS'` - новая файловая система ReFS.
- `-FSL` `-P_FileSystemLabel` - метка файловой системы.
- `-S` `-P_Sleep` - перерыв между командами (в секундах).

## Примеры

Скрипт, запущенный без параметров, сам спросит необходимые данные:

```terminal {os="windows", mode="root"}
.\pwsh.disk.erase.ps1
```

Обнулить диск `3`, новому разделу присвоить букву `E`, форматировать в `NTFS` и указать метку `USB-SSD`:

```terminal {os="windows", mode="root"}
.\pwsh.disk.erase.ps1 -DN 3 -DL 'E' -FS 'NTFS' -FSL 'USB-SSD'
```

## Скрипт

{{< file "pwsh.disk.erase.ps1" >}}
