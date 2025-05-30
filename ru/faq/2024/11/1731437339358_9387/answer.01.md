CloudFlare не позволяет отключить ECH удобным способом. Придётся использовать API напрямую. Я буду приводить команды для терминала Linux. Но их легко адаптировать под ОС MS Windows.

Чтобы проверить наличие ECH у домена, необходимо выполнить следующий запрос:

```bash
d='example.org'; curl -X 'GET' -H 'Accept: application/json' "https://dns.google/resolve?name=${d}&type=HTTPS"
```

Параметры:

- `d` - имя домена.

Если в ответе будет присутствовать параметр `ech=`, то ECH для домена включён. Для отключения ECH можно воспользоваться следующей командой:

```bash
m='mail@example.org'; k='GLOBAL_API_KEY'; z='ZONE_ID'; curl -X 'PATCH' "https://api.cloudflare.com/client/v4/zones/${z}/settings/ech" -H "X-Auth-Email: ${m}" -H "X-Auth-Key: ${k}" -H 'Content-Type: application/json' -d '{"id":"ech","value":"off"}'
```

Параметры:

- `m` - адрес e-mail аккаунта в CloudFlare.
- `k` - глобальный API-ключ (Global API Key) в CloudFlare.
- `z` - идентификатор зоны (Zone ID) в CloudFlare.

Для проверки текущей настройки ECH в CloudFlare, можно воспользоваться следующим запросом:

```bash
m='mail@example.org'; k='GLOBAL_API_KEY'; z='ZONE_ID'; curl -X 'GET' "https://api.cloudflare.com/client/v4/zones/${z}/settings/ech" -H "X-Auth-Email: ${m}" -H "X-Auth-Key: ${k}" -H 'Content-Type: application/json' -d '{"id":"ech"}'
```

Ответ будет примерно таким:

```json
"result":{"id":"ech","value":"on"}
```

Параметры:

- `"id"` - идентификатор настройки.
- `"value"` - значение настройки:
  - `on` - ECH включён.
  - `off` - ECH выключен.
