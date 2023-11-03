---
title: 'Настройка времени в Linux'
description: ''
images:
  - 'https://images.unsplash.com/photo-1501139083538-0139583c060f'
categories:
  - 'terminal'
  - 'linux'
tags:
  - 'time'
  - 'timezone'
  - 'hwclock'
authors:
  - 'KitsuneSolar'
license: 'CC-BY-SA-4.0'
complexity: '0'
toc: 1
comments: 1

date: '2021-05-15T19:22:34+03:00'

type: 'articles'
hash: '8bdb6bfec516beed99e405003575d2109a5bd949'
uuid: '8bdb6bfe-c516-5eed-a9e4-05003575d210'
slug: '8bdb6bfe-c516-5eed-a9e4-05003575d210'

draft: 0
---

<!--more-->

## Системные часы

```sh
timedatectl status
```

```text
               Local time: Sat 2021-05-15 19:44:40 MSK
           Universal time: Sat 2021-05-15 16:44:40 UTC
                 RTC time: Sat 2021-05-15 16:44:40
                Time zone: Europe/Moscow (MSK, +0300)
System clock synchronized: yes
              NTP service: active
          RTC in local TZ: no
```

```sh
timedatectl set-ntp true
```

```sh
systemctl status systemd-timesyncd
```

```sh
systemctl enable systemd-timesyncd --now
```

```sh
timedatectl list-timezones
```

```sh
timedatectl set-timezone Europe/Moscow
```

```sh
timedatectl set-time "yyyy-MM-dd hh:mm:ss"
```

```sh
timedatectl set-time "2014-05-26 11:13:54"
```

## Аппаратные часы

```sh
hwclock --show
```

```sh
hwclock --systohc
```
