---
# -------------------------------------------------------------------------------------------------------------------- #
# General settings.
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Создание расширяемого хранилища LVM'
description: ''
images:
  - 'https://images.unsplash.com/photo-1585776245991-cf89dd7fc73a'
categories:
  - 'linux'
  - 'terminal'
  - 'cat_03'
tags:
  - 'tag_01'
  - 'tag_02'
  - 'tag_03'
authors:
  - 'KaiKimera'
sources:
  - ''
license: 'CC-BY-SA-4.0'
complexity: '0'
toc: 1
comments: 1

# -------------------------------------------------------------------------------------------------------------------- #
# Date settings.
# -------------------------------------------------------------------------------------------------------------------- #

date: '2024-06-03T18:24:00+03:00'
publishDate: '2024-06-03T18:24:00+03:00'
expiryDate: ''
lastMod: '2024-06-03T18:24:00+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# Meta settings.
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '2b75198c776c6ed94037976c6d3021f9dcadad1d'
uuid: '2b75198c-776c-5ed9-9037-976c6d3021f9'
slug: '2b75198c-776c-5ed9-9037-976c6d3021f9'

draft: 1
---



<!--more-->

## Создание LVM

```bash
pv='/dev/sdb'; vg='data'; lv='storage'; pvcreate "${pv}" && vgcreate "${vg}" "${pv}" && lvcreate -l 100%FREE -n "${lv}" "${vg}";
```

Где:
- `pv='/dev/sdb'` - диск, который будет использоваться в качестве физического тома для LVM.
- `vg='data'` - имя группы томов (VG).
- `lv='storage'` - имя логического тома (LV).

```bash
mkfs.ext4 "/dev/${vg}/${lv}"
```

```bash
mkdir '/home/storage' && echo "/dev/${vg}/${lv} /home/storage ext4 defaults 0 0" >> '/etc/fstab';
```

## Расширение LVM

```bash
pv='/dev/sdb'; ext='/dev/sdc'; vg='data'; lv='storage'; pvresize "${pv}" && vgextend "${vg}" "${ext}" && lvextend -l 100%FREE "/dev/${vg}/${lv}";
```

Где:
- `pv='/dev/sdb'` - диск, который нужно расширить.
- `ext='/dev/sdc'` - дополнительный диск для расширения.
- `vg='data'` - имя группы томов (VG).
- `lv='storage'` - имя логического тома (LV).

### EXT4

```bash
resize2fs "/dev/${vg}/${lv}"
```

### XFS

```bash
xfs_growfs "/dev/${vg}/${lv}"
```

## Удаление LVM

```bash
pv='/dev/sdb'; vg='data'; lv='storage'; lvremove "/dev/${vg}/${lv}" && vgremove "${vg}" && pvremove "${pv}";
```

Где:
- `pv='/dev/sdb'` - диск, который будет использоваться в качестве физического тома для LVM.
- `vg='data'` - имя группы томов (VG).
- `lv='storage'` - имя логического тома (LV).

## Информация по LVM

```bash
pvdisplay
```

```bash
vgdisplay
```

```bash
lvdisplay
```
