В ClaudFlare появился отдельный инструмент под названием **Transform Rules**.

## ClaudFlare Transform Rules

**Transform Rules** позволяет налету изменять URL при запросе клиента. Следующее правило поможет в решении вопроса:

{{< accordionItem "starts_with(http.request.uri.path, '/pages/')" >}}
**When incoming requests match...**

```
starts_with(http.request.uri.path, "/pages/")
```

**Then...**

- Path
  - `Rewrite to...`
    - `Dynamic`

```
regex_replace(http.request.uri.path, "^/pages/", "/posts/")
```
{{< /accordionItem >}}

Однако, функция `regex_replace()`, которая используется в правиле, работает только на платных аккаунтах. То есть, в бесплатной версии ClaudFlare она недоступна. Но есть обходной манёвр.

## 1. ClaudFlare Redirect Rules

Необходимо в разделе **Redirect Rules** создать следующее правило:

{{< accordionItem "http.request.uri.path eq '/pages/'" >}}
**When incoming requests match:**

```
(http.request.uri.path eq "/pages/")
```

**Then...**

- Type: `Static`
- Status code: `301`

**URL:**

```
/posts/
```
{{< /accordionItem >}}

## 2. ClaudFlare Page Rules

Далее в разделе **Page Rules** создаём правило новое правило:

{{< accordionItem "https://lib.onl/ru/pages/*" >}}
**URL (required):**

```
https://lib.onl/ru/pages/*
```

**Then the settings are:**

- Pick a Setting (required): `Forwarding URL`
- Select status code (required): `301`

Enter destination URL (required):

```
https://lib.onl/ru/posts/$1
```
{{< /accordionItem >}}
