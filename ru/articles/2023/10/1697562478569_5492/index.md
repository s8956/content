---
title: 'Условия в шаблонах для vBulletin 3'
description: ''
images:
  - 'https://images.unsplash.com/photo-1518773553398-650c184e0bb3'
categories:
  - 'cmf'
  - 'inHistory'
tags:
  - 'vbulletin'
  - 'forum'
authors:
  - 'KitsuneSolar'
sources:
  - ''
license: 'CC-BY-SA-4.0'
complexity: '1'
toc: 1
comments: 1

date: '2023-10-17T20:07:58+03:00'
publishDate: '2023-10-17T20:07:58+03:00'
expiryDate: ''
lastMod: '2023-10-17T20:07:58+03:00'

type: 'articles'
hash: 'f82b1436675240845a98264b264edca776a3886b'
uuid: 'f82b1436-6752-5084-ba98-264b264edca7'
slug: 'f82b1436-6752-5084-ba98-264b264edca7'

draft: 0
---

Набор условий для применения в шаблонах форумного движка **vBulletin 3**.

<!--more-->

## Условия в шаблонах

1. Показать информацию для одной или нескольких групп пользователей.

```html
<if condition="is_member_of($bbuserinfo, X, Y, Z)">
  <!-- информация -->
</if>
```

2. Показать информацию только для одного пользователя.

```html
<if condition="$bbuserinfo[userid] == X">
  <!-- информация -->
</if>
```

3. Показать информацию только для нескольких пользователей.

```html
<if condition="in_array($bbuserinfo[userid], array(X,Y,Z))">
  <!-- информация -->
</if>
```

4. Скрыть информацию для одной группы пользователей.

```html
<if condition="!is_member_of($bbuserinfo, X)">
  <!-- информация -->
</if>
```

5. Скрыть информацию для нескольких групп пользователей.

```html
<if condition="!is_member_of($bbuserinfo, X, Y, Z)">
  <!-- информация -->
</if>
```

6. Скрыть информацию от нескольких пользователей.

```html
<if condition="!in_array($bbuserinfo[userid], array(X,Y,Z))">
  <!-- информация -->
</if>
```

7. Показать информацию только в определённом форуме.

```html
<if condition="$forumid == X">
  <!-- информация -->
</if>
```

8. Показать информацию в нескольких форумах.

```html
<if condition="in_array($forumid, array(X,Y,Z))">
  <!-- информация -->
</if>
```

9. Скрыть информацию в определённом форуме.

```html
<if condition="$forumid != X">
  <!-- информация -->
</if>
```

10. Скрыть информацию в нескольких форумах.

```html
<if condition="!in_array($forumid, array(X,Y,Z))">
  <!-- информация -->
</if>
```
