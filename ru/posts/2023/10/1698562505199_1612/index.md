---
title: 'Работа с правилами CloudFlare'
description: ''
images:
  - 'https://images.unsplash.com/photo-1687488802693-db85cc7783e4'
cover:
  crop: 'entropy'
  fit: 'crop'
categories:
  - 'network'
tags:
  - 'rule'
  - 'cloudflare'
authors:
  - 'KitsuneSolar'
sources:
  - 'https://developers.cloudflare.com/rules/url-forwarding/single-redirects/examples'
  - 'https://community.cloudflare.com/t/508780'
  - 'https://developer.mozilla.org/ru/docs/Web/HTTP/Status'
license: 'CC-BY-SA-4.0'
complexity: '1'
toc: 1
comments: 1

date: '2023-10-29T09:55:05+03:00'
publishDate: '2023-10-29T09:55:05+03:00'
expiryDate: ''
lastMod: '2023-10-29T09:55:05+03:00'

hash: 'e191797ed558a017dac4c28c6e0871ff4b1d29de'
uuid: 'e191797e-d558-5017-8ac4-c28c6e0871ff'
slug: 'e191797e-d558-5017-8ac4-c28c6e0871ff'

draft: 1
---

CloudFlare предоставляет мощный инструмент по работе с различными правилами, зависящими от запросов клиентов. Разберём составление этих правил и приведём несколько примеров.

<!--more-->

## Настройки правила

Каждое правило состоит из двух этапов:

1. If... - если.
2. Then... - тогда.

### If...

Этап "Если" означает условие, по которому будут фильтроваться клиенты.

#### Поля

- AS Num `ip.geoip.asnum` - 
- Source ASN `ip.src.asnum` - 
- Cookie `http.cookie` - 
- Country `ip.geoip.country` - 
- Continent `ip.geoip.continent` - 
- Hostname `http.host` - 
- IP Source Address `ip.src` - 
- Referer `http.referer` - 
- Request Method `http.request.method` - 
- SSL/HTTPS `ssl` - 
- URI Full `http.request.full_uri` - 
- URI `http.request.uri` - 
- URI Path `http.request.uri.path` - 
- URI Query String `http.request.uri.query` - 
- HTTP Version `http.request.version` - 
- User Agent `http.user_agent` - 
- X-Forward-For `http.x_forwarded_for` - 
- Client Certificate Verified `cf.tls_client_auth.cert_verified` - 

#### Операторы

- equals `eq` - 
- does not equal `ne` - 
- greater than `gt` - 
- less than `le` - 
- greater than or equal to `ge` - 
- less than or equal to `le` - 
- is in `in {}` - 
- is not in `not <field> in {}` - 

### Then...

Этап "Тогда" подразумевает под собой действие, которое будет применено к отфильтрованному клиенту.

#### Типы

- Dynamic
- Static

#### Коды статуса

- 301 (Moved Permanently) - запрошенный ресурс был окончательно перемещён в URL, указанный в заголовке `Location`. Браузер в случае такого ответа перенаправляется на эту страницу, а поисковые системы обновляют свои ссылки на ресурс (говоря языком SEO, вес страницы переносится на новый URL-адрес).
- 302 (Moved Temporarily) - запрошенный ресурс был временно перемещён по адресу, указанному в заголовке `Location`. Получив такой ответ браузер перенаправляется на новую страницу, но поисковые системы не обновляют свои ссылки на ресурс (в жаргоне SEO говорят, что вес ссылки (link-juice) не меняется и не отправляется на новый URL-адрес).
- 303 (See Other) - перенаправление производится не на новый (только что загруженный) ресурс, а на другую страницу, например, страницу подтверждения или страницу с результатами загрузки.
- 307 (Temporary Redirect) - запрошенный ресурс был временно перемещён в URL-адрес, указанный в заголовке `Location`. Единственное различие между 307 и 302 состоит в том, что 307 гарантирует, что метод и тело не будут изменены при выполнении перенаправленного запроса. В случае с кодом 302 некоторые старые клиенты неправильно меняли метод на `GET`, из-за чего поведение запросов с методом отличным от `GET` и ответа с кодом 302 непредсказуемо, тогда как поведение в случае ответа с кодом 307 предсказуемо. Для запросов `GET` поведение идентично.
- 308 (Permanent Redirect) - запрошенный ресурс был окончательно перемещён в URL-адрес, указанный в `Location`. Браузер перенаправляется на эту страницу, а поисковые системы обновляют свои ссылки на ресурс (в SEO-speak говорится, что link-juice отправляется на новый URL-адрес). Метод запроса и тело не будут изменены, тогда как 301 иногда может быть неправильно заменён на `GET` метод.

