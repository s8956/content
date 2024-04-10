---
# -------------------------------------------------------------------------------------------------------------------- #
# General settings.
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Установка и настройка Asterisk'
description: ''
images:
  - 'https://images.unsplash.com/photo-1606513778362-946ffc98a3d7'
categories:
  - 'inDev'
  - 'network'
tags:
  - 'debian'
  - 'asterisk'
  - 'voip'
authors:
  - 'KaiKimera'
sources:
  - ''
license: 'CC-BY-SA-4.0'
complexity: '0'
toc: 1
comments: 1

# -------------------------------------------------------------------------------------------------------------------- #
# Date settings.
# -------------------------------------------------------------------------------------------------------------------- #

date: '2024-04-04T14:44:11+03:00'
publishDate: '2024-04-04T14:44:11+03:00'
expiryDate: ''
lastMod: '2024-04-04T14:44:11+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# Meta settings.
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '2e00b43bb0da79c28e9260dcf2ba1d5255b468e9'
uuid: '2e00b43b-b0da-59c2-ae92-60dcf2ba1d52'
slug: '2e00b43b-b0da-59c2-ae92-60dcf2ba1d52'

draft: 1
---



<!--more-->

## Обновление ОС и установка пакетов

```bash
apt update && apt --yes upgrade && apt --yes install git curl wget subversion build-essential
```

## Установка Asterisk

### Установка компонентов

```bash
bash contrib/scripts/get_mp3_source.sh && bash contrib/scripts/install_prereq install
```

### Конфигурация сборки

```bash
./configure && make menuselect.makeopts && menuselect/menuselect --enable CORE-SOUNDS-RU-GSM menuselect.makeopts
```

### Сборка и установка Asterisk

```bash
make && make install && make basic-pbx && make config && ldconfig
```

## Настройка Asterisk

### Настройка пользователя

```bash
u='asterisk'; groupadd ${u} && useradd -r -d /var/lib/${u} -g ${u} ${u} && usermod -aG audio,dialout ${u} && chown -R ${u}:${u} /etc/${u} && chown -R ${u}:${u} /var/{lib,log,spool}/${u} && chown -R ${u}:${u} /usr/lib/${u}
```

### Редактирование конфигурации

```bash
sed -i 's|#AST_USER="asterisk"|AST_USER="asterisk"|g' '/etc/default/asterisk' && sed -i 's|#AST_GROUP="asterisk"|AST_GROUP="asterisk"|g' '/etc/default/asterisk'
```

```bash
sed -i 's|;runuser = asterisk|runuser = asterisk|g' '/etc/asterisk/asterisk.conf' && sed -i 's|;rungroup = asterisk|rungroup = asterisk|g' '/etc/asterisk/asterisk.conf'
```

## Запуск Asterisk

```bash
systemctl enable --now asterisk
```

{{< terminal mode="root" >}}
systemctl status asterisk

● asterisk.service - LSB: Asterisk PBX
     Loaded: loaded (/etc/init.d/asterisk; generated)
     Active: active (running) since Thu 2024-04-04 11:51:43 UTC; 2h 5min ago
       Docs: man:systemd-sysv-generator(8)
    Process: 791 ExecStart=/etc/init.d/asterisk start (code=exited, status=0/SUCCESS)
      Tasks: 35 (limit: 1013)
     Memory: 61.1M
        CPU: 36.239s
     CGroup: /system.slice/asterisk.service
             └─871 /usr/sbin/asterisk -U asterisk -G asterisk

Apr 04 11:51:42 phone systemd[1]: Starting LSB: Asterisk PBX...
Apr 04 11:51:43 phone asterisk[791]:  * Starting Asterisk PBX: asterisk
Apr 04 11:51:43 phone asterisk[791]:    ...done.
Apr 04 11:51:43 phone systemd[1]: Started LSB: Asterisk PBX.
{{< /terminal >}}

{{< terminal mode="root" >}}
asterisk -rvv

Asterisk 20.7.0, Copyright (C) 1999 - 2022, Sangoma Technologies Corporation and others.
Created by Mark Spencer <markster@digium.com>
Asterisk comes with ABSOLUTELY NO WARRANTY; type 'core show warranty' for details.
This is free software, with components licensed under the GNU General Public
License version 2 and other licenses; you are welcome to redistribute it under
certain conditions. Type 'core show license' for details.
=========================================================================
Running as user 'asterisk'
Running under group 'asterisk'
Connected to Asterisk 20.7.0 currently running on phone (pid = 871)
phone*CLI>
{{< /terminal >}}

## TLS

```
mkdir /etc/asterisk/keys
```

`pjsip.conf`

```ini
[transport-tls]
type=transport
protocol=tls
bind=0.0.0.0:5061
cert_file=/etc/asterisk/keys/asterisk.crt
priv_key_file=/etc/asterisk/keys/asterisk.key
method=sslv23
```
