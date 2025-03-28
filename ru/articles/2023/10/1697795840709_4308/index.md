---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'PowerShell Vault'
description: ''
images:
  - 'https://images.unsplash.com/photo-1609358905581-e5381612486e'
cover:
  crop: 'left'
categories:
  - 'windows'
  - 'terminal'
  - 'scripts'
tags:
  - 'powershell'
authors:
  - 'KaiKimera'
sources:
  - 'https://github.com/pkgstore/pwsh-vault'
license: 'CC-BY-SA-4.0'
complexity: '1'
toc: 1
comments: 1

# -------------------------------------------------------------------------------------------------------------------- #
# DATE
# -------------------------------------------------------------------------------------------------------------------- #

date: '2023-10-20T12:57:21+03:00'
publishDate: '2023-10-20T12:57:21+03:00'
lastMod: '2023-10-20T12:57:21+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '4c7aba7cf5a6f89ae975fdb16f2e2862e8a81793'
uuid: '4c7aba7c-f5a6-589a-9975-fdb16f2e2862'
slug: '4c7aba7c-f5a6-589a-9975-fdb16f2e2862'

draft: 0
---

На работе в локальной сети использовалась задача, которая перемещала старые, по долгу не использовавшиеся, файлы из главного файлового хранилища в резервное. Но так как организация являлась проектной, то старые файлы могли понадобиться в любое время.

<!--more-->

Задача использовала простой скрипт с фильтрацией файлов по параметрам *время создания* и *время изменения*. Я чуть доработали скрипт и решил опубликовать его для других администраторов. Вдруг, пригодится. Только перед использованием прошу проверить скрипт в какой-нибудь песочнице.

{{< alert "warning" >}}
Есть вероятность, что скрипт удалит все файлы в вашем файловом хранилище, из-за того, что автор может оказаться *рукожопом*! Поэтому, перед боевой задачей, проверьте скрипт в какой-нибудь песочнице. А кто хорошо разбирается в PowerShell - автор будет благодарен за оптимизацию и корректировку скрипта.
{{< /alert >}}

## Параметры

- `-M` `-Mode` - режим работы скрипта. По умолчанию `'MV'`.
  - `'CP'` - копировать файлы из источника в хранилище.
  - `'MV'` - перемещать файлы из источника в хранилище.
  - `'RM'` - только удалять файлы из источника без копирования или перемещения куда-либо.
- `-SRC` `-Source` - путь к директории откуда перемещать файлы. Например, `-SRC 'C:\Data\Source'`. По умолчанию: `${PSScriptRoot}\Source`.
- `-DST` `-Vault` - путь к директории куда перемещать файлы. Например, `-DST 'C:\Data\Vault'`. По умолчанию: `${PSScriptRoot}\Vault`.
- `-CT` `-CreationTime` - время создания файла в секундах. Например, `-CT 5270400`. По умолчанию: `5270400` (61 день).
- `-WT` `-LastWriteTime` - время изменения файла в секундах. Например, `-WT 5270400`. По умолчанию: `${P_CreationTime}`.
- `-FS` `-FileSize` - размер файла. Например, `-FS '5kb'` или `-FS '12mb'`. По умолчанию: `'0kb'`.
- `-E` `-Exclude` - путь к файлу с исключениями. Например, `-E 'C:\Data\exclude.txt'`. По умолчанию: `${PSScriptRoot}\vault.exclude.txt`.
- `-L` `-Logs` - путь к директории с журналами работы скрипта. Например, `-L 'C:\Data\Logs'`. По умолчанию: `${PSScriptRoot}\Logs`.
- `-RD` `-RemoveDirs` - удалять пустые каталоги.
- `-O` `-Overwrite` - перезаписать файлы в Vault.

## Примеры

Запустить перемещение файлов из `Source` в `Vault` с сохранением структуры директорий:

```terminal {os="windows"}
Start-Vault -SRC 'C:\Data\Source' -DST 'C:\Data\Vault'
```

Запустить перемещение файлов с временем создания и изменения от 10 дней (`864000`) из `Source` в `Vault` с сохранением структуры директорий:

```terminal {os="windows"}
Start-Vault -SRC 'C:\Data\Source' -DST 'C:\Data\Vault' -CT '864000' -WT '864000'
```

Запустить перемещение файлов с временем создания и изменения от 10 дней (`864000`) и размером более 32 мегабайта (`32mb`) из `Source` в `Vault` с сохранением структуры директорий:

```terminal {os="windows"}
Start-Vault -SRC 'C:\Data\Source' -DST 'C:\Data\Vault' -CT '864000' -WT '864000' -FS '32mb'
```

Запустить перемещение файлов с временем создания и изменения от 10 дней (`864000`), и с перезаписью файлов с одинаковыми названиями (`-O`) из `Source` в `Vault` с сохранением структуры директорий:

```terminal {os="windows"}
Start-Vault -SRC 'C:\Data\Source' -DST 'C:\Data\Vault' -CT '864000' -WT '864000' -O
```

Параметр `-O` означает, что не нужно архивировать старый файл при перемещении нового с таким же названием. Старый файл в хранилище перезапишется новым.

## Алгоритм работы

Скрипт создаёт хранилище старых файлов. Это, своего рода, аналог резервного копирования. При перемещении файлов из источника в хранилище, скрипт обрабатывает несколько заданных параметров и фильтров. Всё настроить можно под себя. По умолчанию, скрипт перемещает файлы из источника в хранилище, и если в хранилище уже имеется старый файл с названием кау у нового перемещаемого, то старый файл архивируется с меткой `.[UnixTime].7z`.

{{< alert "important" >}}
Для работы скрипта необходим архиватор **7-Zip**, а конкретно его облегчённая версия `7za.exe` с библиотеками из **7-Zip Extra**. Скачать можно с [официального сайта](https://www.7-zip.org/download.html). После скачивания архива, файлы `7za.exe`, `7za.dll` и `7zxa.dll` нужно разместить рядом со скриптом, или в любую дочернюю директорию. Скрипт сам найдёт путь к `7za.exe`.
{{< /alert >}}

## Скрипт

{{< gh-repo "pkgstore/pwsh-vault" >}}
