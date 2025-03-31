---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: "Работа с сертификатами Let's Encrypt"
description: ''
images:
  - 'https://images.unsplash.com/photo-1605351792643-fe0c43d18762'
categories:
  - 'linux'
  - 'network'
  - 'security'
  - 'terminal'
  - 'inDev'
tags:
  - 'debian'
  - 'acme'
  - 'lego'
  - 'ssl'
authors:
  - 'KaiKimera'
sources:
  - 'https://go-acme.github.io/lego/'
  - 'https://github.com/go-acme/lego/blob/master/docs/data/zz_cli_help.toml'
  - 'https://github.com/acmesh-official/acme.sh/wiki/TLS-ALPN-without-downtime'
license: 'CC-BY-SA-4.0'
complexity: '0'
toc: 1
comments: 1

# -------------------------------------------------------------------------------------------------------------------- #
# DATE
# -------------------------------------------------------------------------------------------------------------------- #

date: '2025-03-28T23:40:30+03:00'
publishDate: '2025-03-28T23:40:30+03:00'
lastMod: '2025-03-28T23:40:30+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '481a0666eb21855fe58f0c2d695b9a741bbce47f'
uuid: '481a0666-eb21-555f-858f-0c2d695b9a74'
slug: '481a0666-eb21-555f-858f-0c2d695b9a74'

draft: 0
---

Рассматриваем работу с сертификатами Let’s Encrypt при помощи утилиты {{< tag "LeGo" >}}.

<!--more-->

## Установка LeGo

