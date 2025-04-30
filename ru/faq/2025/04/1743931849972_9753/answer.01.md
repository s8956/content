Домен настраивается при установки {{< tag "PVE" >}}. Изменить домен можно в графическом интерфейсе (в нескольких местах) или через терминал. Я рекомендую терминал.

## Вводные данные

- Старый домен: `example.old`.
- Новый домен: `example.new`.

## Изменение домена

- Изменить домен в `/etc/hosts`:

```bash
sed -i 's|example.old|example.new|g' '/etc/hosts'
```

- Изменить домен в `/etc/resolv.conf`:

```bash
sed -i 's|example.old|example.new|g' '/etc/resolv.conf'
```

- Изменить домен в `/etc/postfix/main.cf`:

```bash
sed -i 's|example.old|example.new|g' '/etc/postfix/main.cf'
```

- Перезагрузить PVE:

```bash
shutdown -r now
```

### Команда в одну строку

```bash
o='example.old'; n='example.new'; f=('hosts' 'resolv.conf' 'postfix/main.cf'); for i in "${f[@]}"; do sed -i "s|${o}|${n}|g" "/etc/${i}"; done
```

#### Параметры

- `o` - старый домен.
- `n` - новый домен.
