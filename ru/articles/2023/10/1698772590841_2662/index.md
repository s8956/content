---
# -------------------------------------------------------------------------------------------------------------------- #
# General settings.
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Работа с сетевыми интерфейсами в PowerShell'
description: ''
images:
  - 'https://images.unsplash.com/photo-1597733336794-12d05021d510'
categories:
  - 'windows'
  - 'terminal'
  - 'network'
  - 'scripts'
tags:
  - 'powershell'
authors:
  - 'KaiKimera'
sources:
  - 'https://learn.microsoft.com/en-us/powershell/module/netadapter/get-netadapter'
  - 'https://learn.microsoft.com/en-us/powershell/module/netconnection/get-netconnectionprofile'
  - 'https://learn.microsoft.com/en-us/powershell/module/nettcpip/new-netipaddress'
  - 'https://learn.microsoft.com/en-us/powershell/module/nettcpip/set-netipinterface'
  - 'https://learn.microsoft.com/en-us/powershell/module/nettcpip/remove-netipaddress'
  - 'https://learn.microsoft.com/en-us/powershell/module/nettcpip/remove-netroute'
  - 'https://learn.microsoft.com/en-us/powershell/module/dnsclient/set-dnsclientserveraddress'
license: 'CC-BY-SA-4.0'
complexity: '0'
toc: 1
comments: 1

# -------------------------------------------------------------------------------------------------------------------- #
# Date settings.
# -------------------------------------------------------------------------------------------------------------------- #

date: '2023-10-31T20:16:31+03:00'
publishDate: '2023-10-31T20:16:31+03:00'
expiryDate: ''
lastMod: '2023-10-31T20:16:31+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# Meta settings.
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '430b916dfd5cbd445c248b98f41e03558d4e8100'
uuid: '430b916d-fd5c-5d44-8c24-8b98f41e0355'
slug: '430b916d-fd5c-5d44-8c24-8b98f41e0355'

draft: 0
---

Разберём основные команды, которые пригодятся нам при настройке сети в ОС {{< tag "Windows" >}} через {{< tag "PowerShell" >}}.

<!--more-->

## Сетевые адаптеры

Получить список сетевых адаптеров и их интерфейсов:

{{< code "powershell" >}}
Get-NetAdapter
{{< /code >}}

Получить список обычных и скрытых сетевых адаптеров:

{{< code "powershell" >}}
Get-NetAdapter –IncludeHidden
{{< /code >}}

Получить конфигурацию по интерфейсу `5`:

{{< code "powershell" >}}
Get-NetAdapter -InterfaceIndex 5 | Get-NetIPConfiguration
{{< /code >}}

Получить детальную конфигурацию по интерфейсу `5`:

{{< code "powershell" >}}
Get-NetAdapter -InterfaceIndex 5 | Get-NetIPConfiguration -Detailed
{{< /code >}}

Отключить адаптер с интерфейсом `5`:

{{< code "powershell" >}}
Get-NetAdapter -InterfaceIndex 5 | Disable-NetAdapter
{{< /code >}}

## Сетевые профили

Вывести информацию по текущим сетевым профилям:

{{< code "powershell" >}}
Get-NetConnectionProfile
{{< /code >}}

Получить информацию только по профилю сети интерфейса `5`:

{{< code "powershell" >}}
Get-NetAdapter -InterfaceIndex 5 | Get-NetConnectionProfile
{{< /code >}}

Изменить профиль сети интерфейса `5` на публичный (`Public`).

{{< code "powershell" >}}
Get-NetAdapter -InterfaceIndex 5 | Set-NetConnectionProfile -NetworkCategory 'Public'
{{< /code >}}

Изменить профиль сети интерфейса `5` на приватный (`Private`).

{{< code "powershell" >}}
Get-NetAdapter -InterfaceIndex 5 | Set-NetConnectionProfile -NetworkCategory 'Private'
{{< /code >}}

Изменить профиль сети интерфейса `5` на доменный (`DomainAuthenticated`).

{{< code "powershell" >}}
Get-NetAdapter -InterfaceIndex 5 | Set-NetConnectionProfile -NetworkCategory 'DomainAuthenticated'
{{< /code >}}

## Настройка IP-адреса

Отключить DHCP на интерфейсе `5`:

{{< code "powershell" >}}
Get-NetAdapter -InterfaceIndex 5 | Set-NetIPInterface -Dhcp 'Disabled'
{{< /code >}}

Установить новый IP-адрес и шлюз на интерфейсе `5`:

{{< code "powershell" >}}
Get-NetAdapter -InterfaceIndex 5 | New-NetIPAddress –IPAddress '192.168.0.10' -PrefixLength '24' -DefaultGateway '192.168.0.1'
{{< /code >}}

Изменить IP-адрес на интерфейсе `5`:

{{< code "powershell" >}}
Get-NetAdapter -InterfaceIndex 5 | Set-NetIPAddress -IPAddress '192.168.0.12'
{{< /code >}}

Удалить IP-адрес на интерфейсе `5`:

{{< code "powershell" >}}
Get-NetAdapter -InterfaceIndex 5 | Remove-NetIPAddress -Confirm:$false
{{< /code >}}

Удаление шлюза на интерфейсе `5`:

{{< code "powershell" >}}
Get-NetAdapter -InterfaceIndex 5 | Remove-NetRoute -Confirm:$false
{{< /code >}}

## Настройка DNS

Установить IP-адреса серверов {{< tag "DNS" >}} на интерфейсе `5`:

{{< code "powershell" >}}
Get-NetAdapter -InterfaceIndex 5 | Set-DNSClientServerAddress –ServerAddresses ('192.168.0.2','192.168.1.2')
{{< /code >}}

Сбросить IP-адреса серверов DNS на параметры по умолчанию на интерфейсе `5`:

{{< code "powershell" >}}
Get-NetAdapter -InterfaceIndex 5 | Set-DnsClientServerAddress -ResetServerAddresses
{{< /code >}}

Очистить кэш {{< tag "DNS" >}}:

{{< code "powershell" >}}
Clear-DnsClientCache
{{< /code >}}

## Настройка DHCP

Включить {{< tag "DHCP" >}} на интерфейсе `5`:

{{< code "powershell" >}}
Get-NetAdapter -InterfaceIndex 5 | Set-NetIPInterface -Dhcp 'Enabled'
{{< /code >}}

Перезапустить интерфейс с именем `Ethernet` для получения параметров от {{< tag "DHCP" >}}:

{{< code "powershell" >}}
Get-NetAdapter -InterfaceIndex 5 | Restart-NetAdapter
{{< /code >}}

## Автоматизация

Скрипт не имеет вводных параметров. Все параметры настраиваются вручную через редактирование скрипта. Далее, скрипт запускается и применяет указанные параметры.

{{< file "pwsh.set.ip.ps1" >}}
