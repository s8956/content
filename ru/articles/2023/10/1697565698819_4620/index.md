---
title: 'Дополнительная страница для vBulletin 4'
description: ''
images:
  - 'https://images.unsplash.com/photo-1554757387-fa0367573d09'
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

date: '2023-10-17T21:01:38+03:00'
publishDate: '2023-10-17T21:01:38+03:00'
expiryDate: ''
lastMod: '2023-10-17T21:01:38+03:00'

type: 'articles'
hash: '382d49d68f44d3674f2488890d7c47236f33b67b'
uuid: '382d49d6-8f44-5367-bf24-88890d7c4723'
slug: '382d49d6-8f44-5367-bf24-88890d7c4723'

draft: 0
---

Создание дополнительных страниц для уже устаревшего форумного движка **vBulletin 4**.

<!--more-->

Для **vBulletin** версии **4.0** действия практически одни и те же, как в материале {{< uuid "01d19479-028f-5b81-9c58-9c99adb08461" >}}.

## Что такое дополнительная страница (или Custom Pages)?

Дополнительная страница (или Custom Pages) - это страница, "совмещённая" со стилем форума.

## Как сделать дополнительную страницу?

Необходимо создать шаблон `custom_ШАБЛОН`, содержимое которого представляет собой следующий код:

```html
{vb:stylevar htmldoctype}
<html xmlns="http://www.w3.org/1999/xhtml" dir="{vb:stylevar textdirection}" lang="{vb:stylevar languagecode}" id="vbulletin_html">
<head>
  <title>{vb:raw vboptions.bbtitle}</title>
  {vb:raw headinclude}
</head>
<body>
  {vb:raw header}
  {vb:raw navbar}
  <div id="pagetitle">
    <h1>{vb:raw pagetitle}</h1>
  </div>
  <h2 class="blockhead"><!-- Заголовок страницы --></h2>
    <div class="blockbody">
    <div class="blockrow">
      <!-- Текст страницы -->
    </div>
  </div>
  {vb:raw footer}
</body>
</html>
```

Страница будет располагаться по адресу:

```
https://example.com/misc.php?do=page&template=ШАБЛОН
```
