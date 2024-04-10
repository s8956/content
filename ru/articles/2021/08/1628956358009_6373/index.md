---
# -------------------------------------------------------------------------------------------------------------------- #
# General settings.
# -------------------------------------------------------------------------------------------------------------------- #

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
authors:
  - 'KaiKimera'
license: 'CC-BY-SA-4.0'
complexity: '1'
toc: 1
comments: 1

# -------------------------------------------------------------------------------------------------------------------- #
# Date settings.
# -------------------------------------------------------------------------------------------------------------------- #

date: '2021-08-14T18:52:38+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# Meta settings.
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: 'c35f395f592105eb6fcf1ad812a1a9d93c98602b'
uuid: 'c35f395f-5921-55eb-afcf-1ad812a1a9d9'
slug: 'c35f395f-5921-55eb-afcf-1ad812a1a9d9'

draft: 0
---

В этой заметке я приведу параметры {{< tag "Git" >}}, которые сам использую при работе с репозиториями.

<!--more-->

## Первичная настройка

Для начала работы с {{< tag "Git" >}}'ом, его необходимо хотя бы минимально настроить.

1. Указать своё имя:

{{< code "sh" >}}
git config --global user.name "John Doe"
{{< /code >}}

2. Указать свой адрес e-mail:

{{< code "sh" >}}
git config --global user.email "johndoe@example.com"
{{< /code >}}

## Настройка подписи

Хорошим тоном будет считаться подпись каждого своего commit'а.

1. Выяснить какие ключи установлены в системе (о создании ключей я публиковал заметку {{< uuid "7a204545-daa8-58ce-ba35-75e732e1bcc0" >}}):

{{< code "sh" >}}
gpg --list-secret-keys --keyid-format=long
{{< /code >}}

2. Указать {{< tag "Git" >}}'у всегда подписывать каждый commit:

{{< code "sh" >}}
git config --global commit.gpgsign true
{{< /code >}}

3. Указать {{< tag "Git" >}}'у идентификатор ключа для подписи commit'а:

{{< code "sh" >}}
git config --global user.signingkey 3AA5C34371567BD2
{{< /code >}}

## Хранилище паролей

{{< tag "Git" >}} по умолчанию не сохраняет регистрационные данные для репозиториев. Эта настройка позволяет указать {{< tag "Git" >}}'у использовать для хранения регистрационных данных текстовый файл `~/.git-credentials`:

{{< code "sh" >}}
git config --global credential.helper store
{{< /code >}}

## Отмена изменений

Отмена конкретного commit'а:

{{< code "sh" >}}
git revert [commit]
{{< /code >}}

Отмена 2-х commit'ов подряд:

{{< code "sh" >}}
git revert HEAD~2
{{< /code >}}

## Модули

Добавление модуля:

{{< code "sh" >}}
git submodule add https://github.com/[MODULE] [MODULE]
{{< /code >}}

Рекурсивное обновление всех модулей:

{{< code "sh" >}}
git submodule update --recursive --remote --merge
{{< /code >}}

Удаление модуля:

{{< code "sh" >}}
git submodule deinit -f [MODULE]  \
  && git rm -r --cached [MODULE]  \
  && rm -rf .git/modules/[MODULE] \
  && rm -rf [MODULE]
{{< /code >}}

## Изменение адреса репозитория

Показать текущий адрес:

{{< code "sh" >}}
git remote -v
{{< /code >}}

Установить новый адрес:

{{< code "sh" >}}
git remote set-url origin '[URL]'
{{< /code >}}

## Изменение описания последнего commit'а

Если закралась ошибка в описании изменений кода при последнем commit'е, это описание можно изменить при помощи команды:

{{< code "sh" >}}
git commit --amend -m 'New commit message.'
{{< /code >}}

Далее, изменённый коммит принудительно отправить на сервер:

{{< code "sh" >}}
git push --force '[remoteName]' '[branchName]'
{{< /code >}}

{{< code "sh" >}}
git push --force 'origin' 'main'
{{< /code >}}
