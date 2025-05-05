---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'ClamAV: Установка и настройка'
description: ''
images:
  - 'https://images.unsplash.com/photo-1640552435388-a54879e72b28'
categories:
  - 'linux'
  - 'security'
  - 'network'
tags:
  - 'debian'
  - 'apt'
  - 'clamav'
  - 'install'
authors:
  - 'KaiKimera'
sources:
  - 'https://www.clamav.net/downloads'
  - 'https://docs.clamav.net/manual/Installing.html'
  - 'https://docs.clamav.net/manual/Installing/Add-clamav-user.html'
  - 'https://docs.clamav.net/manual/Usage/Configuration.html'
license: 'CC-BY-SA-4.0'
complexity: '0'
toc: 1
comments: 1

# -------------------------------------------------------------------------------------------------------------------- #
# DATE
# -------------------------------------------------------------------------------------------------------------------- #

date: '2025-04-30T17:53:42+03:00'
publishDate: '2025-04-30T17:53:42+03:00'
lastMod: '2025-04-30T17:53:42+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: 'd5729fa5d717e6c9af9645530459d0f87cc38d3c'
uuid: 'd5729fa5-d717-56c9-af96-45530459d0f8'
slug: 'd5729fa5-d717-56c9-af96-45530459d0f8'

draft: 1
---

Инструкция по установке {{< tag "ClamAV" >}} из официального пакета Cisco Talos.

<!--more-->

## Установка

- Скачать и установить `clamav.linux.x86_64.deb`:

```bash
v='1.4.2'; curl -fSLo "clamav-${v}.linux.x86_64.deb" "https://www.clamav.net/downloads/production/clamav-${v}.linux.x86_64.deb" && apt install --yes ./"clamav-${v}.linux.x86_64.deb"
```

- Создать пользователя `clamav` с домашней директорией `/var/lib/clamav`:

```bash
u='clamav'; d='/var/lib/clamav'; adduser --system --no-create-home --disabled-login --disabled-password --shell '/bin/false' --group --home "${d}" "${u}" && chown "${u}":"${u}" "${d}"
```

{{< alert "tip" >}}
Если планируется интеграция ClamAV с Amavis, то пользователя `clamav` необходимо добавить в группу `amavis`:

```bash
u='clamav'; g='amavis'; usermod -aG "${g}" "${u}"
```
{{< /alert >}}

- Создать директории `/run/clamav` и`/var/log/clamav` для логирования:

```bash
u='clamav'; for i in '/run/clamav' '/var/log/clamav'; do install -d -g "${u}" -o "${u}" "${i}";done
```

- Скачать файлы сервисов для `systemd`:

```bash
f=('clamonacc.service' 'daemon.service' 'daemon.socket' 'freshclam-once.service' 'freshclam-once.timer' 'freshclam.service'); d='/etc/systemd/system'; p='https://lib.onl/ru/2025/04/d5729fa5-d717-56c9-af96-45530459d0f8'; for i in "${f[@]}"; do curl -fsSLo "${d}/clamav-${i}" "${p}/clamav-${i}"; done
```

## Настройка

- Скачать файлы конфигурации `clamd.conf` и `freshclam.conf`:

```bash
f=('clamd.conf' 'freshclam.conf'); d='/usr/local/etc'; p='https://lib.onl/ru/2025/04/d5729fa5-d717-56c9-af96-45530459d0f8'; for i in "${f[@]}"; do curl -fsSLo "${d}/${i}" "${p}/${i}"; done
```

- Запустить скачивание и обновление баз данных:

```bash
freshclam
```
