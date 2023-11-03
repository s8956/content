---
title: 'Дополнительная страница для IP.Board 2.3'
description: ''
images:
  - 'https://images.unsplash.com/photo-1527176930608-09cb256ab504'
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

date: '2023-10-17T20:39:08+03:00'
publishDate: '2023-10-17T20:39:08+03:00'
expiryDate: ''
lastMod: '2023-10-17T20:39:08+03:00'

type: 'articles'
hash: 'f0463a780393e891ebe5c39ec575ae7527098d69'
uuid: 'f0463a78-0393-5891-bbe5-c39ec575ae75'
slug: 'f0463a78-0393-5891-bbe5-c39ec575ae75'

draft: 0
---

Ещё один артефакт прошлого. Инструкция по созданию дополнительных страниц в **IP.Board 2.3**. Старая, но вдруг кому-то пригодится.

<!--more-->

## Что такое дополнительная страница (или Custom Pages)?

Дополнительная страница (или Custom Pages) - это страница, "совмещённая" со стилем форума и находится по адресу:

```
http://example.com/index.php?autocom=название_страницы
```

Объект `название_страницы` представляет собой название файла `.php` дополнительной страницы.

## Как сделать дополнительную страницу?

Создаём файл `.php` следующего содержания:

```php
<?php
class component_public
{
  var $ipsclass;

  function run_component()
  {
    $this->pagetitle = "Название страницы";
    /* Здесь идёт название вашей страницы.
    Название также будет показано в панели навигации вашего форума. */

    $this->nav[] = "<a href='{$this->ipsclass->base_url}autocom=custom'>{$this->pagetitle}</a>";
    $this->ipsclass->load_template('skin_global');

    $output .= "Здесь содержимое страницы";
    /* Здесь будет содержимое вашей будущей страницы.
    Содержимое помещается между кавычками.
    Также, как обычно, вам доступен HTML-код. */

    $this->ipsclass->print->add_output($output);
    $this->ipsclass->print->do_output(array('TITLE' => "{$this->ipsclass->vars['board_name']} - {$this->pagetitle}", 'JS' => 0, 'NAV' => $this->nav));
  }
}
```
В самом коде установлены комментарии, так что вы без труда разберётесь что к чему.

После создания этого PHP-файла, вы должны поместить его в папку `./sources/components_public`.

Всё!
