---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Cisco: Установка лицензий'
description: ''
images:
  - 'https://images.unsplash.com/photo-1593964301765-5c7ff5adf65c'
categories:
  - 'network'
  - 'terminal'
tags:
  - 'cisco'
  - 'license'
authors:
  - 'KaiKimera'
sources:
  - 'https://ciscotips.ru/cisco-ios-versions'
  - 'https://ciscotips.ru/cisco-ios-license-activation'
  - 'http://ciscomaster.ru/content/ustanovka-licenziy-na-cisco-routers-3-go-pokoleniya-43xx-44xx'
license: 'CC-BY-SA-4.0'
complexity: '0'
toc: 1
comments: 1

# -------------------------------------------------------------------------------------------------------------------- #
# DATE
# -------------------------------------------------------------------------------------------------------------------- #

date: '2024-04-13T22:45:46+03:00'
publishDate: '2024-04-13T22:45:46+03:00'
lastMod: '2024-04-13T22:45:46+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '9538d25fc1459a84658365f3a2ed4c84c13bc988'
uuid: '9538d25f-c145-5a84-8583-65f3a2ed4c84'
slug: '9538d25f-c145-5a84-8583-65f3a2ed4c84'

draft: 0
---

Рассмотрим этапы установки лицензии на оборудование {{< tag "Cisco" >}}, а также экспортирование уже установленных лицензий в специальный файл.

<!--more-->

Лицензия привязывается к уникальному идентификатору устройства (**U**nique **D**evice **I**dentifier). **UDI** представляет собой строку, состоящую из **PID** (идентификатор продукта) и **SN** (серийный номер). Посмотреть UDI можно командой:

```
# show license udi
```

## Импортирование лицензий

Необходимо предварительно настроить сетевой интерфейс компьютера со следующими параметрами:

- IP-адрес: `192.168.1.2`.
- Маска подсети: `255.255.255.0`.
- Шлюз: `192.168.1.1`.
- DNS: `8.8.8.8`.

Теперь настроим сетевой интерфейс `FE0/1` на {{< tag "Cisco" >}}:

```
# conf t
(config)# int fa0/1
(config-if)# ip address 192.168.1.1 255.255.255.0
(config-if)# no shutdown
(config-if)# exit
(config)# exit
#
```

После предварительных настроек, подключим сетевой интерфейс компьютера к сетевому интерфейсу {{< tag "Cisco" >}} `FE0/1` и запустим TFTP-сервер на компьютере с IP `192.168.1.2`.

### Установка лицензий

Загружаем файл лицензии `LICENSE_FILE.lic` на флэш-карту {{< tag "Cisco" >}}:

```
# copy tftp://192.168.1.2/LICENSE_FILE.lic flash:
```

Импортируем файл лицензии `LICENSE_FILE.lic` с флэш-карты в память {{< tag "Cisco" >}}:

```
# license install flash:LICENSE_FILE.lic
```

И перезапускаем оборудование:

```
# reload
```

После перезапуска, {{< tag "Cisco" >}} включит дополнительные функции согласно установленным лицензиям.

### Информация о лицензиях

Посмотреть версию оборудования и установленные лицензии можно следующей командой:

```
# show version
```

- В столбце `Type` должно быть указано `Permanent`.

Более подробную информацию о лицензиях на оборудовании можно посмотреть следующей командой:

```
# show license
```

При корректно установленной лицензии, в её параметрах должны быть следующие сведения:

- В строке `Period left` должно быть указано `Life time`.
- в строке `License Type` должно быть указано `Permanent`.

## Экспортирование лицензий

{{< alert "important" >}}
Файл с лицензиями следует сохранить в надёжном месте!
{{< /alert >}}

Если потребуется заменить флэш-карту или сдать оборудование в ремонт, можно экспортировать существующие лицензии в файл:

```
# license save flash:ALL_LICENSE.lic
```

Где:
- `ALL_LICENSE.lic` - название создаваемого файла с лицензиями.
