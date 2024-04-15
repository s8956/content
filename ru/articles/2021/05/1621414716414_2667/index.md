---
# -------------------------------------------------------------------------------------------------------------------- #
# General settings.
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Настройка статического IP адреса'
description: ''
images:
  - 'https://images.unsplash.com/photo-1544197150-b99a580bb7a8'
categories:
  - 'terminal'
  - 'linux'
  - 'network'
  - 'inDev'
tags:
  - 'ip'
authors:
  - 'KaiKimera'
license: 'CC-BY-SA-4.0'
complexity: '1'
toc: 1
comments: 1

# -------------------------------------------------------------------------------------------------------------------- #
# Date settings.
# -------------------------------------------------------------------------------------------------------------------- #

date: '2021-05-15T20:08:30+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# Meta settings.
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: 'ee559a6c5cde1166bd2d3ceb55878eb8b7d7e436'
uuid: 'ee559a6c-5cde-5166-9d2d-3ceb55878eb8'
slug: 'ee559a6c-5cde-5166-9d2d-3ceb55878eb8'

draft: 0
---

Рассмотрим различные способы настройки статического IP адреса в дистрибутивах {{< tag "Linux" >}}. Способы различаются в зависимости от пакетной базы дистрибутивов. Например, настройка статического IP в {{< tag "RHEL" >}}-based дистрибутиве будет отличаться от настройки в {{< tag "DEB" >}}-based дистрибутиве.

<!--more-->

## Подготовка

Смотрим текущие сетевые устройства и соединения:

```terminal {mode="root"}
ip a

1: lo: <loopback,up,lower_up> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
  link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
  inet 127.0.0.1/8 scope host lo
2: enp1s0: <broadcast,multicast,up,lower_up> mtu 1500 qdisc fq_codel state UP group default qlen 1000
  link/ether xx:xx:xx:xx:xx:xx brd ff:ff:ff:ff:ff:ff
  inet 192.168.10.123/24 brd 192.168.10.255 scope global dynamic noprefixroute enp1s0
```

## Настройка IP в RHEL-based дистрибутивах

В директории `/etc/sysconfig/network-scripts` находятся конфигурационные файлы для сетевых интерфейсов. Имя файла состоит из префикса `ifcfg` и имени интерфейса. Например, содержимое файла для интерфейса `enp1s0`:

```terminal {mode="root"}
cat /etc/sysconfig/network-scripts/ifcfg-enp1s0

TYPE="Ethernet"
PROXY_METHOD="none"
BROWSER_ONLY="no"
BOOTPROTO="dhcp"
DEFROUTE="yes"
IPV4_FAILURE_FATAL="no"
IPV6INIT="yes"
IPV6_AUTOCONF="yes"
IPV6_DEFROUTE="yes"
IPV6_FAILURE_FATAL="no"
IPV6_ADDR_GEN_MODE="stable-privacy"
NAME="enp1s0"
UUID="<DEVICE_ID>"
DEVICE="enp1s0"
ONBOOT="yes"
```

Обратим внимание на опцию **BOOTPROTO**. По умолчанию, в опции **BOOTPROTO** прописано `dhcp`. Это означает, что сетевой интерфейс получает информацию о сети автоматически от {{< tag "DHCP" >}}. Сама опция **BOOTPROTO** может принимать следующие значения:

- `none` – не использовать протокол.
- `bootp` – использование протокола **bootp**.
- `dhcp` – использование протокола **dhcp** (по умолчанию).

Для настройки статического IP необходимо установит **BOOTPROTO** в `none` и дописать в конец файла опции:

- `IPADDR` - IP адрес.
- `PREFIX` - маска сети.
- `GATEWAY` - шлюз сети.
- `DNS` - серверы DNS.

Например:

```ini
TYPE="Ethernet"
PROXY_METHOD="none"
BROWSER_ONLY="no"
BOOTPROTO="none"
DEFROUTE="yes"
IPV4_FAILURE_FATAL="no"
IPV6INIT="yes"
IPV6_AUTOCONF="yes"
IPV6_DEFROUTE="yes"
IPV6_FAILURE_FATAL="no"
IPV6_ADDR_GEN_MODE="stable-privacy"
NAME="enp1s0"
UUID="<DEVICE_ID>"
DEVICE="enp1s0"
ONBOOT="yes"
IPADDR="192.168.10.55"
PREFIX="24"
GATEWAY="192.168.10.1"
DNS1="192.168.11.1"
DNS1="192.168.12.1"
```

После указания всех параметров, необходимо перезапустить интерфейс:

```bash
nmcli con down enp1s0 && nmcli con up enp1s0
```

## Настройка IP при помощи Network Manager CLI (nmcli)

Установка IP адреса:

```bash
nmcli con mod enp1s0 ipv4.addresses '192.168.10.55/24'
```

Установка шлюза:

```bash
nmcli con mod enp1s0 ipv4.gateway '192.168.10.1'
```

Установка {{< tag "DNS" >}}:

```bash
nmcli con mod enp1s0 ipv4.dns '192.168.11.1'
```

Установка **BOOTPROTO** в `none`:

```bash
nmcli con mod enp1s0 ipv4.method 'manual'
```

Перезапуск интерфейса:

```bash
nmcli con down enp1s0 && nmcli con up enp1s0
```
