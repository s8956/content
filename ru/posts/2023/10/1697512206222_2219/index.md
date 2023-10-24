---
title: 'Динамическое "(Powered by Invision Power Board)" на IP.Board 2.3'
description: ''
images:
  - 'https://images.unsplash.com/photo-1632177693073-f6e62c17ec59'
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
complexity: '0'
toc: 1
comments: 1

date: '2023-10-17T06:10:06+03:00'
publishDate: '2023-10-17T06:10:06+03:00'
expiryDate: ''
lastMod: '2023-10-17T06:10:06+03:00'

hash: '347826e153d9ac99b6f866fc359323a22ceffde3'
uuid: '347826e1-53d9-5c99-a6f8-66fc359323a2'
slug: '347826e1-53d9-5c99-a6f8-66fc359323a2'

draft: 0
---

Нашёл ещё одну модификацию а-ля "прикол на зависть другим". Модификация позволяет сделать из копирайта форума динамически изменяемую "свистульку".

<!--more-->

## Внедрение модификации

Открыть файл `./sources/action_public/boards.php`, найти:

```php
$cp = " (Powered by Invision Power Board)";
```

Заменить на:

```php
$cp_phrases = array(
  '0' => ' - CYBER-CITY: Поддержка',
  '1' => ' - CYBER-CITY: Разработка',
  '2' => ' - CYBER-CITY: Исследование',
);

$cp_rand = rand(0, 2);
$cp = $cp_phrases[$cp_rand];
```

Не забудьте, если у вас больше фраз, чем 3, то измените `rand(0, 2)`, где `0` - первая фраза, `2` - последняя.
