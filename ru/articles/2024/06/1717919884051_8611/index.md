---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Обновление FreeBSD до актуальной версии'
description: ''
images:
  - 'https://images.unsplash.com/photo-1585776245991-cf89dd7fc73a'
categories:
  - 'bsd'
tags:
  - 'freebsd'
  - 'freebsd-update'
  - 'pkg'
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

date: '2024-06-09T10:58:05+03:00'
publishDate: '2024-06-09T10:58:05+03:00'
lastMod: '2024-06-09T10:58:05+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '61ba571a7e1042fab064d91a8e4f6daadaf19af6'
uuid: '61ba571a-7e10-52fa-9064-d91a8e4f6daa'
slug: '61ba571a-7e10-52fa-9064-d91a8e4f6daa'

draft: 1
---

Этапы обновления FreeBSD на новую версию.

<!--more-->

## План обновления

1. Запросить информация о новой версии FreeBSD:

```bash
freebsd-update fetch && freebsd-update install
```

2. Перевести систему на новую версию (`14.1`) и перезагрузить:

```bash
freebsd-update upgrade -r 14.1-RELEASE && freebsd-update install && shutdown -r now
```

3. Установить новые компоненты пользовательского пространства и удалить старые системные библиотеки:

```bash
freebsd-update install; freebsd-update install && shutdown -r now
```

## Автоматизация

### Первый этап обновления

```bash
v='14.1-RELEASE'; freebsd-update fetch && freebsd-update install; freebsd-update upgrade -r "${v}" && freebsd-update install && shutdown -r now
```

Где:
- `14.1-RELEASE` - новая версия FreeBSD.

### Второй этап обновления

```bash
freebsd-update install && freebsd-update install; pkg update -f && pkg upgrade --yes && shutdown -r now
```
