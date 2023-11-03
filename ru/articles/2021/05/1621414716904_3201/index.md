---
title: 'Обновление Fedora Linux до актуальной версии'
description: ''
images:
  - 'https://images.unsplash.com/photo-1585406666850-82f7532fdae3'
categories:
  - 'terminal'
  - 'linux'
tags:
  - 'fedora'
  - 'dnf'
  - 'upgrade'
authors:
  - 'KitsuneSolar'
license: 'CC-BY-SA-4.0'
complexity: '0'
toc: 1
comments: 1

date: '2021-05-15T23:29:16+03:00'

type: 'articles'
hash: '0acd3f9d07b732b85facb5cb1cc579e08703392f'
uuid: '0acd3f9d-07b7-52b8-9fac-b5cb1cc579e0'
slug: '0acd3f9d-07b7-52b8-9fac-b5cb1cc579e0'

draft: 0
---

Новые версии Fedora публикуются каждые 6-8 месяцев. В этой статье я опишу шаги по обновлению дистрибутива между версиями.

<!--more-->

1. Устанавливаем плагин обновления системы:

```terminal {os="linux", mode="root"}
dnf install dnf-plugin-system-upgrade
```

2. Скачивание актуальной версии системы:

```terminal {os="linux", mode="root"}
dnf system-upgrade download --releasever=34
```

- `releasever` - номер актуальной версии системы.

3. Запуск обновления системы на актуальную версию:

```terminal {os="linux", mode="root"}
dnf system-upgrade reboot
```

Вот и всё. Система обновит пакетную базу и перезагрузится.
