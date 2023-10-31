---
title: 'Debian: Wired Networks are Unmanaged'
description: ''
images:
  - 'https://images.unsplash.com/photo-1554098415-4052459dc340'
categories:
  - 'linux'
tags:
  - 'debian'
  - 'systemd'
  - 'network'
  - 'network-manager'
authors:
  - 'KitsuneSolar'
sources:
  - 'https://wiki.debian.org/NetworkManager'
license: 'CC-BY-SA-4.0'
complexity: '0'
toc: 1
comments: 1

date: '2021-09-09T22:14:12+03:00'
hash: 'ff829d154a1962e393aaad70aa38854a058ec967'
uuid: 'ff829d15-4a19-52e3-a3aa-ad70aa38854a'
slug: 'ff829d15-4a19-52e3-a3aa-ad70aa38854a'

draft: 0
---

При базовой установке Debian, Network Manager не устанавливается и, соответственно, он не управляет сетевой конфигурацией. Исправим данную ситуацию...

<!--more-->

Лично я люблю ставить систему в минимальной комплектации. У меня есть [отдельный ресурс](https://uaik.github.io/) со сценариями автоматической установки. Это шаблоны, которые позволяют поставить систему в автоматическом режиме и с минимальным набором компонентов. В основном, такие шаблоны полезны для серверов. Однако, для домашнего компьютера тоже вполне подойдут. Но после установки домашней системы через такой шаблон, потребуется небольшая корректировка.

Итак, установим Network Manager при помощи пакетного менеджера **APT**:

```sh
apt install network-manager
```

Но этого недостаточно. Система будет говорить, что "Wired Networks are Unmanaged", потому что всё ещё сетевой конфигурацией управляет не Network Manager. Для исправления этой ситуации, необходимо в `/etc/NetworkManager/NetworkManager.conf` изменить `managed=false` на `managed=true`.

Далее, перезапустить службу:

```sh
service NetworkManager restart
```

На этом всё. Теперь сетевой конфигурацией управляет Network Manager.