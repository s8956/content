---
# -------------------------------------------------------------------------------------------------------------------- #
# General settings.
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Условия в шаблонах XenForo 2'
description: ''
images:
  - 'https://images.unsplash.com/photo-1488590528505-98d2b5aba04b'
categories:
  - 'cmf'
tags:
  - 'html'
  - 'xenforo'
  - 'cms'
  - 'cmf'
authors:
  - 'KaiKimera'
sources:
  - 'https://xenforo.com/community/resources/5795/'
license: 'CC-BY-SA-4.0'
complexity: '1'
toc: 1
comments: 1

# -------------------------------------------------------------------------------------------------------------------- #
# Date settings.
# -------------------------------------------------------------------------------------------------------------------- #

date: '2021-08-17T15:21:10+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# Meta settings.
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: 'f9a39e378816ff800133893f3dc8f35296dea86f'
uuid: 'f9a39e37-8816-5f80-8133-893f3dc8f352'
slug: 'f9a39e37-8816-5f80-8133-893f3dc8f352'

draft: 0
---

Представляю список условий, которые можно использовать в шаблонах {{< tag "XenForo" >}}. Все возможные условия перечислить затруднительно, потому что существует множество различных вариантов фильтрации и выборки информации. Здесь представлены наиболее популярные варианты.

<!--more-->

С этой статьи я начинаю попытку восстановления накопленных данных за период моей деятельности в качестве исследователя и разработчика веб-приложений.

## Условия в шаблонах

1. Отображение информации только администраторам.

{{< code "html" >}}
<xf:if is="$xf.visitor.is_admin">
  <!-- content -->
</xf:if>
{{< /code >}}

2. Отображение информации только модераторам.

{{< code "html" >}}
<xf:if is="$xf.visitor.is_moderator">
  <!-- content -->
</xf:if>
{{< /code >}}

3. Отображение информации только администраторам и модераторам.

{{< code "html" >}}
<xf:if is="$xf.visitor.is_admin OR $xf.visitor.is_moderator">
  <!-- content -->
</xf:if>
{{< /code >}}

4. Отображение информации только зарегистрированному пользователю

{{< code "html" >}}
<xf:if is="$xf.visitor.user_id">
  <!-- content -->
</xf:if>
{{< /code >}}

5. Отображение информации гостю.

{{< code "html" >}}
<xf:if is="!$xf.visitor.user_id">
  <!-- content -->
</xf:if>
{{< /code >}}

6. Отображение разной информации зарегистрированному пользователю и гостю.

{{< code "html" >}}
<xf:if is="!$xf.visitor.user_id">
  <!-- content for members -->
<xf:else />
  <!-- content for guests -->
</xf:if>
{{< /code >}}

7. Отображение информации только заблокированным пользователям.

{{< code "html" >}}
<xf:if is="$user.is_banned">
  <!-- content -->
</xf:if>
{{< /code >}}

8. Отображение информации только если у пользователя симпатий больше определённого количества.

{{< code "html" >}}
<xf:if is="$user.like_count|number > X">
  <!-- content -->
</xf:if>
{{< /code >}}

9. Отображение информации только если у пользователя сообщений больше определённого количества.

{{< code "html" >}}
<xf:if is="{$xf.visitor.message_count|number} > X">
  <!-- content -->
</xf:if>
{{< /code >}}

10. Отображение информации только если у пользователя очков больше определённого количества.

{{< code "html" >}}
<xf:if is="$user.trophy_points|number > X">
  <!-- content -->
</xf:if>
{{< /code >}}

11. Отображение информации определённому пользователю.

{{< code "html" >}}
<xf:if is="$xf.visitor.user_id == X">
  <!-- content -->
</xf:if>
{{< /code >}}

12. Отображение информации определённым пользователям.

{{< code "html" >}}
<xf:if is="in_array($xf.visitor.user_id, [X, Y, Z])">
  <!-- content -->
</xf:if>
{{< /code >}}

13. (1) Отображение информации определённым группам пользователей.

{{< code "html" >}}
<xf:if is="{{$xf.visitor.isMemberOf([X, Y])}}">
  <!-- content -->
</xf:if>
{{< /code >}}

13. (2) Отображение информации определённой группе пользователей.

{{< code "html" >}}
<xf:if is="{{$xf.visitor.isMemberOf(X)}}">
  <!-- content -->
</xf:if>
{{< /code >}}

14. (1) Скрытие информации от определённых групп пользователей.

{{< code "html" >}}
<xf:if is="{{!$xf.visitor.isMemberOf([X, Y])}}">
  <!-- content -->
