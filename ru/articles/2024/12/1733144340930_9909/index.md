---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Работа с MySQL'
description: ''
images:
  - 'https://images.unsplash.com/photo-1457369804613-52c61a468e7d'
categories:
  - 'linux'
  - 'terminal'
  - 'inDev'
tags:
  - 'sql'
  - 'mysql'
authors:
  - 'KaiKimera'
sources:
  - ''
license: 'CC-BY-SA-4.0'
complexity: '0'
toc: 1
comments: 1

# -------------------------------------------------------------------------------------------------------------------- #
# DATE
# -------------------------------------------------------------------------------------------------------------------- #

date: '2024-12-02T15:59:02+03:00'
publishDate: '2024-12-02T15:59:02+03:00'
lastMod: '2024-12-02T15:59:02+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '8a40b3d045356aceb48072b94734b0f7726f9f22'
uuid: '8a40b3d0-4535-5ace-8480-72b94734b0f7'
slug: '8a40b3d0-4535-5ace-8480-72b94734b0f7'

draft: 0
---

Шпаргалка по работе с {{< tag "MySQL" >}}.

<!--more-->

## Пользователи

- Создать пользователя `DB_USER` с паролем `DB_PASSWORD`:

```bash
echo "CREATE USER 'DB_USER'@'127.0.0.1' IDENTIFIED BY 'DB_PASSWORD';" | mysql --user='root' --password
```

- Изменить пароль пользователя `DB_USER` на `DB_PASSWORD_NEW`:

```bash
echo "ALTER USER 'DB_USER'@'127.0.0.1' IDENTIFIED BY 'DB_PASSWORD_NEW';" | mysql --user='root' --password
```

- Удалить пользователя `DB_USER`:

```bash
echo "DROP USER 'DB_USER'@'127.0.0.1';" | mysql --user='root' --password
```

- Дать права `CREATE`, `ALTER`, `DROP`, `INSERT`, `UPDATE`, `DELETE`, `SELECT`, `REFERENCES` и `RELOAD` на базу данных `DB_NAME` пользователю `DB_USER`:

```bash
echo "GRANT CREATE, ALTER, DROP, INSERT, UPDATE, DELETE, SELECT, REFERENCES, RELOAD on DB_NAME.* TO 'DB_USER'@'127.0.0.1'; FLUSH PRIVILEGES;" | mysql --user='root' --password
```

- Дать все права на базу данных `DB_NAME` пользователю `DB_USER`:

```bash
echo "GRANT ALL ON DB_NAME.* TO 'DB_USER'@'127.0.01'; FLUSH PRIVILEGES;" | mysql --user='root' --password
```

- Дать все права на все базы данных пользователю `DB_USER`:

```bash
echo "GRANT ALL ON *.* TO 'DB_USER'@'127.0.01'; FLUSH PRIVILEGES;" | mysql --user='root' --password
```

- Отозвать права пользователя `DB_USER` у базы данных `DB_NAME`:

```bash
echo "REVOKE ALL ON DB_NAME FROM 'DB_USER'@'127.0.0.1';" | mysql --user='root' --password
```

- Показать права пользователя `DB_USER`:

```bash
echo "SHOW GRANTS FOR 'DB_USER'@'127.0.0.1';" | mysql --user='root' --password
```

## Базы данных

- Создать базу данных `DB_NAME` с кодировкой `utf8mb4` и сопоставлением `utf8mb4_unicode_ci`:

```bash
echo "CREATE DATABASE IF NOT EXISTS DB_NAME CHARACTER SET 'utf8mb4' COLLATE 'utf8mb4_unicode_ci';" | mysql --user='root' --password
```

- Изменить кодировку и сопоставление базы данных на `utf8mb4` и `utf8mb4_unicode_ci` соответственно:

```bash
echo "ALTER DATABASE DB_NAME CHARACTER SET 'utf8mb4' COLLATE 'utf8mb4_unicode_ci';" | mysql --user='root' --password
```

- Удалить базу данных `DB_NAME`:

```bash
echo "DROP DATABASE IF EXISTS DB_NAME;" | mysql --user='root' --password
```

## Резервное копирование

- Создать резервную копию базы данных `DB_NAME` и записать в файл `backup.sql.xz`:

```bash
f='backup.sql'; mysqldump --user='root' --password --single-transaction --databases 'DB_NAME' --result-file="${f}" && xz "${f}" && rm -f "${f}"
```

## Восстановление

- Удалить старую базу данных `DB_NAME`:

```bash
echo "DROP DATABASE IF EXISTS DB_NAME;" | mysql --user='root' --password
```

- Создать базу данных `DB_NAME` с кодировкой `utf8mb4` и сопоставлением `utf8mb4_unicode_ci`:

```bash
echo "CREATE DATABASE IF NOT EXISTS DB_NAME CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" | mysql --user='root' --password
```

- Дать все права на базу данных `DB_NAME` пользователю `DB_USER`:

```bash
echo "GRANT ALL PRIVILEGES ON DB_NAME.* TO 'DB_USER'@'127.0.01'; FLUSH PRIVILEGES;" | mysql --user='root' --password
```

- Восстановить данные в новую базу данных `DB_NAME` из файла `backup.sql.xz`:

```bash
f='backup.sql'; xz -d "${f}.xz" && mysql --user='root' --password --database='DB_NAME' < "${f}"
```
