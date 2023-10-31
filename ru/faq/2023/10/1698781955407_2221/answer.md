---
title: '12121'
---
При вводе команды, необходимо добавить к `Format-Table` параметр `-AutoSize`. Тогда PowerShell будет подстраивать ширину столбца под размер содержимого.

```terminal {os=windows}
Get-Service -DisplayName 'win*' | Format-Table -AutoSize

Status  Name                  DisplayName
------  ----                  -----------
Running AudioEndpointBuilder  Windows Audio Endpoint Builder
Running Audiosrv              Windows Audio
Running EventLog              Windows Event Log
Running FontCache             Windows Font Cache Service
Stopped FrameServer           Windows Camera Frame Server
Stopped FrameServerMonitor    Windows Camera Frame Server Monitor
Stopped icssvc                Windows Mobile Hotspot Service
Running LicenseManager        Windows License Manager Service
Stopped MixedRealityOpenXRSvc Windows Mixed Reality OpenXR Service
Running mpssvc                Windows Defender Firewall
Stopped msiserver             Windows Installer
Stopped perceptionsimulation  Windows Perception Simulation Service
Stopped PushToInstall         Windows PushToInstall Service
Stopped SDRSVC                Windows Backup
Running SecurityHealthService Windows Security Service
```
