---
# -------------------------------------------------------------------------------------------------------------------- #
# General settings.
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
complexity: '0'
toc: 1
comments: 1

# -------------------------------------------------------------------------------------------------------------------- #
# Date settings.
# -------------------------------------------------------------------------------------------------------------------- #

date: '2024-03-08T13:29:06+03:00'
publishDate: '2024-03-08T13:29:06+03:00'
expiryDate: ''
lastMod: '2024-03-08T13:29:06+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# Meta settings.
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '6c7a038ff41e0a453285b99fdacf82d4c66dbbd1'
uuid: '6c7a038f-f41e-5a45-a285-b99fdacf82d4'
slug: '6c7a038f-f41e-5a45-a285-b99fdacf82d4'

draft: 1
---



<!--more-->

## RAID

### Stripe (RAID0)

{{< code >}}
zpool create -f <pool_name> <dev_0> <dev_1>
{{< /code >}}

### Mirror (RAID1)

{{< code >}}
zpool create -f <pool_name> mirror <dev_0> <dev_1>
{{< /code >}}

### RAIDZ-1 (RAID5)

{{< code >}}
zpool create -f <pool_name> raidz <dev_0> <dev_1> <dev_2>
{{< /code >}}

### RAIDZ-2 (RAID6)

{{< code >}}
zpool create -f <pool_name> raidz2 <dev_0> <dev_1> <dev_2> <dev_3>
{{< /code >}}

### RAIDZ-3

{{< code >}}
zpool create -f <pool_name> raidz3 <dev_0> <dev_1> <dev_2> <dev_3> <dev_4>
{{< /code >}}

### RAID10

{{< code >}}
zpool create -f <pool_name> mirror <dev_0> <dev_1> mirror <dev_2> <dev_3>
{{< /code >}}

## Cache / Log

### Cache

{{< code >}}
zpool add -f <pool_name> cache <dev_0>
{{< /code >}}

### Log

{{< code >}}
zpool add -f <pool_name> log <dev_0>
{{< /code >}}

## Status

{{< code >}}
zpool status -v <pool_name>
{{< /code >}}

## List

{{< code >}}
zpool list
{{< /code >}}

{{< code >}}
zfs list
{{< /code >}}

## Destroy


{{< code >}}
zpool destroy -f <pool_name>
{{< /code >}}
