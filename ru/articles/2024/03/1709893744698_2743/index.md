---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Работа с ZFS'
description: ''
images:
  - 'https://images.unsplash.com/photo-1461360228754-6e81c478b882'
categories:
  - 'bsd'
  - 'linux'
  - 'inDev'
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
lastMod: '2024-03-08T13:29:06+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '6c7a038ff41e0a453285b99fdacf82d4c66dbbd1'
uuid: '6c7a038f-f41e-5a45-a285-b99fdacf82d4'
slug: '6c7a038f-f41e-5a45-a285-b99fdacf82d4'

draft: 0
---

Я всё чаще стал использовать файловую систему {{< tag "ZFS" >}} и для себя составил шпаргалку по работе с ней. Может быть, кому то ещё пригодится.

<!--more-->

## Вводные данные

В работе с {{< tag "ZFS" >}} я использую ОС {{< tag "Debian" >}} и пути к дискам (`by-path`). Если кто-то захочет использовать идентификаторы (`by-id`) дисков, то просто замените в командах пути на идентификаторы. В командах этой статьи я работаю в пулом под названием `data`.

### Список дисков и их расположение

Вывести список дисков и их расположение (путь) в системе:

```bash
ls -l '/dev/disk/by-path/'
```

### Список дисков и их идентификаторы

Вывести список дисков и их идентификаторы в системе:

```bash
ls -l '/dev/disk/by-id/'
```

## Пулы

Рассмотрим различные варианты работы с пулами {{< tag "ZFS" >}}.

### Создание пула

- Создать обычный пул `data` из одного диска `pci-0000:01:00.0-scsi-0:1:0:0`:

```bash
zpool create -o 'ashift=12' -O 'atime=off' 'data' 'pci-0000:01:00.0-scsi-0:1:0:0'
```

### Расширение пула

Расширение пула происходит путём добавления дополнительного диска или увеличением размера виртуального диска.

#### Добавление диска в пул

- Добавить диск `pci-0000:01:00.0-scsi-0:1:1:0` в пул `data`:

```bash
zpool add 'data' 'pci-0000:01:00.0-scsi-0:1:1:0'
```

#### Расширение диска в пуле

- Обновить информацию об устройстве `sdb`, расширить существующий диск `sdb` и пул `data`:

```bash
echo 1 > '/sys/block/sdb/device/rescan' && partprobe && zpool online -e 'data' 'sdb'
```

{{< alert "tip" >}}
При необходимости можно включить автоматическое расширение пула `data`:

```bash
zpool set 'autoexpand=on' 'data'
```
{{< /alert >}}

### Подключение и отключение дисков

Подключение и отключение дисков осуществляются командами `attach` и `detach`, соответственно.

#### Подключение второго диска (для создания зеркала)

- Подключить новый диск `pci-0000:03:00.0-scsi-0:1:1:0` к существующему диску `pci-0000:03:00.0-scsi-0:1:0:0` в пуле `data` для создания зеркала:

```bash
zpool attach 'data' 'pci-0000:03:00.0-scsi-0:1:0:0' 'pci-0000:03:00.0-scsi-0:1:1:0'
```

#### Отключение второго диска

- Отключить диск `pci-0000:03:00.0-scsi-0:1:1:0` в пуле `data`:

```bash
zpool detach 'data' 'pci-0000:03:00.0-scsi-0:1:1:0'
```

### Импортирование пула

- Импортировать пул `data`, состоящий из дисков `pci-0000:01:00.0-scsi-0:1:0:0` и `pci-0000:01:00.0-scsi-0:1:1:0`:

```bash
zpool import -d 'pci-0000:01:00.0-scsi-0:1:0:0' -d 'pci-0000:01:00.0-scsi-0:1:1:0' 'data'
```

- ...или можно разрешить {{< tag "ZFS" >}} автоматически поискать диски пула `data`:

```bash
zpool import -d '/dev/disk/by-path/' 'data'
```

### Переименования пула

- Экспортировать пул `data`:

```bash
zpool export 'data'
```

- Импортировать пул `data` с новым именем:

```bash
zpool import 'data' 'data_NEW'
```

### Обновление пула

- Проверить необходимость обновления пула `data`:

```bash
zpool status -v
```

- При появлении надписи `status: Some supported features are not enabled on the pool...` запустить обновление пула `data`:

```bash
zpool upgrade 'data'
```

- ...или обновить сразу все пулы:

```bash
zpool upgrade -a
```

### Удаление пула

- Удалить пул `data`:

```bash
zpool destroy 'data'
```

### Список пулов

