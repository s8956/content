---
# -------------------------------------------------------------------------------------------------------------------- #
# General settings.
# -------------------------------------------------------------------------------------------------------------------- #

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
  - 'KaiKimera'
license: 'CC-BY-SA-4.0'
complexity: '0'
toc: 1
comments: 1

# -------------------------------------------------------------------------------------------------------------------- #
# Date settings.
# -------------------------------------------------------------------------------------------------------------------- #

date: '2021-05-15T19:22:34+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# Meta settings.
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '8bdb6bfec516beed99e405003575d2109a5bd949'
uuid: '8bdb6bfe-c516-5eed-a9e4-05003575d210'
slug: '8bdb6bfe-c516-5eed-a9e4-05003575d210'

draft: 1
---

<!--more-->

## Системные часы

{{< code "sh" >}}
timedatectl status
{{< /code >}}

{{< code "text" >}}
               Local time: Sat 2021-05-15 19:44:40 MSK
           Universal time: Sat 2021-05-15 16:44:40 UTC
                 RTC time: Sat 2021-05-15 16:44:40
                Time zone: Europe/Moscow (MSK, +0300)
System clock synchronized: yes
              NTP service: active
          RTC in local TZ: no
{{< /code >}}

{{< code "sh" >}}
timedatectl set-ntp true
{{< /code >}}

{{< code "sh" >}}
systemctl status systemd-timesyncd
{{< /code >}}

{{< code "sh" >}}
systemctl enable systemd-timesyncd --now
{{< /code >}}

{{< code "sh" >}}
timedatectl list-timezones
{{< /code >}}

{{< code "sh" >}}
timedatectl set-timezone Europe/Moscow
{{< /code >}}

{{< code "sh" >}}
timedatectl set-time "yyyy-MM-dd hh:mm:ss"
{{< /code >}}

{{< code "sh" >}}
timedatectl set-time "2014-05-26 11:13:54"
{{< /code >}}

## Аппаратные часы

{{< code "sh" >}}
hwclock --show
{{< /code >}}

{{< code "sh" >}}
hwclock --systohc
{{< /code >}}
