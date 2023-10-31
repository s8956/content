---
title: 'Условия в шаблонах IP.Board 3.x'
description: ''
images:
  - 'https://images.unsplash.com/photo-1515879218367-8466d910aaa4'
cover:
  crop: 'entropy'
  fit: 'crop'
categories:
  - 'cmf'
  - 'inHistory'
tags:
  - 'ipb'
  - 'ips'
  - 'forum'
authors:
  - 'KitsuneSolar'
sources:
  - ''
license: 'CC-BY-SA-4.0'
complexity: '1'
toc: 1
comments: 1

date: '2023-10-17T02:07:22+03:00'
publishDate: '2023-10-17T02:07:22+03:00'
expiryDate: ''
lastMod: '2023-10-17T02:07:22+03:00'

hash: 'a74052949f0c82c1e70ece4990079dc72d71d8a9'
uuid: 'a7405294-9f0c-52c1-a70e-ce4990079dc7'
slug: 'a7405294-9f0c-52c1-a70e-ce4990079dc7'

draft: 0
---

Список условий, которые можно использовать в шаблонах **IP.Board 3.x**. Продолжаю находить и публиковать старые заметки со своих давно закрытых ресурсов.

<!--more-->

## Условия в шаблонах

1. Отображение информации в определённом сообщении.

```html
<if test="$post['post']['post_count'] == X">
  <!-- информация только в сообщении X -->
</if>
```

Где:

- `X` - номер сообщения в теме.

2. Отображение информации для определённых групп.

```html
<if test="in_array($this->memberData['member_group_id'], array( 4,5,6 ) )">
  <!-- информация только для групп ID = 4, 5 и 6 -->
<else />
  <!-- информация для всех остальных -->
</if>
```

3. Пример сложной конструкции с применением `<или>`.

```html
<if test="memberbox:|:$this->memberData['member_id']">
  <!-- информация только для пользователей -->
<else />
  <!-- информация только для гостей -->
</if>
```