---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Linux: Пользователи и группы'
description: ''
images:
  - 'https://images.unsplash.com/photo-1580780965002-6ca357516eb1'
categories:
  - 'linux'
  - 'terminal'
tags:
  - 'linux'
  - 'adduser'
  - 'usermod'
  - 'userdel'
  - 'lock'
  - 'unlock'
  - 'groupmod'
  - 'useradd'
  - 'gpasswd'
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

date: '2024-06-03T13:59:22+03:00'
publishDate: '2024-06-03T13:59:22+03:00'
lastMod: '2024-06-03T13:59:22+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: 'b29b331dac934193f3efbeab5a0f8dff02540b2d'
uuid: 'b29b331d-ac93-5193-83ef-beab5a0f8dff'
slug: 'b29b331d-ac93-5193-83ef-beab5a0f8dff'

draft: 0
---

Набор команд для работы с группами и пользователями в {{< tag "Linux" >}}.

<!--more-->

В отличие от {{< tag "FreeBSD" >}}, в {{< tag "Linux" >}} можно пользоваться стандартными инструментами `useradd`, `usermod` и `userdel`.

## Создать пользователя

- Создать пользователя `username`, добавить его в группу `sudo`, указать комментарий `User username` и задать пароль:

```bash
u='username'; useradd -m -G sudo -c "User ${u}" "${u}" && passwd "${u}"
```

## Переименовать пользователя

- Переименовать домашнюю директорию пользователя, переименовать пользователя и его группу:

```bash
u_old='username_old'; u_new='username_new'; usermod -l "${u_new}" -d "/home/${u_new}" -m "${u_old}" && groupmod -n "${u_new}" "${u_old}"
```

## Удалить пользователя

- Удалить пользователя `username` и его домашнюю директорию (`-r`):

```bash
u='username'; userdel -r "${u}"
```

## Заблокировать пользователя

- Заблокировать пользователя `username`:

```bash
u='username'; usermod -L "${u}"
```

## Разблокировать пользователя

- Разблокировать пользователя `username`:

```bash
u='username'; usermod -U "${u}"
```

## Добавить пользователя в дополнительную группу

- Добавить пользователя `username` в группу `www`:

```bash
u='username'; usermod -aG www "${u}"
```

## Удалить пользователя из дополнительной группы

- Удалить пользователя `username` из группы `www`:

```bash
u='username'; gpasswd -d "${u}" www
```

## Изменить основную группу пользователя

- Изменить основную группу пользователя `username` на группу `www`:

```bash
u='username'; usermod -g www "${u}"
```

## Заменить у пользователя дополнительные группы

- Заменить у пользователя `username` все дополнительные группы на группу `www`:

```bash
u='username'; usermod -G www "${u}"
```
