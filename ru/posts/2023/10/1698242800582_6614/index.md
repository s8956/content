---
title: 'Изучаем API "ЕИС Закупки"'
description: ''
images:
  - 'https://images.unsplash.com/photo-1536733203354-a125031aa773'
cover:
  crop: 'entropy'
  fit: 'crop'
categories:
  - 'inDev'
  - 'linux'
  - 'windows'
  - 'terminal'
tags:
  - 'powershell'
  - 'bash'
  - 'закупки'
authors:
  - 'KitsuneSolar'
sources:
  - ''
license: 'CC-BY-SA-4.0'
complexity: '1'
toc: 1
comments: 1

date: '2023-10-25T17:06:40+03:00'
publishDate: '2023-10-25T17:06:40+03:00'
expiryDate: ''
lastMod: '2023-10-25T17:06:40+03:00'

hash: '4e4a39b0798945921a9cbe748204148c61e53948'
uuid: '4e4a39b0-7989-5592-8a9c-be748204148c'
slug: '4e4a39b0-7989-5592-8a9c-be748204148c'

draft: 1
---

ololol

<!--more-->

## URL на получение списка закупок

```
https://zakupki.gov.ru/api/mobile/proxy/epz/order/extendedsearch/results.html?searchString=7719167509&strictEqual=true&sortDirection=false&sortBy=PUBLISH_DATE&recordsPerPage=_10&fz44=on&fz223=on&ppRf615=on&fz94=on&af=on&ca=on&pc=on&pa=on
```

```
https://zakupki.gov.ru/api/mobile/proxy/epz/order/extendedsearch/results.html?searchString=7719167509
&strictEqual=true
&sortDirection=false
&sortBy=PUBLISH_DATE
&recordsPerPage=_10
&fz44=on
&fz223=on
&ppRf615=on
&fz94=on
&af=on
&ca=on
&pc=on
&pa=on
```

### Параметры

#### Общие

- `?searchString=`
- `&recordsPerPage=`
  - `_10`
  - `_20`
  - `_50`

#### Сортировка данных

- `&sortBy=` параметр сортировки.
  - `UPDATE_DATE` - дата обновления.
  - `PUBLISH_DATE` - дата публикации.
  - `PRICE` - цена.
  - `RELEVANCE` - релевантность.
- `&sortDirection=` - направление сортировки.
  - `false` - от нового к старому.
  - `true` - от старого к новому.

#### Законы

- `&fz44=on` - 44-ФЗ
- `&fz223=on` - 223-ФЗ
- `&ppRf615=on` - ПП РФ 615 (Капитальный ремонт)
- `&fz94=on` - 94-ФЗ

#### Этапы закупки

- `&af=on` - подача заявок
- `&ca=on` - работа комиссии
- `&pc=on` - закупка завершена
- `&pa=on` - закупка отменена

#### Лоты закупки

- `&showLotsInfoHidden=` - открыть лоты.
  - `false` - нет.
  - `true` - да.


## Запрос на получение списка закупок

### Linux

{{< alert "important" >}}
При запросе обязательно указывайте **User-Agent**! Первый запрос может пройти без User-Agent'а, но все последующие будут блокироваться.
{{< /alert >}}

```sh
curl -X GET -A 'Mozilla/5.0 (X11; Linux i686; rv:109.0) Gecko/20100101 Firefox/119.0' \
'https://zakupki.gov.ru/api/mobile/proxy/epz/order/extendedsearch/results.html?searchString=7719167509' \
-d 'strictEqual=true' \
-d 'sortDirection=false' \
-d 'sortBy=PUBLISH_DATE' \
-d 'recordsPerPage=_10' \
-d 'fz44=on' \
-d 'fz223=on' \
-d 'ppRf615=on' \
-d 'fz94=on' \
-d 'af=on' \
-d 'ca=on' \
-d 'pc=on' \
-d 'pa=on' \
-o 'orders.json'
```

### MS Windows

```powershell
$URL = 'https://zakupki.gov.ru/api/mobile/proxy/epz/order/extendedsearch/results.html?searchString=7719167509' +
'&strictEqual=true' +
'&sortDirection=false' +
'&sortBy=PUBLISH_DATE' +
'&recordsPerPage=_10' +
'&fz44=on' +
'&fz223=on' +
'&ppRf615=on' +
'&fz94=on' +
'&af=on' +
'&ca=on' +
'&pc=on' +
'&pa=on'

Invoke-WebRequest "${URL}" -OutFile 'orders.json'
```

## Работа с файлом `orders.json`

{{< file "orders.json" >}}

### Linux

```sh
cat 'orders.json' | jq -r '.list[] | .name'
```

```sh
cat 'orders.json' | jq -r '.list[] | .number'
```

### MS Windows

```powershell
(Get-Content 'orders.json' | ConvertFrom-Json).list.name
```

```powershell
(Get-Content 'orders.json' | ConvertFrom-Json).list.number
```
