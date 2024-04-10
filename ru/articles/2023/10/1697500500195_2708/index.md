---
# -------------------------------------------------------------------------------------------------------------------- #
# General settings.
# -------------------------------------------------------------------------------------------------------------------- #

title: 'SQL запросы IP.Board 3.x'
description: ''
images:
  - 'https://images.unsplash.com/photo-1662026911591-335639b11db6'
categories:
  - 'cmf'
  - 'inHistory'
tags:
  - 'ipb'
  - 'ips'
  - 'sql'
  - 'forum'
authors:
  - 'KaiKimera'
sources:
  - ''
license: 'CC-BY-SA-4.0'
complexity: '1'
toc: 1
comments: 1

# -------------------------------------------------------------------------------------------------------------------- #
# Date settings.
# -------------------------------------------------------------------------------------------------------------------- #

date: '2023-10-17T02:55:00+03:00'
publishDate: '2023-10-17T02:55:00+03:00'
expiryDate: ''
lastMod: '2023-10-17T02:55:00+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# Meta settings.
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '06c9d35931f03862434262a21d4eb03207c54ba8'
uuid: '06c9d359-31f0-5862-a342-62a21d4eb032'
slug: '06c9d359-31f0-5862-a342-62a21d4eb032'

draft: 0
---

Запросы для базы дынных ({{< tag "SQL" >}}) {{< tag "IPB" >}} 3. Информация со старых проектов. Пригодится.

<!--more-->

## SQL запросы

1. Удалить всех модераторов.

{{< code "sql" >}}
DELETE FROM moderators;
{{< /code >}}

2. Удалить все подписи.

{{< code "sql" >}}
DELETE FROM content_cache_sigs;
{{< /code >}}

{{< code "sql" >}}
UPDATE profile_portal SET signature='';
{{< /code >}}

3. Массовый перенос пользователей c определённым количеством сообщений из одной группы в другую.

{{< code "sql" >}}
UPDATE members SET member_group_id=Б WHERE member_group_id=А AND posts > 0;
{{< /code >}}

4. Полный пересчет репутации сообщений и пользователей после ручной правки `ibf_reputation_index`.

{{< code "sql" >}}
TRUNCATE ibf_reputation_cache;
{{< /code >}}

{{< code "sql" >}}
INSERT INTO ibf_reputation_cache (app, type, type_id, rep_points) SELECT app, type, type_id, SUM(rep_rating) FROM ibf_reputation_index GROUP BY type_id;
{{< /code >}}

{{< code "sql" >}}
UPDATE ibf_profile_portal pp SET pp.pp_reputation_points = (SELECT SUM(r.rep_points) FROM ibf_posts p LEFT JOIN ibf_reputation_cache r ON r.type_id = p.pid WHERE p.author_id = pp.pp_member_id);
{{< /code >}}

5. Удаление или замена ненужного мусора из сообщений, например, куски от старых BBCODE.

{{< code "sql" >}}
UPDATE ibf_posts SET post = REPLACE(post,"original","replace");
{{< /code >}}

6. Удаление или замена информации из подписей пользователей.

{{< code "sql" >}}
UPDATE ibf_profile_portal SET signature = REPLACE(signature,"original","replace");
{{< /code >}}

## Благодарности

В составлении запросов благодарим следующих участников конференции:

- Mazafuka
- КиКиМоРа
- a_aqua
- Ritsuka
- Security
- truth
