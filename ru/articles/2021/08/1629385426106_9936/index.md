---
title: 'Скрипт автоматического удаления устаревших файлов'
description: ''
images:
  - 'https://images.unsplash.com/flagged/photo-1578728890856-8bbf3883aa6d'
cover:
  crop: 'center'
categories:
  - 'dev'
  - 'scripts'
tags:
  - 'bash'
  - 'find'
authors:
  - 'KitsuneSolar'
license: 'CC-BY-SA-4.0'
complexity: '0'
toc: 1
comments: 1

date: '2021-08-19T18:03:46+03:00'
hash: 'ca744dcee60782e619528ae04e052a5bb9dddf54'
uuid: 'ca744dce-e607-52e6-9952-8ae04e052a5b'
slug: 'ca744dce-e607-52e6-9952-8ae04e052a5b'

draft: 0
---

В одной компании стояла задача сделать файловый архив-помойку для хранения и пересылки документации в сторонние организации. Я накидал на PHP самописный интерфейс для загрузки файлов, а на bash'е сделал скрипт автоматического удаления устаревших файлов. Небольшая заметка об этом скрипте.

<!--more-->

Скрипт для удаления устаревших файлов очень прост, написан на bash'е и основывается на утилите `find`. Утилита `find` имеет опцию `-mtime`, при помощи которого можно сделать выборку файлов по времени изменения:

```sh
find "/home/user" -type f -mtime +3
```

Здесь мы говорим утилите `find`, что необходимо найти и показать файлы, у которых с даты последнего изменения прошло более 3 дней. Если необходимо вывести файлы, дата изменения которых будет менее `3` дней, то ставим отрицательное значение `-3`.

Далее, конструируем конвейер, и при помощи `xargs` указываем команду удаления `rm -f`:

```sh
find "/home/user" -type f -mtime +3 -print0 | xargs -0 rm -f
```

Сам скрипт провожу ниже.

## Скрипт

{{< file "delete-files.sh" >}}

В скрипте я вынес некоторые значения в переменные для удобной перенастройки. Вызывается скрипт следующем образом:

```terminal {os="linux"}
delete-files.sh "3" "/path/to/storage"
```

Где:

- `3` - количество дней, прошедших с момента последнего изменения файла.
- `/path/to/storage` - путь к файловому хранилищу, в котором необходимо удалять устаревшие файлы.

## Автоматический запуск по расписанию

Осталось добавить выполнение скрипта по cron'у. Я указал время `23:59`, когда нагрузка на файловое хранилище минимальна:

```sh
# Check & remove old files in 23:59 every day.
59 23 * * * [username] /usr/bin/bash /path/to/delete-files.sh "3" "/path/to/storage" > /dev/null 2>&1
```