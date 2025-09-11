```
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