В примерах я буду приводить шаблон, который вписывается в редактор выражения. Поэтому, можно не щёлкать по удобным кнопочкам, а сразу нажимать {{< key "Edit expression" >}} и вписывать нужный шаблон.


## Переадресация

Самый часто используемый тип правил, это правила по работе с переадресацией. Привожу несколько примеров. Их можно брать готовыми и вставлять в редактор выражения, не забыв отредактировать под себя некоторые входные параметры, например, название домена или адрес куда переадресовывать клиентов.

### Пути

{{< accordion >}}
{{< accordionItem "example.com | www.example.com" >}}
`https://example.com` `->` `https://www.example.com`

When incoming requests match:

```lua
(http.host eq "example.com")
```

- Then...
  - Type: `Dynamic`
  - Status code: `301`

Expression:

```lua
concat("https://www.", http.host, http.request.uri.path)
```
{{< /accordionItem >}}
{{< accordionItem "www.example.com | example.com" >}}
`https://www.example.com` `->` `https://example.com`

When incoming requests match:

```lua
(http.host eq "www.example.com")
```

- Then...
  - Type: `Dynamic`
  - Status code: `301`

Expression:

```lua
concat("https://", http.host, http.request.uri.path)
```
{{< /accordionItem >}}
{{< accordionItem "example.com/path | example.org/path">}}
`https://example.com/path` `->` `https://example.org/path`

When incoming requests match:

```lua
(http.host eq "example.com")
```

- Then...
  - Type: `Dynamic`
  - Status code: `301`

Expression:

```lua
concat("https://example.org", http.request.uri.path)
```
{{< /accordionItem >}}
{{< accordionItem "example.com | example.org">}}
`https://example.com` `->` `https://example.org`

When incoming requests match:

```lua
(http.host contains "example.com")
```

- Then...
  - Type: `Static`
  - Status code: `301`

Expression:

```lua
https://example.org/
```
{{< /accordionItem >}}
{{< accordionItem "sub.example.com | example.com/sub">}}
`https://sub.example.com` `->` `https://example.com/sub`

When incoming requests match:

```lua
(http.host eq "sub.example.com")
```

- Then...
  - Type: `Dynamic`
  - Status code: `301`

Expression:

```lua
concat("https://", http.host, "/sub", http.request.uri.path)
```
{{< /accordionItem >}}
{{< accordionItem "example.com/sub | sub.example.com">}}
`https://example.com/sub` `->` `https://sub.example.com`

When incoming requests match:

```lua
(starts_with(http.request.uri.path, "/sub/"))
```

- Then...
  - Type: `Dynamic`
  - Status code: `301`

Expression:

```lua
concat("https://sub.", http.host, substring(http.request.uri.path, 6))
```

Число в функции `substring()` - это количество символов в названии директории `sub` + 1 символ.
{{< /accordionItem >}}
{{< accordionItem "example.com/contact-us/ | example.com/contact/">}}
`https://example.com/contact-us/` `->` `https://example.com/contact/`

When incoming requests match:

```lua
(http.request.uri.path eq "/contact-us/")
```

- Then...
  - Type: `Static`
  - Status code: `301`

Expression:

```lua
/contacts/
```
{{< /accordionItem >}}
{{< /accordion >}}

### Порты

{{< accordion >}}
{{< accordionItem "Переадресовать обращения к любым портам кроме '80' и '443'" >}}
`https://example.com:1212` `->` `https://example.com`

When incoming requests match:

```lua
(not (cf.edge.server_port in {80 443}))
```

- Then...
  - Type: `Dynamic`
  - Status code: `301`

Expression:

```lua
concat("https://", http.host, http.request.uri.path)
```
{{< /accordionItem >}}
{{< /accordion >}}

### Страны

{{< accordion >}}
{{< accordionItem "Переадресовать пользователей из стран RU/BY/UA в директорию '/ru'" >}}
When incoming requests match:

```lua
(((ip.geoip.country eq "RU") or (ip.geoip.country eq "BY") or (ip.geoip.country eq "UA")) and (http.request.uri.path eq "/"))
```

- Then...
  - Type: `Dynamic`
  - Status code: `301`

Expression:

```lua
lower(concat("https://", http.host, "/ru/"))
```
{{< /accordionItem >}}
{{< accordionItem "Переадресовать пользователей НЕ из стран RU/BY/UA в директорию '/en'" >}}
When incoming requests match:

```lua
(((ip.geoip.country ne "RU") or (ip.geoip.country ne "BY") or (ip.geoip.country ne "UA")) and (http.request.uri.path eq "/"))
```

- Then...
  - Type: `Dynamic`
  - Status code: `301`

Expression:

```lua
lower(concat("https://", http.host, "/en/"))
```
{{< /accordionItem >}}
{{< /accordion >}}