Вывести список всех пулов в системе:

```bash
zpool list
```

### Статус пула

- Проверить статус пула `data`:

```bash
zpool status -v 'data'
```

### Работа с RAID

Рассмотрим команды создания пула {{< tag "ZFS" >}} из нескольких дисков.

#### Stripe (RAID0)

- Создать **RAID-0** из дисков `pci-0000:01:00.0-scsi-0:1:0:0` и `pci-0000:01:00.0-scsi-0:1:1:0`:

```bash
zpool create -o 'ashift=12' -O 'atime=off' 'data' 'pci-0000:01:00.0-scsi-0:1:0:0' 'pci-0000:01:00.0-scsi-0:1:1:0'
```

#### Mirror (RAID1)

- Создать зеркало (**RAID-1**) из дисков `pci-0000:01:00.0-scsi-0:1:0:0` и `pci-0000:01:00.0-scsi-0:1:1:0`:

```bash
zpool create -o 'ashift=12' -O 'atime=off' 'data' mirror 'pci-0000:01:00.0-scsi-0:1:0:0' 'pci-0000:01:00.0-scsi-0:1:1:0'
```

#### RAID10

- Создать **RAID-10** из дисков `pci-0000:01:00.0-scsi-0:1:0:0`, `pci-0000:01:00.0-scsi-0:1:1:0`, `pci-0000:01:00.0-scsi-0:1:2:0` и `pci-0000:01:00.0-scsi-0:1:3:0`:

```bash
zpool create -o 'ashift=12' -O 'atime=off' 'data' mirror 'pci-0000:01:00.0-scsi-0:1:0:0' 'pci-0000:01:00.0-scsi-0:1:1:0' mirror 'pci-0000:01:00.0-scsi-0:1:2:0' 'pci-0000:01:00.0-scsi-0:1:3:0'
```

#### RAIDZ-1 (RAID5)

- Создать **RAID-5** из дисков `pci-0000:01:00.0-scsi-0:1:0:0`, `pci-0000:01:00.0-scsi-0:1:1:0` и `pci-0000:01:00.0-scsi-0:1:2:0`:

```bash
zpool create -o 'ashift=12' -O 'atime=off' 'data' raidz 'pci-0000:01:00.0-scsi-0:1:0:0' 'pci-0000:01:00.0-scsi-0:1:1:0' 'pci-0000:01:00.0-scsi-0:1:2:0'
```

#### RAIDZ-2 (RAID6)

- Создать **RAID-6** из дисков `pci-0000:01:00.0-scsi-0:1:0:0`, `pci-0000:01:00.0-scsi-0:1:1:0`, `pci-0000:01:00.0-scsi-0:1:2:0` и `pci-0000:01:00.0-scsi-0:1:3:0`

```bash
zpool create -o 'ashift=12' -O 'atime=off' 'data' raidz2 'pci-0000:01:00.0-scsi-0:1:0:0' 'pci-0000:01:00.0-scsi-0:1:1:0' 'pci-0000:01:00.0-scsi-0:1:2:0' 'pci-0000:01:00.0-scsi-0:1:3:0'
```

#### RAIDZ-3

- Создать **RAIDZ-3** из дисков `pci-0000:01:00.0-scsi-0:1:0:0`, `pci-0000:01:00.0-scsi-0:1:1:0`, `pci-0000:01:00.0-scsi-0:1:2:0`, `pci-0000:01:00.0-scsi-0:1:3:0` и `pci-0000:01:00.0-scsi-0:1:4:0`:

```bash
zpool create -o 'ashift=12' -O 'atime=off' 'data' raidz3 'pci-0000:01:00.0-scsi-0:1:0:0' 'pci-0000:01:00.0-scsi-0:1:1:0' 'pci-0000:01:00.0-scsi-0:1:2:0' 'pci-0000:01:00.0-scsi-0:1:3:0' 'pci-0000:01:00.0-scsi-0:1:4:0'
```

### Работа с ARC и ZIL

Добавляем отдельные устройства для работы с **ARC** и **ZIL**.

#### ARC

- Добавить отдельный диск (**L2ARC**) `pci-0000:01:00.0-scsi-0:1:4:0` для работы с **ARC** в пул `data`:

```bash
zpool add 'data' cache 'pci-0000:01:00.0-scsi-0:1:4:0'
```

#### ZIL

- Добавить отдельный диск (**SLOG**) `pci-0000:01:00.0-scsi-0:1:5:0` для работы с **ZIL**  в пул `data`:

```bash
zpool add 'data' log 'pci-0000:01:00.0-scsi-0:1:5:0'
```

