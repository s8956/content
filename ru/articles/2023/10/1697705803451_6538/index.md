---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'MikroTik: Добавление корневых сертификатов в RouterOS'
description: ''
images:
  - 'https://images.unsplash.com/photo-1554098415-4052459dc340'
cover:
  crop: 'bottom'
categories:
  - 'network'
  - 'security'
tags:
  - 'router'
  - 'mikrotik'
  - 'routeros'
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

date: '2023-10-19T11:56:43+03:00'
publishDate: '2023-10-19T11:56:43+03:00'
lastMod: '2023-10-19T11:56:43+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: 'cc13623b970c6950a67e168f9ba9025ade0f0cfe'
uuid: 'cc13623b-970c-5950-867e-168f9ba9025a'
slug: 'cc13623b-970c-5950-867e-168f9ba9025a'

draft: 0
---

Репозиторий корневых сертификатов необходим для того, чтобы {{< tag "RouterOS" >}} имела представление какие вообще центры сертификации существуют.

<!--more-->

Если репозиторий заполнен корневыми сертификатами центров сертификации, {{< tag "RouterOS" >}} сможет проверять подлинность выданных этими центрами сертификатов, работать с DNS over HTTPS ({{< tag "DoH" >}}) и делать другую работу, связанную с шифрованием данных.

## Загрузка базы сертификатов

Файл [cacert.pem](https://curl.se/docs/caextract.html) с сайта [curl.se](https://curl.se/) переодически обновляется и содержит в себе корневые сертификаты центров сертификации. Откроем терминал в {{< tag "RouterOS" >}} и скачаем сразу на роутер командой:

```text
/tool fetch url="https://curl.se/ca/cacert.pem" dst-path="ros.cacert.pem"
```

Где:
- `url` - URL файла, который необходимо скачать.
- `dst-path` - название, под которым файл сохранится на роутере. Я добавляю префикс `ros.`, чтобы знать, что этот файл важен для {{< tag "RouterOS" >}}.

## Импортирование сертификатов в репозиторий

Теперь когда файл на роутере, нужно импортировать его содержимое в репозиторий сертификатов. Делается это следующей командой:

```text
/certificate import file-name="ros.cacert.pem" passphrase="" name="CA"
```

Где:
- `file-name` - название файла на  роутере.
- `name` - название, под которым сертификаты будут обозначаться в репозитории сертификатов. Здесь я указываю `CA`, чтобы знать, что сертификаты импортировались вручную и представляют собой сертификаты CA. Вы можете ввести любое своё название, главное, чтобы оно для вас что-то обозначало.

{{< alert "tip" >}}
Параметр `name` можно не указывать, тогда при импорте сертификатов, RouterOS в этот параметр автоматически подставит название файла.
{{< /alert >}}