- [Скачать](https://github.com/go-acme/lego/releases/latest) {{< tag "LeGo" >}} и распаковать в директорию `/root/apps/acme/`.
- [Создать](#hook) файл `hook.sh` в директории `/root/apps/acme/`.
- Изучить [документацию](https://go-acme.github.io/lego/) и [справку](https://github.com/go-acme/lego/blob/master/docs/data/zz_cli_help.toml) по командам для составления запросов на получение и обновление сертификатов.
- Выбрать метод получения и обновления сертификатов.

## Метод HTTP-01

Let’s Encrypt выдаёт клиенту токен, клиент записывает этот токен в файл на web-сервере по пути `http://example.com/.well-known/acme-challenge/<TOKEN>`.

Плюсы метода:

- Легко автоматизировать без дополнительных знаний о домене.
- Работает со всеми web-серверами.
- Можно использовать для проверки IP-адресов.

Минусы метода:

- Не работает, если провайдер блокирует порт `80`.
- Не позволяет получать wildcard-сертификаты.

### Получение сертификата

- Зарегистрировать адрес `mail@example.com` и получить сертификат для доменов `example.com` и `mail.example.com` в директорию `/root/apps/acme/`:

```bash
APP="${HOME}/apps/acme"; "${APP}/lego" --accept-tos --path="${APP}" --email='mail@example.com' --domains='example.com' --domains='mail.example.com' --pem --pfx --http --http.webroot='/var/www/html' run
```

#### Параметры

- `--accept-tos` - автоматически принять соглашение.
- `--path` - путь к хранилищу сертификатов (`/root/apps/acme/`).
- `--email` - адрес электронной почты для регистрации и восстановления сертификата Let’s Encrypt (`mail@example.com`).
- `--domains` - список доменов для получения сертификата (`example.com` и `mail.example.co`).
- `--http` - получение сертификата методом `HTTP-01`.
- `--http.webroot` - WEB-директория сервера для интеграции идентификатора `.well-known/acme-challenge`.

### Обновление сертификата

- Обновить сертификат для доменов `example.com` и `mail.example.com` в директории `/root/apps/acme/` и запустить файл `hook.sh` при успешном обновлении:

```bash
APP="${HOME}/apps/acme"; "${APP}/lego" --path="${APP}" --email='mail@example.com' --domains='example.com' --domains='mail.example.com' --pem --pfx --http --http.webroot='/var/www/html' --renew-hook="${APP}/hook.sh" renew
```

#### Параметры

- `--renew-hook` - выполнение специального скрипта только после успешного обновления сертификата.

#### Задание

- Создать файл `/etc/cron.d/app_acme_example_com` со следующим содержанием:

{{< file "app_acme_example_com.http" "bash" >}}

## Метод DNS-01

Let’s Encrypt проверяет принадлежность домена клиенту при помощи специальной TXT-записи `_acme-challenge.example.com` для доменного имени.

Плюсы метода:

- Позволяет получать wildcard-сертификаты.
- Работает со множеством серверов.

Минусы метода:

- Необходимо хранить данные API от DNS-провайдера на сервере.
- DNS-провайдер может не предоставлять специальный API для изменения записей домена.
- Нельзя использовать для проверки IP-адресов.

### Получение сертификата

- Зарегистрировать адрес `mail@example.com` и получить сертификат для доменов `example.com` и `*.example.com` в директорию `/root/apps/acme/`:

```bash
CF_DNS_API_TOKEN='TOKEN'; APP="${HOME}/apps/acme"; "${APP}/lego" --accept-tos --path="${APP}" --email='mail@example.com' --domains='example.com' --domains='*.example.com' --pem --pfx --dns='cloudflare' --dns.resolvers '1.1.1.1:53' --dns.resolvers '8.8.8.8:53' --dns.resolvers '77.88.8.8:53' run
```

#### Параметры
- `CF_DNS_API_TOKEN` - токен доступа {{< tag "LeGo" >}} к редактированию зоны `example.com`.
- `--accept-tos` - автоматически принять соглашение.
- `--path` - путь к хранилищу сертификатов (`/root/apps/acme`).
- `--email` - адрес электронной почты для регистрации и восстановления сертификата Let’s Encrypt (`mail@example.com`).
- `--domains` - список доменов для получения сертификата (`example.com` и `*.example.com`).
- `--dns` - получение сертификата методом `DNS-01`.
- `--dns.resolvers` - список внешних серверов DNS для доменных имён.

### Обновление сертификата

- Обновить сертификат для доменов `example.com` и `*.example.com` в директории `/root/apps/acme/` и запустить файл `hook.sh` при успешном обновлении:

```bash
CF_DNS_API_TOKEN='TOKEN'; APP="${HOME}/apps/acme"; "${APP}/lego" --path="${APP}" --email='mail@example.com' --domains='example.com' --domains='*.example.com' --pem --pfx --dns='cloudflare' --dns.resolvers '1.1.1.1:53' --dns.resolvers '8.8.8.8:53' --dns.resolvers '77.88.8.8:53' --renew-hook="${APP}/hook.sh" renew
```

#### Параметры

- `--renew-hook` - выполнение специального скрипта только после успешного обновления сертификата.

#### Задание

- Создать файл `/etc/cron.d/app_acme_example_com` со следующим содержанием:

{{< file "app_acme_example_com.dns" "bash" >}}

## Метод TLS-ALPN-01

Проверка TLS-ALPN-01 выполняется через TLS handshake на порте `443`. Применяется специальный протокол `ALPN`, чтобы на запросы валидации отвечали только серверы, знающие о таком типе проверки. Присутствует возможность использовать поле `SNI`, совпадающее с именем домена, для которого проводится валидация, для увеличения надёжности проверки.

Плюсы метода:

- Работает при закрытом порте `80`.
- Проверка выполняется исключительно на уровне TLS.
- Можно использовать для проверки IP-адресов.

Минусы метода:

- Возможно, какие-то web-серверы не поддерживают данный метод проверки.
- Не позволяет получать wildcard-сертификаты.

### Настройка Angie

К сожалению, метод проверки требует не занятого порта `443`. Если какой то сервис уже занимает порт `443`, то этот сервис на время проверки необходимо выключить. Чтобы обойти данное ограничение, можно до-настроить Angie таким образом, чтобы он соединения `TLS-ALPN` перенаправлял на сервис проверки сертификатов, а остальные соединения направлял на виртуальные хосты HTTPS.

- На всех виртуальных хостах изменить порт `443` на `8443`.
- Создать балансировщик нагрузки `ALPN`, добавив в файл `/etc/angie/angie.conf` следующую конфигурацию:

```nginx
stream {
  map $ssl_preread_alpn_protocols $tls_port {
    ~\bacme-tls/1\b 10443;
    default 8443;
  }

  server {
    listen 443;
    proxy_pass 127.0.0.1:$tls_port;
    ssl_preread on;
  }
}
```

### Получение сертификата

- Зарегистрировать адрес `mail@example.com` и получить сертификат для доменов `example.com` и `mail.example.com` в директорию `/root/apps/acme/`:

```bash
APP="${HOME}/apps/acme"; "${APP}/lego" --accept-tos --path="${APP}" --email='mail@example.com' --domains='example.com' --domains='mail.example.com' --pem --pfx --tls --tls.port=':10443' run
```

#### Параметры

- `--accept-tos` - автоматически принять соглашение.
- `--path` - путь к хранилищу сертификатов (`/root/apps/acme/`).
- `--email` - адрес электронной почты для регистрации и восстановления сертификата Let’s Encrypt (`mail@example.com`).
- `--domains` - список доменов для получения сертификата (`example.com` и `mail.example.co`).
- `--tls` - получение сертификата методом `TLS-ALPN-01`.
- `--tls.port` - номер порта для работы {{< tag "LeGo" >}} (`10443`).

### Обновление сертификата

- Обновить сертификат для доменов `example.com` и `mail.example.com` в директории `/root/apps/acme/` и запустить файл `hook.sh` при успешном обновлении:

```bash
APP="${HOME}/apps/acme"; "${APP}/lego" --path="${APP}" --email='mail@example.com' --domains='example.com' --domains='mail.example.com' --pem --pfx --tls --tls.port=':10443' --renew-hook="${APP}/hook.sh" renew
```

#### Параметры

- `--renew-hook` - выполнение специального скрипта только после успешного обновления сертификата.

#### Задание

- Создать файл `/etc/cron.d/app_acme_example_com` со следующим содержанием:

{{< file "app_acme_example_com.tls" "bash" >}}

## Hook

- Создать файл приложения `/root/apps/acme/hook.sh` со следующим содержанием:

{{< file "hook.sh" "bash" >}}

- Создать файл настроек `/root/apps/acme/hook.conf` со следующим содержанием:

{{< file "hook.conf" "ini" >}}
