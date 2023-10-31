---
title: 'Генератор иконок для сайта'
description: ''
images:
  - 'https://images.unsplash.com/photo-1554061523-c90d630a7ac9'
categories:
  - 'dev'
  - 'scripts'
tags:
  - 'imagemagick'
  - 'inkscape'
  - 'convert'
authors:
  - 'KitsuneSolar'
license: 'CC-BY-SA-4.0'
complexity: '0'
toc: 1
comments: 1

date: '2021-05-18T10:41:46+03:00'
hash: '841ba281a22b95ee797d251a5dc111d8c73f09b8'
uuid: '841ba281-a22b-55ee-b97d-251a5dc111d8'
slug: '841ba281-a22b-55ee-b97d-251a5dc111d8'

draft: 0
---

Сделал для сайта автоматизированное создание иконок типа `favicon`, которыми пользуются браузеры и устройства для своих нужд.

<!--more-->

Я накидал небольшой скрипт, состоящий из двух функций `png()` и `ico()`. Функция `png()` берёт файл `favicon.svg` и преобразует его в PNG, указанных в массиве `size`, размеров. Функция `ico()` также берёт файл `favicon.svg` и преобразует его в формат ICO, который содержит в себе несколько размеров изображения.

{{< file "favicon.sh" >}}

## Использование

Для работы скрипта необходимо, чтобы в системе были установлены **RSVG** и **ImageMagick**. Скрипт можно сохранить с произвольным именем, например, `favicon.sh` в директорию, где находится изображение `favicon.svg`. Далее, вызывать функции следующим образом:

```terminal {os="linux"}
bash favicon.sh png
```

```terminal {os="linux"}
bash favicon.sh ico
```

Скрипт ищет файл `favicon.svg` и преобразует его в необходимые изображения.