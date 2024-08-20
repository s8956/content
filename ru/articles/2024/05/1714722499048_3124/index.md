---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Cisco: Туннель GRE/IPsec (Site-to-Site) + OSPF'
description: ''
images:
  - 'https://images.unsplash.com/photo-1616253426172-74a82120b7bf'
categories:
  - 'network'
  - 'inDev'
tags:
  - 'cisco'
  - 'ios'
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
# DATE
# -------------------------------------------------------------------------------------------------------------------- #

date: '2024-05-03T10:48:22+03:00'
publishDate: '2024-05-03T10:48:22+03:00'
expiryDate: ''
lastMod: '2024-05-03T10:48:22+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '7b3bb6b3c7dbc50c2bf69d88c66a8a74cdc7571d'
uuid: '7b3bb6b3-c7db-550c-abf6-9d88c66a8a74'
slug: '7b3bb6b3-c7db-550c-abf6-9d88c66a8a74'

draft: 0
---

Инструкция по созданию туннеля {{< tag "GRE" >}} с шифрованием {{< tag "IPsec" >}} на {{< tag "Cisco" >}}.

<!--more-->

## Вводные данные

- Маршрутизатор `R1`:
  - WAN IP: `1.1.1.1`.
  - LAN IP: `10.1.0.1`.
  - Network: `10.1.0.0/16`.
  - TUN0 IP: `10.255.255.1/24`.
- Маршрутизатор `R2`:
  - WAN IP: `2.2.2.2`.
  - LAN IP: `10.2.0.1`.
  - Network: `10.2.0.0/16`.
  - TUN0 IP: `10.255.255.2/24`.

## Настройки маршрутизаторов

### Router #1

- Создаём политику {{< tag "IPsec" >}}:
  - Метод шифрования для **Phase 1**: `encr aes 256`.
  - Использование общего ключа для проверки подлинности: `authentication pre-share`.
  - Группа Diffie–Hellman: `group 2`.

```
crypto isakmp policy 5
  encr aes 256
  authentication pre-share
  group 2
```

- Указываем общий ключ:
  - Общий ключ: `PassWord`.
  - IP-адрес удалённого маршрутизатора `R2`: `2.2.2.2`.

```
crypto isakmp key PassWord address 2.2.2.2
```

- Настраиваем набор преобразований для защиты данных:
  - Название набора преобразований: `GRE-TS`.
  - Метод шифрования: `esp-aes 256`.
  - Алгоритм хеширования: `esp-sha-hmac`.

```
crypto ipsec transform-set GRE-TS esp-aes 256 esp-sha-hmac
```

- Создаём профиль {{< tag "IPsec" >}}:
  - Название туннеля: `GRE-STS`.
  - Название набора преобразований: `GRE-TS`.
  - Алгоритм Diffie–Hellman'а (1024 бита): `pfs group2`. Использование данной опции позволяет повысить уровень защищенности трафика - при создании каждого IPsec SA производится выработка новых сессионных ключей.

```
crypto ipsec profile GRE-STS
  set transform-set GRE-TS
  set pfs group2
```

- Создаём туннель:
  - Название интерфейса: `Tunnel0`.
  - IP-адрес и маска интерфейса: `10.255.255.1 255.255.255.0`.
  - MTU: `1400`.
  - MSS: `1360`.
  - WAN IP-адрес локального маршрутизатора `R1`: `1.1.1.1`.
  - WAN IP-адрес удалённого маршрутизатора `R2`: `2.2.2.2`.
  - Профиль {{< tag "IPsec" >}}: `GRE-STS`.

```
interface Tunnel0
  ip address 10.255.255.1 255.255.255.0
  ip mtu 1400
  ip tcp adjust-mss 1360
  ip ospf mtu-ignore
  tunnel source 1.1.1.1
  tunnel destination 2.2.2.2
  tunnel protection ipsec profile GRE-STS
```

- Прописываем маршрут до удалённого роутера `R2`:
  - Сеть удалённого роутера `R2`: `10.2.0.0`.
  - Маска подсети удалённого роутера `R2`: `255.255.0.0`.
  - IP-адрес шлюза удалённого роутера `R2`: `10.255.255.2`.

