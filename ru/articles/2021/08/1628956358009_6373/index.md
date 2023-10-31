---
title: 'Настройка и использование Git'
description: ''
images:
  - 'https://images.unsplash.com/photo-1556075798-4825dfaaf498'
categories:
  - 'linux'
  - 'git'
  - 'terminal'
  - 'inDev'
tags:
  - 'git'
  - 'linux'
authors:
  - 'KitsuneSolar'
license: 'CC-BY-SA-4.0'
complexity: '1'
toc: 1
comments: 1

date: '2021-08-14T18:52:38+03:00'
hash: 'c35f395f592105eb6fcf1ad812a1a9d93c98602b'
uuid: 'c35f395f-5921-55eb-afcf-1ad812a1a9d9'
slug: 'c35f395f-5921-55eb-afcf-1ad812a1a9d9'

draft: 0
---

В этой заметке я приведу параметры Git, которые сам использую при работе с репозиториями.

<!--more-->

## Первичная настройка

Для начала работы с Git'ом, его необходимо хотя бы минимально настроить.

1. Указать своё имя:

```sh
git config --global user.name "John Doe"
```

2. Указать свой адрес e-mail:

```sh
git config --global user.email "johndoe@example.com"
```

## Настройка подписи

Хорошим тоном будет считаться подпись каждого своего коммита.

1. Выяснить какие ключи установлены в системе (о создании ключей я публиковал заметку {{< uuid "7a204545-daa8-58ce-ba35-75e732e1bcc0" >}}):

```sh
gpg --list-secret-keys --keyid-format=long
```

2. Указать Git'у всегда подписывать каждый коммит:

```sh
git config --global commit.gpgsign true
```

3. Указать Git'у идентификатор ключа для подписи коммита:

```sh
git config --global user.signingkey 3AA5C34371567BD2
```

## Хранилище паролей

Git по умолчанию не сохраняет регистрационные данные для репозиториев. Эта настройка позволяет указать Git'у использовать для хранения регистрационных данных текстовый файл `~/.git-credentials`:

```sh
git config --global credential.helper store
```

## Отмена изменений

Отмена конкретного коммита:

```sh
git revert [commit]
```

Отмена 2-х коммитов подряд:

```sh
git revert HEAD~2
```

## Модули

Добавление модуля:

```sh
git submodule add https://github.com/[MODULE] [MODULE]
```

Рекурсивное обновление всех модулей:

```sh
git submodule update --recursive --remote --merge
```

Удаление модуля:

```sh
git submodule deinit -f [MODULE]  \
  && git rm -r --cached [MODULE]  \
  && rm -rf .git/modules/[MODULE] \
  && rm -rf [MODULE]
```

## Изменение адреса репозитория

Показать текущий адрес:

```sh
git remote -v
```

Установить новый адрес:

```sh
git remote set-url origin '[URL]'
```

## Изменение описания последнего commit'а

Если закралась ошибка в описании изменений кода при последнем commit'е, это описание можно изменить при помощи команды:

```sh
git commit --amend -m 'New commit message.'
```

Далее, изменённый коммит принудительно отправить на сервер:

```sh
git push --force '[remoteName]' '[branchName]'
```

```sh
git push --force 'origin' 'main'
```