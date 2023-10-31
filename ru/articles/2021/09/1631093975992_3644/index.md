---
title: 'Распаковка пакетов DEB / RPM'
description: ''
images:
  - 'https://images.unsplash.com/photo-1577705998148-6da4f3963bc8'
cover:
  crop: 'center'
categories:
  - 'linux'
tags:
  - 'debian'
  - 'fedora'
  - 'deb'
  - 'rpm'
  - 'ar'
  - 'cpio'
  - 'rpm2cpio'
authors:
  - 'KitsuneSolar'
license: 'CC-BY-SA-4.0'
complexity: '0'
toc: 1
comments: 1

date: '2021-09-08T12:39:36+03:00'
hash: 'b2caccc792bf17ed970f136c546f18e29091a6c7'
uuid: 'b2caccc7-92bf-57ed-970f-136c546f18e2'
slug: 'b2caccc7-92bf-57ed-970f-136c546f18e2'

draft: 0
---

Я собираю пакеты для Debian и RHEL. И зачастую, мне необходимо посмотреть содержимое собранного пакета, чтобы удостоверится в правильности сборки и корректности расположения файлов внутри пакета. В этой статье кратно расскажу, как и при помощи чего можно посмотреть собранные пакеты.

<!--more-->

## DEB

Пакет `.deb` архивируется при помощи [ar](https://en.wikipedia.org/wiki/Ar_(Unix)). Соответственно, распаковать пакет тоже следует через данный архиватор:

```sh
ar x example.deb
```


- `debian-binary` – файл, содержащий версию формата `.deb`.
- `control.tar.xz` – файл, содержащий md5sums и директорию для сборки пакета.
- `data.tar.xz` – архив, содержащий все файлы, которые должны быть установлены в системе при установке пакета.


## RPM

Пакет `.rpm` содержит архив `cpio`. Имеется удобная утилита `rpm2cpio`, которая преобразует `.rpm` в архив `cpio`.

```sh
rpm2cpio myrpmfile.rpm
rpm2cpio - < myrpmfile.rpm
rpm2cpio myrpmfile.rpm | cpio -idmv
```

Опции `rpm2cpio`:

- `-i` - восстановить архив.
- `-d` - создать необходимые каталоги.
- `-m` - сохранить время модификации файлов.
- `-v` - подробный вывод процесса преобразования.

Также, просматривать `.rpm` можно при помощи файлового менеджера Midnight Commander (`mc`).