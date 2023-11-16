В ClaudFlare имеется раздел **Page Rules**, в котором можно настроить переадресацию.

## ClaudFlare Page Rules

В разделе **Page Rules** создаём правило:

{{< accordion-item "https://domain.com/pages/*" >}}
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
{{< /accordion-item >}}

Замечу, что раздел **Page Rules** объявлен `deprecated` и, возможно, в будущем будет удалён.
