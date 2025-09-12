Программа установки Proxmox на момент публикации инструкции не поддерживает конфигурирование VLAN. Но после установки можно добавить поддержку vlan в файле `/etc/network/interfaces`. Для этого необходимо:

- Открыть `/etc/network/interfaces`.
- Создать интерфейс `vmbr0.5`, где `5` - номер VLAN.
- Перенести в `vmbr0.5` настройки IP-адреса из `vmbr0`.
- В `vmbr0` добавить параметры `bridge-vlan-aware yes` и `bridge-vids 2-4094`, где `2-4094` - перечень поддерживаемых VLAN.

Всё. Поддержка vlan-ов для интерфейса конфигурации Proxmox включена.

## Пример конфигурации

```text {hl_lines=["11-12","14-17"]}
auto lo
iface lo inet loopback

iface eno1 inet manual

auto vmbr0
iface vmbr0 inet manual
  bridge-ports eno1
  bridge-stp off
  bridge-fd 0
  bridge-vlan-aware yes
  bridge-vids 2-4094

auto vmbr0.5
iface vmbr0.5 inet static
  address 192.168.1.2/24
  gateway 192.168.1.1
```
