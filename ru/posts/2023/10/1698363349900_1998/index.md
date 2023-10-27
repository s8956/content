---
title: 'PowerShell: Изменение порта для RDP'
description: ''
images:
  - 'https://images.unsplash.com/photo-1509483730228-811e47696246'
cover:
  crop: 'entropy'
  fit: 'crop'
categories:
  - 'windows'
  - 'terminal'
  - 'scripts'
tags:
  - 'powershell'
  - 'rdp'
authors:
  - 'KitsuneSolar'
sources:
  - ''
license: 'CC-BY-SA-4.0'
complexity: '0'
toc: 1
comments: 1

date: '2023-10-27T02:35:50+03:00'
publishDate: '2023-10-27T02:35:50+03:00'
expiryDate: ''
lastMod: '2023-10-27T02:35:50+03:00'

hash: '616da78aeb16275a711965f0c0c7baeed826286a'
uuid: '616da78a-eb16-575a-9119-65f0c0c7baee'
slug: '616da78a-eb16-575a-9119-65f0c0c7baee'

draft: 0
---

По умолчанию, RDP использует порт TCP `3389`, но по каким-либо обстоятельствам приходится его менять. Рассмотрим два способа изменения порта RDP.

<!--more-->

## Ручное изменение порта

Для изменения порта RDP, нужно отредактировать реестр:

1. Открыть редактор реестра `regedit.exe`.
2. Пройти по пути `HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp`.
3. Найти параметр `PortNumber`.
4. Ввести новый номер порта (decimal).
5. Перезагрузить компьютер.

{{< alert "important" >}}
Если включён брандмауэр, необходимо в нём разрешить подключение через новый порт RDP.
{{< /alert >}}

## Автоматизация

Весь процесс можно автоматизировать при помощи скрипта.

### Параметры

Скрипт имеет один единственный параметр, это номер порта.

- `-P` `-P_Port` - номер порта RDP.

### Примеры

Запускается скрипт обычным способом. В параметр `-P` указывается новый номер порта RDP.

```
.\pwsh.rdp.port.ps1 -P 50102
```

### Скрипт

{{< file "pwsh.rdp.port.ps1" >}}
