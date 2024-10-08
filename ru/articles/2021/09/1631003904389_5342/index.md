---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'dhclient отправляет 36-значный идентификатор вместо MAC'
description: ''
images:
  - 'https://images.unsplash.com/photo-1544197150-b99a580bb7a8'
categories:
  - 'linux'
tags:
  - 'debian'
  - 'dhcp'
  - 'dhclient'
authors:
  - 'KaiKimera'
sources:
  - 'https://bugzilla.redhat.com/show_bug.cgi?id=560361'
license: 'CC-BY-SA-4.0'
complexity: '0'
toc: 1
comments: 1

# -------------------------------------------------------------------------------------------------------------------- #
# DATE
# -------------------------------------------------------------------------------------------------------------------- #

date: '2021-09-07T11:38:24+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: 'aeed7c90003af32a22c43807aaee88fa20faec05'
uuid: 'aeed7c90-003a-532a-b2c4-3807aaee88fa'
slug: 'aeed7c90-003a-532a-b2c4-3807aaee88fa'

draft: 0
---

Начиная с {{< tag "Debian" >}} 10 в составе дистрибутива поставляется новая версия {{< tag "dhclient" >}}, которая стала более совместимой с RFC. Поэтому, {{< tag "dhclient" >}} теперь отправляет не прямой {{< tag "MAC" >}}, а 36-значный идентификатор.

<!--more-->

Чтобы указать {{< tag "dhclient" >}}'у отправлять обычный {{< tag "MAC" >}}, необходимо в `/etc/dhcp/dhclient.conf` прописать строку:

```ini
send dhcp-client-identifier = hardware;
```

Тоже самое при помощи команды:

```bash
echo 'send dhcp-client-identifier = hardware;' >> /etc/dhcp/dhclient.conf
```
