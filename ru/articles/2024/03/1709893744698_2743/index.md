---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Работа с ZFS'
description: ''
images:
  - 'https://images.unsplash.com/photo-1585776245991-cf89dd7fc73a'
categories:
  - 'bsd'
  - 'linux'
tags:
  - 'freebsd'
  - 'linux'
  - 'fs'
  - 'zfs'
authors:
  - 'KaiKimera'
sources:
  - ''
license: 'CC-BY-SA-4.0'
complexity: '1'
toc: 1
comments: 1

# -------------------------------------------------------------------------------------------------------------------- #
# DATE
# -------------------------------------------------------------------------------------------------------------------- #

date: '2024-03-08T13:29:06+03:00'
publishDate: '2024-03-08T13:29:06+03:00'
expiryDate: ''
lastMod: '2024-03-08T13:29:06+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '6c7a038ff41e0a453285b99fdacf82d4c66dbbd1'
uuid: '6c7a038f-f41e-5a45-a285-b99fdacf82d4'
slug: '6c7a038f-f41e-5a45-a285-b99fdacf82d4'

draft: 1
---



<!--more-->

```bash
ls -l '/dev/disk/by-path/'
```

## Пулы

### RAID

#### Stripe (RAID0)

```bash
p='data'; zpool create -o ashift=12 -O atime=off "${p}" 'pci-0000:01:00.0-scsi-0:1:0:0' 'pci-0000:01:00.0-scsi-0:1:1:0'
```

#### Mirror (RAID1)

```bash
p='data'; zpool create -o ashift=12 -O atime=off "${p}" mirror 'pci-0000:01:00.0-scsi-0:1:0:0' 'pci-0000:01:00.0-scsi-0:1:1:0'
```

#### RAIDZ-1 (RAID5)

```bash
p='data'; zpool create -o ashift=12 -O atime=off "${p}" raidz 'pci-0000:01:00.0-scsi-0:1:0:0' 'pci-0000:01:00.0-scsi-0:1:1:0' 'pci-0000:01:00.0-scsi-0:1:2:0'
```

#### RAIDZ-2 (RAID6)

```bash
p='data'; zpool create -o ashift=12 -O atime=off "${p}" raidz2 'pci-0000:01:00.0-scsi-0:1:0:0' 'pci-0000:01:00.0-scsi-0:1:1:0' 'pci-0000:01:00.0-scsi-0:1:2:0' 'pci-0000:01:00.0-scsi-0:1:3:0'
```

#### RAIDZ-3

```bash
p='data'; zpool create -o ashift=12 -O atime=off "${p}" raidz3 'pci-0000:01:00.0-scsi-0:1:0:0' 'pci-0000:01:00.0-scsi-0:1:1:0' 'pci-0000:01:00.0-scsi-0:1:2:0' 'pci-0000:01:00.0-scsi-0:1:3:0' 'pci-0000:01:00.0-scsi-0:1:4:0'
```

#### RAID10

```bash
p='data'; zpool create -o ashift=12 -O atime=off "${p}" mirror 'pci-0000:01:00.0-scsi-0:1:0:0' 'pci-0000:01:00.0-scsi-0:1:1:0' mirror 'pci-0000:01:00.0-scsi-0:1:2:0' 'pci-0000:01:00.0-scsi-0:1:3:0'
```

### Cache / Log

#### Cache

```bash
p='data'; zpool add "${p}" cache 'pci-0000:01:00.0-scsi-0:1:0:0'
```

#### Log

```bash
p='data'; zpool add "${p}" log 'pci-0000:01:00.0-scsi-0:1:0:0'
```

### Status

```bash
p='data'; zpool status -v "${p}"
```

### List

```bash
zpool list
```

### Destroy

```bash
p='data'; zpool destroy "${p}"
```

## Тома

```bash
p='data'; v='cloud'; zfs create "${p}/${v}"
```
