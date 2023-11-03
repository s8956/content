---
title: 'Дополнительная страница для vBulletin 3'
description: ''
images:
  - 'https://images.unsplash.com/photo-1573848855919-9abecc93e456'
cover:
  crop: 'entropy'
  fit: 'crop'
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
complexity: '0'
toc: 1
comments: 1

date: '2023-10-17T20:39:09+03:00'
publishDate: '2023-10-17T20:39:09+03:00'
expiryDate: ''
lastMod: '2023-10-17T20:39:09+03:00'

type: 'articles'
hash: '01d19479028fdb81cc589c99adb08461aa6ad4e1'
uuid: '01d19479-028f-5b81-9c58-9c99adb08461'
slug: '01d19479-028f-5b81-9c58-9c99adb08461'

draft: 0
---

Материал по созданию дополнительных страниц в **vBulletin 3**. Возможно, кто-то ещё пользуется этой версией движка...

<!--more-->

## Что такое дополнительная страница (или Custom Pages)?

Дополнительная страница (или Custom Pages) - это страница, "совмещённая" со стилем форума и находится по адресу:

```
http://example.com/misc.php?do=page&template=название_страницы
```

## Как сделать дополнительную страницу?

Итак, для начала нужно создать дополнительный шаблон того стиля, который вами используется. Этот дополнительный шаблон должен иметь префикс `custom_`, то есть само название дополнительного шаблона должно выглядеть вот так: `custom_ШАБЛОН`.

После этого в тело шаблона вставляем следующий код:

```html
$stylevar[htmldoctype]
<html dir="$stylevar[textdirection]" lang="$stylevar[languagecode]">
  <head>
    $headinclude
    <title>$vboptions[bbtitle]</title>
  </head>
  <body>
    $header
    $navbar
    <!-- На этом месте будет находится ваш код страницы. -->
    $footer
  </body>
</html>
```

Вот и всё!
