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
  - 'cat_03'
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

```sh
apt update && apt --yes upgrade && apt --yes install git curl wget subversion build-essential
```

## Установка Asterisk

### Установка библиотеки декодера MP3

```sh
bash contrib/scripts/get_mp3_source.sh
```

### Установка требуемых для сборки пакетов

```sh
bash contrib/scripts/install_prereq install
```

### Конфигурация сборки

```sh
./configure
```

### Выбор компонентов Asterisk

```sh
make menuselect
```

Выбрать:

- Applications
  - `app_macro`
- Core Sound Packages
  - `CORE-SOUNDS-EN-GSM`
  - `CORE-SOUNDS-RU-GSM`

### Сборка и установка Asterisk

```sh
make && make install && make config && ldconfig
```

```sh
make basic-pbx
```

## Настройка Asterisk

### Настройка пользователя

```sh
u='asterisk'; groupadd ${u} && useradd -r -d /var/lib/${u} -g ${u} ${u} && usermod -aG audio,dialout ${u} && chown -R ${u}:${u} /etc/${u} && chown -R ${u}:${u} /var/{lib,log,spool}/${u} && chown -R ${u}:${u} /usr/lib/${u}
```

### Редактирование конфигурации

```sh
sed -i 's|#AST_USER="asterisk"|AST_USER="asterisk"|g' '/etc/default/asterisk' && sed -i 's|#AST_GROUP="asterisk"|AST_GROUP="asterisk"|g' '/etc/default/asterisk'
```

```sh
sed -i 's|;runuser = asterisk|runuser = asterisk|g' '/etc/asterisk/asterisk.conf' && sed -i 's|;rungroup = asterisk|rungroup = asterisk|g' '/etc/asterisk/asterisk.conf'
```

## Запуск Asterisk

```sh
systemctl enable --now asterisk
```

```terminal {os="linux",mode="root",hl="text"}
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
```

```terminal {os="linux",mode="root",hl="text"}
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
```

```sh
ossl_ec='prime256v1'; ossl_sig_hash='sha256'; ossl_days='3650'; ossl_country='RU'; ossl_state='Russia'; ossl_city='Moscow'; ossl_org='RiK'; ossl_host='example.com'; openssl ecparam -genkey -name ${ossl_ec} -out "${ossl_host}.key" && openssl req -new -sha256 -key "${ossl_host}.key" -out "${ossl_host}.csr" -subj "/C=${ossl_country}/ST=${ossl_state}/L=${ossl_city}/O=${ossl_org}/CN=${ossl_host}" -addext "subjectAltName=DNS:${ossl_host},DNS:*.${ossl_host}" && openssl req -x509 -${ossl_sig_hash} -days ${ossl_days} -key "${ossl_host}.key" -in "${ossl_host}.csr" -out "${ossl_host}.crt" && openssl x509 -in "${ossl_host}.crt" -text -noout
```
