---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Расширение ROOT-раздела на LVM'
description: ''
images:
  - 'https://images.unsplash.com/photo-1585776245991-cf89dd7fc73a'
categories:
  - 'linux'
  - 'terminal'
tags:
  - 'lvm'
  - 'pv'
  - 'vg'
  - 'lv'
  - 'resize2fs'
  - 'xfs_growfs'
  - 'growpart'
authors:
  - 'KaiKimera'
sources:
  - ''
license: 'CC-BY-SA-4.0'
complexity: '0'
toc: 1
comments: 1

# -------------------------------------------------------------------------------------------------------------------- #
# DATE
# -------------------------------------------------------------------------------------------------------------------- #

date: '2025-02-03T18:03:28+03:00'
publishDate: '2025-02-03T18:03:28+03:00'
lastMod: '2025-02-03T18:03:28+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '379496b3e2c3760d57cd5d59640d5950a98e498c'
uuid: '379496b3-e2c3-560d-a7cd-5d59640d5950'
slug: '379496b3-e2c3-560d-a7cd-5d59640d5950'

draft: 1
---



<!--more-->

```terminal
lsblk
NAME            MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sda               8:0    0   20G  0 disk
├─sda1            8:1    0    1M  0 part
├─sda2            8:2    0  1.9G  0 part /boot
└─sda3            8:3    0 18.1G  0 part
  ├─system-swap 254:0    0  3.8G  0 lvm  [SWAP]
  └─system-root 254:1    0 14.3G  0 lvm  /
```

```terminal
lsblk
NAME            MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sda               8:0    0   30G  0 disk
├─sda1            8:1    0    1M  0 part
├─sda2            8:2    0  1.9G  0 part /boot
└─sda3            8:3    0 18.1G  0 part
  ├─system-swap 254:0    0  3.8G  0 lvm  [SWAP]
  └─system-root 254:1    0 14.3G  0 lvm  /
```

## Экспорт параметров

Для начала экспортируем заранее подготовленные параметры в переменные окружения:

```bash
export PV='/dev/sda3'; export VG='system'; export LV='root';
```

Где:
- `PV='/dev/sda3'` - диск, который будет использоваться в качестве физического тома для LVM.
- `VG='system'` - имя группы томов (VG).
- `LV='root'` - имя логического тома (LV).

## Расширение LVM

Увеличение раздела `root` при помощи одной команды:

```bash
echo 1 > "/sys/block/$( echo "${PV##*/}" | sed 's/[0-9]*//g' )/device/rescan" && parted -s -a 'optimal' "${PV//[0-9]/}" "resizepart ${PV//[^0-9]/} 100%" && pvresize "${PV}" && lvextend -l +100%FREE "/dev/${VG}/${LV}"
```

### Расширение ФС

Расширить файловую систему **EXT4**:

```bash
resize2fs "/dev/${VG}/${LV}"
```

Расширить файловую систему **XFS**:

```bash
xfs_growfs -d "/dev/${VG}/${LV}"
```
