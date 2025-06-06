---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Расширение ROOT-раздела на LVM'
description: ''
images:
  - 'https://images.unsplash.com/photo-1704265586128-7fc54dcc774f'
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
  - 'parted'
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

draft: 0
---

Иногда требуется увеличение корневого раздела {{< tag "Linux" >}} в LVM-конфигурации. Рассмотрим, как это можно сделать без остановки виртуальной машины...

<!--more-->

## Исходные данные

Имеется виртуальная машина с диском `sda` размером `20 GB`:

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

Увеличиваем размер виртуального диска `sda` на `10 GB`:

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
export PV='/dev/sda3'; export VG='system'; export LV='root'
```

### Параметры

- `PV='/dev/sda3'` - раздел на диске, который будет использоваться в качестве физического тома для LVM.
- `VG='system'` - имя группы томов (VG).
- `LV='root'` - имя логического тома (LV).

## Расширение LVM

{{< alert "tip" >}}
При увеличении размера `sda`, утилита `parted` может показать ошибку `Unable to satisfy all constraints on the partition`. Эта ошибка является следствием того, что при увеличении размера виртуального диска, таблица разделов (GPT) больше не записывается в правильном месте на диске. В следующей команде применён флаг `-f` (`--fix`) для исправления ошибки. При помощи этого флага, утилита `parted` исправляет таблицу разделов диска.

Если утилита `parted`, установленная в системе, не имеет флага `-f` (`--fix`), то необходимо отдельно запустить утилиту `parted`, исправить таблицу разделов и расширить раздел самостоятельно.
{{< /alert >}}

Увеличение раздела `root` при помощи одной команды:

```bash
echo 1 > "/sys/block/$( echo "${PV##*/}" | sed 's/[0-9]*//g' )/device/rescan" && parted -sf -a 'optimal' "${PV//[0-9]/}" "resizepart ${PV//[^0-9]/} 100%" && pvresize "${PV}" && lvextend -l +100%FREE "/dev/${VG}/${LV}"
```

В этой команде имеется 4 под-команды:
- `rescan` - обновить информацию об устройстве `sda`.
- `parted` - расширить раздел `sda3` на всё свободное место.
- `pvresize` - расширить физический том **PV**.
- `lvextend` - расширить логический том **LV**.

### Расширение ФС

Расширить файловую систему **EXT4**:

```bash
resize2fs "/dev/${VG}/${LV}"
```

Расширить файловую систему **XFS**:

```bash
xfs_growfs -d "/dev/${VG}/${LV}"
```

## Итоговые значения

В итоге, имеем увеличение раздела `sda3/system-root` на всё свободное место:

```terminal
lsblk
NAME            MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sda               8:0    0   30G  0 disk
├─sda1            8:1    0    1M  0 part
├─sda2            8:2    0  1.9G  0 part /boot
└─sda3            8:3    0 28.1G  0 part
  ├─system-swap 254:0    0  3.8G  0 lvm  [SWAP]
  └─system-root 254:1    0 24.3G  0 lvm  /
```
