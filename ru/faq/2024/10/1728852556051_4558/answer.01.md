Включить параметр **Check Gateway** для маршрута, полученного по DHCP от провайдера, невозможно. Эта настройка попросту неактивна. Но Mikrotik можно "обмануть", использовав следующий скрипт в секции DHCP Client / *Interface_Name* / Advanced / Script:

```text
:if ($bound=1) do={ /ip route set [find where dst-address="0.0.0.0/0" and distance=1] check-gateway=ping }
```