</xf:if>
{{< /code >}}

14. (2) Скрытие информации от определённой группы пользователей.

{{< code "html" >}}
<xf:if is="{{!$xf.visitor.isMemberOf(X)}}">
  <!-- content -->
</xf:if>
{{< /code >}}

15. (1) Отображение информации после первого сообщения в теме.

{{< code "html" >}}
<xf:if is="$post.position % $xf.options.messagesPerPage == 0">
  <!-- content -->
</xf:if>
{{< /code >}}

15. (2) Отображение информации через определённое количества сообщений.

{{< code "html" >}}
<xf:if is="$post.position % $xf.options.messagesPerPage == X">
  <!-- content -->
</xf:if>
{{< /code >}}

16. Отображение информации на странице, на которой присутствует боковая панель.

{{< code "html" >}}
<xf:if is="$sidebar">
  <!-- content -->
</xf:if>
{{< /code >}}

17. Отображение информации на главной (домашней) странице форума.

{{< code "html" >}}
<xf:if is="$template == 'forum_list'">
  <!-- content -->
</xf:if>
{{< /code >}}

18. Скрытие информации только с главной (домашней) странице форума.

{{< code "html" >}}
<xf:if is="$template !== 'forum_list'">
  <!-- content -->
</xf:if>
{{< /code >}}

19. Отображение информации на странице создания новой темы.

{{< code "html" >}}
<xf:if is="$template == 'forum_post_thread'">
  <!-- content -->
</xf:if>
{{< /code >}}

20. Скрытие информации на странице создания новой темы.

{{< code "html" >}}
<xf:if is="$template != 'forum_post_thread'">
  <!-- content -->
</xf:if>
{{< /code >}}

21. Отображение информации на странице создания нового ресурса.

{{< code "html" >}}
<xf:if is="$template == 'xfrm_category_add_resource'">
  <!-- content -->
</xf:if>
{{< /code >}}

22. Скрытие информации на странице создания нового ресурса.

{{< code "html" >}}
<xf:if is="$template != 'xfrm_category_add_resource'">
  <!-- content -->
</xf:if>
{{< /code >}}

23. Отображение информации на странице поисковой формы.

{{< code "html" >}}
<xf:if is="$template == 'search_form'">
  <!-- content -->
</xf:if>
{{< /code >}}

24. Скрытие информации на странице поисковой формы.

{{< code "html" >}}
<xf:if is="$template != 'search_form'">
  <!-- content -->
</xf:if>
{{< /code >}}

25. Отображение информации на странице "Что нового?".

{{< code "html" >}}
<xf:if is="$template == 'whats_new'">
  <!-- content -->
</xf:if>
{{< /code >}}

26. Скрытие информации на странице "Что нового?".

{{< code "html" >}}
<xf:if is="$template != 'whats_new'">
  <!-- content -->
</xf:if>
{{< /code >}}

27. Отображение информации на странице просмотра личной переписки.

{{< code "html" >}}
<xf:if is="$template == 'conversation_view'">
  <!-- content -->
</xf:if>
{{< /code >}}

28. Скрытие информации на странице просмотра личной переписки.

{{< code "html" >}}
<xf:if is="$template != 'conversation_view'">
  <!-- content -->
</xf:if>
{{< /code >}}

29. Отображение информации на странице просмотра списка личных переписок.

{{< code "html" >}}
<xf:if is="$template == 'conversation_list'">
  <!-- content -->
</xf:if>
{{< /code >}}

30. Скрытие информации на странице просмотра списка личных переписок.

{{< code "html" >}}
<xf:if is="$template != 'conversation_list'">
  <!-- content -->
</xf:if>
{{< /code >}}

31. Отображение информации на главной странице ресурсов.

{{< code "html" >}}
<xf:if is="$template == 'xfrm_overview'">
  <!-- content -->
</xf:if>
{{< /code >}}

32. Скрытие информации на главной странице ресурсов.

{{< code "html" >}}
<xf:if is="$template != 'xfrm_overview'">
  <!-- content -->
</xf:if>
{{< /code >}}

33. Отображение информации на странице просмотра ресурса.

{{< code "html" >}}
<xf:if is="$template == 'xfrm_resource_view'">
  <!-- content -->
</xf:if>
{{< /code >}}

34. Скрытие информации на странице просмотра ресурса.

{{< code "html" >}}
<xf:if is="$template != 'xfrm_resource_view'">
  <!-- content -->
</xf:if>
{{< /code >}}

35. Отображение информации на странице просмотра темы.

{{< code "html" >}}
<xf:if is="$template == 'thread_view'">
  <!-- content -->
