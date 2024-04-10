---
# -------------------------------------------------------------------------------------------------------------------- #
# General settings.
# -------------------------------------------------------------------------------------------------------------------- #

title: 'SQL запросы IP.Board 2.3'
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

date: '2023-10-17T02:59:21+03:00'
publishDate: '2023-10-17T02:59:21+03:00'
expiryDate: ''
lastMod: '2023-10-17T02:59:21+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# Meta settings.
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '54d4e4889a8fc5ed4feac77d4dba0720fc88c3ee'
uuid: '54d4e488-9a8f-55ed-8fea-c77d4dba0720'
slug: '54d4e488-9a8f-55ed-8fea-c77d4dba0720'

draft: 0
---

Запросы для базы дынных ({{< tag "SQL" >}}) {{< tag "IPB" >}} 2.3. Информация со старых проектов. Пригодится.

<!--more-->

## SQL запросы

1. Заменить определённый текст во всех сообщениях на форуме.

{{< code "sql" >}}
UPDATE ibf_posts SET post = REPLACE(post,'старый текст','новый текст');
{{< /code >}}

2. Заменить текст во всех описаниях форумов.

{{< code "sql" >}}
UPDATE ibf_forums SET description = REPLACE(description,'старый текст','новый текст');
{{< /code >}}

3. Очистка журнала предупреждений конкретного пользователя, где X - вставить id пользователя, чей журнал вы хотите очистить.

{{< code "sql" >}}
DELETE FROM ibf_warn_logs WHERE wlog_mid=X;
{{< /code >}}

4. Удалить подписи у всех пользователей.

{{< code "sql" >}}
UPDATE ibf_member_extra SET signature='Ваша подпись удалена';
{{< /code >}}

5. Удаление модераторов.

{{< code "sql" >}}
DELETE FROM ibf_moderators;
{{< /code >}}

6. Удаление модератора из всех форумов.

{{< code "sql" >}}
DELETE FROM ibf_moderators WHERE member_id = XX;
{{< /code >}}

7. Удаление модератора из определённых форумов.

{{< code "sql" >}}
DELETE FROM ibf_moderators WHERE member_id = XX AND forum_id IN (4, 11, 22, 25);
{{< /code >}}

8. Удаление аватаров у всех пользователей.

{{< code "sql" >}}
DELETE FROM ibf_member_extra WHERE avatar_location AND avatar_size;
{{< /code >}}

9. Если не работает, то выполните следующие два запроса:

{{< code "sql" >}}
UPDATE ibf_member_extra SET avatar_location = '';
{{< /code >}}

{{< code "sql" >}}
UPDATE ibf_member_extra SET avatar_size = '';
{{< /code >}}

10. Массовый перенос пользователей c определённым количеством сообщений из одной группы в другую.

{{< code "sql" >}}
UPDATE ibf_members SET mgroup=Б WHERE mgroup=А AND posts > 0;
{{< /code >}}

11. Удалить пользователей определенной группы, где b меняете на номер группы.

{{< code "sql" >}}
DELETE FROM ibf_members WHERE mgroup='b';
{{< /code >}}

12. Удалить все ICQ номера пользователей.

{{< code "sql" >}}
UPDATE ibf_member_extra SET icq_number='';
{{< /code >}}

13. Удалить ссылки на сайт у всех пользователей.

{{< code "sql" >}}
UPDATE ibf_member_extra SET website='';
{{< /code >}}

14. Снятие обязательного подтверждения модератором.

{{< code "sql" >}}
UPDATE ibf_members SET mod_posts='';
{{< /code >}}

15. Снятие только чтение/read_only.

{{< code "sql" >}}
UPDATE ibf_members SET restrict_post='';
{{< /code >}}

16. Очистка журнала.

{{< code "sql" >}}
DELETE FROM ibf_warn_logs WHERE wlog_mid=id_пользователя;
{{< /code >}}

17. Удаление всех установленных смайликов, то есть они переходят в список неустановленных смайликов.

{{< code "sql" >}}
DELETE FROM ibf_emoticons;
{{< /code >}}

18. Установка кодировки и сравнения БД по умолчанию.

{{< code "sql" >}}
ALTER DATABASE `название_бд` DEFAULT CHARACTER SET cp1251 COLLATE cp1251_general_ci;
{{< /code >}}

19. Аннулируем счётчик сообщений у всех пользователей.

{{< code "sql" >}}
UPDATE ibf_members SET posts='0';
{{< /code >}}

20. Аннулируем счётчик сообщений у определённых групп.

{{< code "sql" >}}
UPDATE ibf_members SET posts='0' WHERE mgroup='номер_группы';
{{< /code >}}

21. Удаление всех сообщений оставленных гостями.

{{< code "sql" >}}
DELETE FROM ibf_posts WHERE author_id='0';
{{< /code >}}

22. Заменить текст во всех описаниях тем.

{{< code "sql" >}}
UPDATE ibf_topics SET description = REPLACE(description,'старый текст','новый текст');
{{< /code >}}

## Благодарности

В составлении запросов благодарим следующих участников конференции:

- Mazafuka
- КиКиМоРа
- a_aqua
- Ritsuka
- Security
- truth
