---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: '1731412749522_3645'
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
  - 'JohnDoe'
  - 'JaneDoe'
sources:
  - ''
license: 'CC-BY-SA-4.0'
complexity: '0'
toc: 1
comments: 1

# -------------------------------------------------------------------------------------------------------------------- #
# DATE
# -------------------------------------------------------------------------------------------------------------------- #

date: '2024-11-12T14:59:17+03:00'
publishDate: '2024-11-12T14:59:17+03:00'
lastMod: '2024-11-12T14:59:17+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '1f5924fa7a3dd74e315d8a41208fe10d8743f38d'
uuid: '1f5924fa-7a3d-574e-a15d-8a41208fe10d'
slug: '1f5924fa-7a3d-574e-a15d-8a41208fe10d'

draft: 1
---



<!--more-->

## Скрипт

### Приложение

{{< file "app.acme.lego.sh" >}}

### Общая конфигурация

{{< file "app.acme.lego.conf" "bash" >}}

#### Параметры

- `ACME_SERVER` - сервер Let's Encrypt для заказа сертификата. По умолчанию указан тестовый сервер. Может принимать следующие значения:
  - `https://acme-staging-v02.api.letsencrypt.org/directory` - сервер для тестирования получения проверочных сертификатов. Используется для проверки работы скрипта.
  - `https://acme-v02.api.letsencrypt.org/directory` - сервер для получения настоящих сертификатов.
- `ACME_EMAIL` - адрес электронной почты для регистрации и восстановления сертификата Let's Encrypt.
- `ACME_PATH` - путь к хранилищу сертификатов. По умолчанию: `/etc/ssl/acme`.
- `ACME_METHOD` - метод получения/обновления сертификата. По умолчанию `http`. Может принимать следующие значения:
  - `dns` - получения сертификата методом **DNS-01**.
  - `http` - получение сертификата методом **HTTP-01**.
  - `tls` - получения сертификата методом **TLS-ALPN-01**.
- `ACME_HTTP_PORT` - порт, который будет слушать LeGo при получении сертификата методом **HTTP-01**. По умолчанию: `:80`. Может принимать следующие значения:
  - `interface:port` - слушать на конкретном интерфейсе и номере порта.
  - `:port` - слушать на всех интерфейсах и конкретном порту.
- `ACME_HTTP_PROXY_HEADER` - проверка по указанному заголовку, если LeGo находится за обратным proxy-сервером.
- `ACME_TLS_PORT` - порт, который будет слушать LeGo при получении сертификата методом **TLS-ALPN-01**. По умолчанию: `:443`. Может принимать следующие значения:
  - `interface:port` - слушать на конкретном интерфейсе и номере порта.
  - `:port` - слушать на всех интерфейсах и конкретном порту.
- `ACME_KEY_TYPE` - тип приватного ключа сертификата. По умолчанию: `ec256`. Может принимать следующие значения:
  - `rsa2048` - тип **RSA-2048**.
  - `rsa3072` - тип **RSA-3072**.
  - `rsa4096` - тип **RSA-4096**.
  - `rsa8192` - тип **RSA-8192**.
  - `ec256` - тип **EC-256**.
  - `ec384` - тип **EC-384**.
- `ACME_PFX_PASSWORD` - пароль для контейнера PFX.
- `ACME_PFX_FORMAT` - формат контейнера PFX. По умолчанию: `RC2`. Может принимать следующие значения:
  - `RC2` - формат **RC2**.
  - `DES` - формат **DES**.
  - `SHA256` - формат **SHA256**.
- `ACME_CRT_TIMEOUT` - время ожидания сертификата в секундах. По умолчанию: `30` секунд. Используется только при получении нового сертификата.
- `ACME_DAYS` - количество дней, оставшихся у сертификата для его продления.
- `ACME_SERVICES` - сервисы, которые необходимо перезапустить после обновления сертификата. Каждый из сервисов проверяется на наличие в системе.
- `ACME_DNS` - выбор DNS-провайдера для получения сертификата методом **DNS-01**.

### Конфигурация домена

{{< file "app.acme.lego.example.com.conf" "bash" >}}

#### Параметры

- `ACME_DOMAINS` - список доменов для получения сертификата.
- `ACME_HTTP_WEBROOT` - WEB-директория сервера для интеграции директории идентификации `.well-known/acme-challenge`. Если параметр пустой, LeGo поднимает свой внутренний сервер для получения сертификата.


### Задача

{{< file "app_acme_lego" "bash" >}}