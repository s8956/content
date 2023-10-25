---
title: 'Рекурсивное изменение прав доступа на файлы и директории'
description: ''
images:
  - 'https://images.unsplash.com/photo-1569235186275-626cb53b83ce'
categories:
  - 'terminal'
  - 'linux'
tags:
  - 'linux'
  - 'terminal'
  - 'chmod'
  - 'find'
authors:
  - 'KitsuneSolar'
license: 'CC-BY-SA-4.0'
complexity: '0'
toc: 1
comments: 1

date: '2021-05-09T20:15:26+03:00'
hash: '4a3b0a310d3d7a9bec077e3b4f80669e95545d6f'
uuid: '4a3b0a31-0d3d-5a9b-8c07-7e3b4f80669e'
slug: '4a3b0a31-0d3d-5a9b-8c07-7e3b4f80669e'

draft: 0
---

Права доступа к файлам и директориям является неотъемлемой частью любой операционной системы. И в этой статье описаны возможности по рекурсивной настройке этих прав доступа.

<!--more-->

Изменение прав доступа осуществляется при помощи команды `chmod`, рекурсивное при добавлении опции `-R`:

```sh
chmod -R MODE DIR
```

- `-R` - рекурсивный обход директорий и файлов.
- `MODE` - набор прав доступа для их установки.
- `DIR` - файл или директория, у которых необходимо установить определённые права доступа.

В итоге, команда должна выглядеть так:

```sh
chmod -R 755 /var/www/html
```

Но, стоит учитывать, что таким образом директории и файлы примут одинаковые права доступа. Чтобы избежать этого, можно воспользоваться командой `find`, которая отфильтрует директории и файлы друг от друга:

```sh
find /var/www/html -type d -exec chmod 755 {} \;
```

```sh
find /var/www/html -type f -exec chmod 644 {} \;
```

Команда `find` ищет директории (`-type d`) и файлы (`-type f`) и скармливает их команде `chmod`, а та, в свою очередь, уже расставляет права доступа. При использовании `-exec`, `chmod` выполняется для каждого найденного элемента поочерёдно. Можно оптимизировать и записать с использованием `xargs`:

```sh
find /var/www/html -type d -print0 | xargs -0 chmod 755
```

```sh
find /var/www/html -type f -print0 | xargs -0 chmod 644
```

При `xargs`, `chmod` выполняется сразу для нескольких записей одновременно, как сообщает **Daniel Miessler**:

{{< quote author="Daniel Miessler" url="https://danielmiessler.com/blog/linux-xargs-vs-exec/" >}}
This is where -exec breaks down and xargs shows its superiority. When you use -exec to do the work you run a separate instance of the called program for each element of input. So if find comes up with 10,000 results, you run exec 10,000 times. With xargs, you build up the input into bundles and run them through the command as few times as possible, which is often just once. When dealing with hundreds or thousands of elements this is a big win for xargs.
{{< /quote >}}

Если необходимо запустить рекурсивное изменение прав доступа начиная с текущей директории, то `/var/www/html` необходимо поменять на точку:

```sh
find . -type d -print0 | xargs -0 chmod 755
```

```sh
find . -type f -print0 | xargs -0 chmod 644
```