</xf:if>
{{< /code >}}

36. Скрытие информации на странице просмотра темы.

{{< code "html" >}}
<xf:if is="$template !='thread_view'">
  <!-- content -->
</xf:if>
{{< /code >}}

37. Отображение информации на странице просмотра форума (раздела).

{{< code "html" >}}
<xf:if is="$template =='forum_view'">
  <!-- content -->
</xf:if>
{{< /code >}}

38. Скрытие информации на странице просмотра форума (раздела).

{{< code "html" >}}
<xf:if is="$template != 'forum_view'">
  <!-- content -->
</xf:if>
{{< /code >}}

39. Отображение информации "наказанным" пользователям.

{{< code "html" >}}
<xf:if is="{$xf.visitor.Option.is_discouraged}">
  <!-- content -->
</xf:if>
{{< /code >}}

40. Отображение информации пользователям, которые имеют Gravatar.

{{< code "html" >}}
<xf:if is="{$xf.visitor.gravatar}">
  <!-- content -->
</xf:if>
{{< /code >}}

41. Отображение информации пользователям поддержки форума.

{{< code "html" >}}
<xf:if is="{$xf.visitor.is_staff}">
  <!-- content -->
</xf:if>
{{< /code >}}

42. Отображение информации пользователям без подтверждённого адреса e-mail.

{{< code "html" >}}
<xf:if is="{$xf.visitor.isAwaitingEmailConfirmation()}">
  <!-- content -->
</xf:if>
{{< /code >}}

43. Отображение информации в нескольких форумах (разделах).

{{< code "html" >}}
<xf:if is="in_array({$forum.node_id}, [X, Y, Z])">
  <!-- content -->
</xf:if>
{{< /code >}}

44. Скрытие информации в нескольких форумах (разделах).

{{< code "html" >}}
<xf:if is="in_array($forum.node_id, [X, Y, Z])">
  <!-- content -->
</xf:if>
{{< /code >}}

45. Отображение информации в определённом форуме (разделе).

{{< code "html" >}}
<xf:if is="$forum.node_id == X">
  <!-- content -->
</xf:if>
{{< /code >}}

46. Скрытие информации в определённом форуме (разделе).

{{< code "html" >}}
<xf:if is="$forum.node_id != 3">
  <!-- content -->
</xf:if>
{{< /code >}}

47. Отображение информации только после первого сообщения в каждой теме.

{{< code "html" >}}
<xf:if is="{$post.position} % {$xf.options.messagesPerPage} == 1">
  <!-- content -->
</xf:if>
{{< /code >}}

48. Отображение информации только внутри первого сообщения в каждой теме.

{{< code "html" >}}
<xf:if is="{$post.position} % {$xf.options.messagesPerPage} == 0">
  <!-- content -->
</xf:if>
{{< /code >}}

49. Отображение информации только при заполненном поле местоположения.

{{< code "html" >}}
<xf:if is="{$xf.visitor.location}">
  <!-- content -->
</xf:if>
{{< /code >}}

50. Отображение информации только при заполненном поле веб-сайта.

{{< code "html" >}}
<xf:if is="{$xf.visitor.website}">
  <!-- content -->
</xf:if>
{{< /code >}}

51. Отображение информации при указанной подписи.

{{< code "html" >}}
<xf:if is="{$xf.visitor.signature}">
  <!-- content -->
</xf:if>
{{< /code >}}

52. Отображение информации только активированным пользователям.

{{< code "html" >}}
<xf:if is="{$xf.visitor.user_state} == 'valid'">
  <!-- content -->
</xf:if>
{{< /code >}}

53. Отображение информации только пользователям, ожидающим подтверждения адреса e-mail.

{{< code "html" >}}
<xf:if is="{$xf.visitor.user_state} == 'email_confirm_edit'">
  <!-- content -->
</xf:if>
{{< /code >}}

54. Отображение информации только пользователям с проблемным адресом e-mail.

{{< code "html" >}}
<xf:if is="{$xf.visitor.user_state} == 'email_bounce'">
  <!-- content -->
</xf:if>
{{< /code >}}

55. Отображение информации, если ID пользователя = ID автора темы.

{{< code "html" >}}
<xf:if is="{$__globals.thread} AND {$__globals.thread.user_id} == {$user.user_id}">
  <!-- content -->
</xf:if>
{{< /code >}}

56. Отображение информации пользователю, который является автором темы.

{{< code "html" >}}
<xf:if is="{$thread.user_id} == {$xf.visitor.user_id}">
  <!-- content -->
</xf:if>
{{< /code >}}