```
ip route 10.2.0.0 255.255.0.0 10.255.255.2
```

- Настройка {{< tag "OSPF" >}}:
  - Указание ID маршрутизатора: `router-id 10.1.0.1`.
  - Отключение HELLO-пакетов на всех интерфейсах: `passive-interface default`.
  - Включение HELLO-пакетов на интерфейсе `Tunnel0`: `no passive-interface Tunnel0`.
  - Анонсирование сети `10.1.0.0/16` в {{< tag "OSPF" >}}: `network 10.1.0.0 0.0.255.255 area 0`.

```
router ospf 5
  router-id 10.1.0.1
  passive-interface default
  no passive-interface Tunnel0
  network 10.1.0.0 0.0.255.255 area 0
```

### Router #2

- Создаём политику {{< tag "IPsec" >}}:
  - Метод шифрования для **Phase 1**: `encr aes 256`.
  - Использование общего ключа для проверки подлинности: `authentication pre-share`.
  - Группа Diffie–Hellman: `group 2`.

```
crypto isakmp policy 5
  encr aes 256
  authentication pre-share
  group 2
```

- Указываем общий ключ:
  - Общий ключ: `PassWord`.
  - IP адрес удалённого маршрутизатора `R1`: `1.1.1.1`.

```
crypto isakmp key PassWord address 1.1.1.1
```

- Настраиваем набор преобразований для защиты данных:
  - Название набора преобразований: `GRE-TS`.
  - Метод шифрования: `esp-aes 256`.
  - Алгоритм хеширования: `esp-sha-hmac`.

```
crypto ipsec transform-set GRE-TS esp-aes 256 esp-sha-hmac
```

- Создаём профиль {{< tag "IPsec" >}}:
  - Название туннеля: `GRE-STS`.
  - Название набора преобразований: `GRE-TS`.
  - Алгоритм Diffie–Hellman'а (1024 бита): `pfs group2`. Использование данной опции позволяет повысить уровень защищенности трафика - при создании каждого IPsec SA производится выработка новых сессионных ключей.

```
crypto ipsec profile GRE-STS
  set transform-set GRE-TS
  set pfs group2
```

- Создаём туннель:
  - Название интерфейса: `Tunnel0`.
  - IP-адрес и маска интерфейса: `10.255.255.2 255.255.255.0`.
  - MTU: `1400`.
  - MSS: `1360`.
  - WAN IP-адрес локального маршрутизатора `R2`: `2.2.2.2`.
  - WAN IP-адрес удалённого маршрутизатора `R1`: `1.1.1.1`.
  - Профиль {{< tag "IPsec" >}}: `GRE-STS`.

```
interface Tunnel0
  ip address 10.255.255.2 255.255.255.0
  ip mtu 1400
  ip tcp adjust-mss 1360
  ip ospf mtu-ignore
  tunnel source 2.2.2.2
  tunnel destination 1.1.1.1
  tunnel protection ipsec profile GRE-STS
```

- Прописываем маршрут до удалённого роутера `R1`:
  - Сеть удалённого роутера `R1`: `10.1.0.0`.
  - Маска подсети удалённого роутера `R1`: `255.255.0.0`.
  - IP-адрес шлюза удалённого роутера `R1`: `10.255.255.1`.

```
ip route 10.1.0.0 255.255.0.0 10.255.255.1
```

- Настройка {{< tag "OSPF" >}}:
  - Указание ID маршрутизатора: `router-id 10.2.0.1`.
  - Отключение HELLO-пакетов на всех интерфейсах: `passive-interface default`.
  - Включение HELLO-пакетов на интерфейсе `Tunnel0`: `no passive-interface Tunnel0`.
  - Анонсирование сети `10.1.0.0/16` в {{< tag "OSPF" >}}: `network 10.2.0.0 0.0.255.255 area 0`.

```
router ospf 5
  router-id 10.2.0.1
  passive-interface default
  no passive-interface Tunnel0
  network 10.2.0.0 0.0.255.255 area 0
```
