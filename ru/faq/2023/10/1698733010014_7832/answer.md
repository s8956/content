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

Однако, функция `regex_replace()`, которая используется в правиле, работает только на платных аккаунтах. То есть, в бесплатной версии ClaudFlare она недоступна. Но есть обходной манёвр...

## ClaudFlare Page Rules

В разделе **Page Rules** создаём правило:

{{< accordionItem "https://domain.com/pages/*" >}}
**URL (required):**

```
domain.com/pages/*
```

**Then the settings are:**

- Pick a Setting (required): `Forwarding URL`
- Select status code (required): `301`

Enter destination URL (required):

```
https://domain.com/posts/$1
```
{{< /accordionItem >}}

Замечу, что раздел **Page Rules** объявлен `deprecated` и, возможно, в будущем будет удалён.