## Тома

### Создание тома

- Создать том `cloud` в пуле `data`:

```bash
zfs create 'data/cloud'
```

- Создать том `cloud` в пуле `data` и с точкой монтирования `/opt/cloud`:

```bash
zfs create -o 'mountpoint=/opt/cloud' 'data/cloud'
```

- Создать том `cloud` в пуле `data` и с алгоритмом компрессии `zstd`:

```bash
zfs create -o 'compression=zstd' 'data/cloud'
```

- Создать том `cloud` в пуле `data` с алгоритмом компрессии `zstd` и точкой монтирования `/opt/cloud`:

```bash
zfs create -o 'compression=zstd' -o 'mountpoint=/opt/cloud' 'data/cloud'
```

### Удаление тома

- Удалить том `cloud` в пуле `data`:

```bash
zfs destroy 'data/cloud'
```

### Создание зашифрованного тома

- Создать том `secret` в пуле `data` и зашифровать его парольной фразой:

```bash
zfs create -o 'encryption=on' -o 'keyformat=passphrase' 'data/secret'
```

Где:

- `encryption=on` - включение шифрования.
- `keyformat=passphrase` - тип шифрования "парольная фраза".

{{< alert "tip" >}}
При создании тома `secret` ZFS попросит ввести парольную фразу для шифрования данных.
{{< /alert >}}

## Снимки

### Список снимков

- Показать список всех снимков:

```bash
zfs list -t 'snapshot'
```

- Показать список снимков тома `cloud` в пуле `data`:

```bash
zfs list -r -t 'snapshot' -o 'name,creation' 'data/cloud'
```

### Создание снимков

- Создать снимок `2024-08-21.19-32-02` тома `cloud` в пуле `data`:

```bash
zfs snapshot "data/cloud@$( date '+%F.%H-%M-%S' )"
```

- Создать снимок `2024-08-21.19-32-02` тома `cloud` и всех его дочерних томов в пуле `data`:

```bash
zfs snapshot -r "data/cloud@$( date '+%F.%H-%M-%S' )"
```

### Переименование снимков

- Переименовать снимок `name_OLD` тома `cloud` в пуле `data`:

```bash
zfs rename 'data/cloud@name_OLD' 'name_NEW'
```

- Переименовать снимок `name_OLD` тома `cloud` и во всех его дочерних томов в пуле `data`:

```bash
zfs rename -r 'data/cloud@name_OLD' 'name_NEW'
```

### Откат данных к снимку

- Выполнить откат данных к снимку `2024-08-21.19-32-02` тома `cloud` в пуле `data`:

```bash
zfs rollback 'data/cloud@2024-08-21.19-32-02'
```

### Удаление снимков

- Удалить снимок `2024-08-21.19-32-02` тома `cloud` в пуле `data`:

```bash
zfs destroy 'data/cloud@2024-08-21.19-32-02'
```

## Оптимизации

Специализированные настройки {{< tag "ZFS" >}} под конкретные задачи.

### PostgreSQL

- Создать основной том `pgsql` с алгоритмом компрессии `zstd`:

```bash
zfs create -o 'compression=zstd' 'data/pgsql'
```

- Создать специальный том `pgsql/main` с алгоритмом компрессии `zstd` и размером блока `32K` для баз данных:

```bash
zfs create -o 'recordsize=32K' 'data/pgsql/main' && chmod 700 '/data/pgsql/main'
```

- Создать специальный том `pgsql/wal` с алгоритмом компрессии `zstd` и размером блока `32K` для WAL:

```bash
zfs create -o 'recordsize=32K' 'data/pgsql/wal'
```

- Откорректировать настройки {{< tag "PostgreSQL" >}}:

```ini
data_directory = '/data/pgsql/main'
full_page_writes = off
wal_init_zero = off
wal_recycle = off
```

### MySQL

- Создать основной том `mysql` с алгоритмом компрессии `zstd`:

```bash
zfs create -o 'compression=zstd' 'data/mysql'
```

- Создать специальный том `mysql/main` с алгоритмом компрессии `zstd` и размером блока `16K` для баз данных:

```bash
zfs create -o 'recordsize=16K' 'data/mysql/main'
```

- Создать специальный том `mysql/log` с алгоритмом компрессии `zstd` для логирования:

```bash
zfs create 'data/mysql/log'
```

- Откорректировать настройки {{< tag "MySQL" >}}:

```ini
datadir = 'data/mysql/main'
innodb_doublewrite = 0
innodb_use_native_aio = 0
innodb_use_atomic_writes = 0
```
