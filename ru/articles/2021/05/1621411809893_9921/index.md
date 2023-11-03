---
title: 'Синхронизация репозитория от GitHub к GitLab'
description: ''
images:
  - 'https://images.unsplash.com/photo-1531030874896-fdef6826f2f7'
categories:
  - 'dev'
  - 'scripts'
tags:
  - 'git'
  - 'github'
  - 'gitlab'
  - 'sync'
  - 'actions'
authors:
  - 'KitsuneSolar'
license: 'CC-BY-SA-4.0'
complexity: '0'
toc: 1
comments: 1

date: '2021-05-09T00:06:18+03:00'

type: 'articles'
hash: '8544b8ce4586478f5633e8ae43441a25c9bb8bde'
uuid: '8544b8ce-4586-578f-9633-e8ae43441a25'
slug: '8544b8ce-4586-578f-9633-e8ae43441a25'

draft: 0
---

Понадобилось мне на днях синхронизировать некоторые свои репозитории между GitHub и GitLab. Сам GitLab имеет встроенные средства зеркалирования репозиториев от себя к другому git-хранилищу. GitHub же не обладает такой функцией. Но эту функцию можно воссоздать при помощи GitHub Actions.

<!--more-->

Для начала необходимо создать "секреты" с такими переменными:

- `GITLAB_SYNC_REPO_URL` - ссылка на пустой репозиторий GitLab.
- `GITLAB_SYNC_USER_NAME` - имя пользователя GitLab.
- `GITLAB_SYNC_USER_TOKEN` - токен пользователя GitLab. Токен создаётся в настройках аккаунта GitLab.

Далее, в корне репозитория нужно создать файл `.github/workflows/gitlab-sync.yml` со следующим содержанием:

{{< file "gitlab-sync.yml" >}}

На этом всё. Теперь при коммите в репозиторий, GutHub будет запускать Action и автоматически синхронизировать изменения с репозиторием на GitLab.
