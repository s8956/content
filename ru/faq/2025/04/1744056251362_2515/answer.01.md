Зеркало пакетов Debian меняется в файле `/etc/apt/sources.list`. Можно вручную отредактировать файл или воспользоваться утилитой `sed`.

- Изменить зеркало `mirror.old` на `mirror.new`:

```bash
o='mirror.old'; n='mirror.new'; f=('sources.list'); for i in "${f[@]}"; do sed -i "s|${o}|${n}|g" "/etc/apt/${i}"; done
```

## Примеры

- Изменить зеркало `mirror.yandex.ru` на универсальное `deb.debian.org`:

```bash
o='mirror.yandex.ru'; n='deb.debian.org'; f=('sources.list'); for i in "${f[@]}"; do sed -i "s|${o}|${n}|g" "/etc/apt/${i}"; done
```

- Изменить зеркало `mirror.yandex.ru` на `ftp.ru.debian.org`:

```bash
o='mirror.yandex.ru'; n='ftp.ru.debian.org'; f=('sources.list'); for i in "${f[@]}"; do sed -i "s|${o}|${n}|g" "/etc/apt/${i}"; done
```

- Изменить зеркало `ftp.ru.debian.org` на `ftp.br.debian.org`:

```bash
o='ftp.ru.debian.org'; n='ftp.br.debian.org'; f=('sources.list'); for i in "${f[@]}"; do sed -i "s|${o}|${n}|g" "/etc/apt/${i}"; done
```

### Параметры

- `o` - старое зеркало.
- `n` - новое зеркало.
