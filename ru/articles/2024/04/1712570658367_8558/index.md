---
# -------------------------------------------------------------------------------------------------------------------- #
# General settings.
# -------------------------------------------------------------------------------------------------------------------- #

title: 'MikroTik: GRE/IPsec'
description: ''
images:
  - 'https://images.unsplash.com/photo-1585776245991-cf89dd7fc73a'
categories:
  - 'inDev'
  - 'network'
tags:
  - 'mikrotik'
  - 'gre'
  - 'ipsec'
authors:
  - 'KaiKimera'
sources:
  - ''
license: 'CC-BY-SA-4.0'
complexity: '1'
toc: 1
comments: 1

# -------------------------------------------------------------------------------------------------------------------- #
# Date settings.
# -------------------------------------------------------------------------------------------------------------------- #

date: '2024-04-08T13:04:21+03:00'
publishDate: '2024-04-08T13:04:21+03:00'
expiryDate: ''
lastMod: '2024-04-08T13:04:21+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# Meta settings.
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '326618afd9501001d11457c66bb8a5af77df3198'
uuid: '326618af-d950-5001-8114-57c66bb8a5af'
slug: '326618af-d950-5001-8114-57c66bb8a5af'

draft: 1
---



<!--more-->

## Вводные данные

- Маршрутизатор `R1`:
  - WAN IP: `gw1.example.com`.
  - LAN IP: `10.1.0.1`.
  - Network: `10.1.0.0/16`.
- Маршрутизатор `R2`:
  - WAN IP: `gw2.example.com`.
  - LAN IP: `10.2.0.1`.
  - Network: `10.2.0.0/16`.

## Настройка маршрутизаторов

### Router #1

```
/interface gre
add allow-fast-path=no ipsec-secret="pa$$word" name=gre-gw1-gw2 local-address=1.1.1.1 remote-address=2.2.2.2 comment="HOST: gw2.example.com"
```

```
/ip address
add address=10.255.255.1/24 interface=gre-gw1 network=10.255.255.0 comment="[GRE] GRE-GW1-GW2"
```

```
/ip route
add distance=1 dst-address=10.2.0.0/16 gateway=10.255.255.2 comment="[GRE] GW2"
```

### Router #2

```
/interface gre
add allow-fast-path=no ipsec-secret="pa$$word" name=gre-gw2-gw1 local-address=2.2.2.2 remote-address=1.1.1.1 comment="HOST: gw1.example.com"
```

```
/ip address
add address=10.255.255.2/24 interface=gre-gw02 network=10.255.255.0 comment="[GRE] GW2-GW1"
```

```
/ip route
add distance=1 dst-address=10.1.0.0/16 gateway=10.255.255.1 comment="[GRE] GW01"
```

### Динамический IP

{{< file "ros.gre.dip.rsc" text >}}
