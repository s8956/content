---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'GitLab: Установка и настройка'
description: ''
images:
  - 'https://images.unsplash.com/photo-1531030874896-fdef6826f2f7'
categories:
  - 'linux'
  - 'terminal'
tags:
  - 'debian'
  - 'apt'
  - 'gitlab'
  - 'install'
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

date: '2025-02-06T18:28:09+03:00'
publishDate: '2025-02-06T18:28:09+03:00'
lastMod: '2025-02-06T18:28:09+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: 'f2d035758435b182025dac2a22100055e6b81721'
uuid: 'f2d03575-8435-5182-925d-ac2a22100055'
slug: 'f2d03575-8435-5182-925d-ac2a22100055'

draft: 1
---



<!--more-->

## Репозиторий

### GPG

- Скачать и установить ключ репозитория:

```bash
curl -fsSL 'https://packages.gitlab.com/gitlab/gitlab-ce/gpgkey' | gpg --dearmor -o '/etc/apt/keyrings/gitlab.gpg'
```

### APT

- Создать файл репозитория `/etc/apt/sources.list.d/gitlab.sources` со следующим содержимым:

```bash
. '/etc/os-release'; echo -e "X-Repolib-Name: GitLab\nEnabled: yes\nTypes: deb\nURIs: https://packages.gitlab.com/gitlab/gitlab-ee/${ID}\n#URIs: https://mirror.yandex.ru/mirrors/packages.gitlab.com/gitlab/gitlab-ce\nSuites: ${VERSION_CODENAME}\nComponents: main\nArchitectures: $( dpkg --print-architecture )\nSigned-By: /etc/apt/keyrings/gitlab.gpg" | tee '/etc/apt/sources.list.d/gitlab.sources'
```

## Установка

- Установить пакеты:

```bash
apt update && apt install --yes gitlab-ee
```

## Настройка

### Основная конфигурация

- Сохранить оригинальный файл конфигурации:

```bash
f='/etc/gitlab/gitlab.rb'; [[ -f "${f}" && ! -f "${f}.orig" ]] && mv "${f}" "${f}.orig"
```

- Добавить в конец файла `/etc/gitlab/gitlab.rb` следующую информацию:

```ruby
#################################################################################
## Loading external configuration file
#################################################################################
from_file '/etc/gitlab/gitlab.local.rb'
```

### Дополнительная конфигурация

- Создать файл дополнительной конфигурации `/etc/gitlab/gitlab.local.rb` со следующим содержимым:

{{< file "gitlab.local.rb" >}}
