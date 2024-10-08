---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Работа с AWK'
description: ''
images:
  - 'https://images.unsplash.com/photo-1585776245991-cf89dd7fc73a'
categories:
  - 'linux'
  - 'terminal'
tags:
  - 'bash'
  - 'awk'
authors:
  - 'KaiKimera'
sources:
  - 'https://www.cyberciti.biz/faq/bash-scripting-using-awk'
license: 'CC-BY-SA-4.0'
complexity: '0'
toc: 1
comments: 1

# -------------------------------------------------------------------------------------------------------------------- #
# DATE
# -------------------------------------------------------------------------------------------------------------------- #

date: '2023-11-05T01:12:36+03:00'
publishDate: '2023-11-05T01:12:36+03:00'
lastMod: '2023-11-05T01:12:36+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: 'b373e06af7ee3caea093e31f3166569765ab3d65'
uuid: 'b373e06a-f7ee-5cae-8093-e31f31665697'
slug: 'b373e06a-f7ee-5cae-8093-e31f31665697'

draft: 1
---

{{< tag "AWK" >}} является весьма мощным языком программирования для обработки текстовых данных. Рассмотрим немного примеров по работе с AWK.

<!--more-->

## Переменные

### Переменные команд

- Ввод и обработка:
  - `NR` - номер записи.
  - `FNR` - номер записи в текущем файле.
  - `NF` - число полей в текущей записи. Последнее поле обозначается как `$NF`, предпоследнее поле `$(NF-1)`, и так далее.
  - `FILENAME` - имя обрабатываемого входного файла.
  - `FS` - разделитель полей записи на вводе.
  - `RS` - разделитель записей.
- Вывод:
  - `OFS` - разделитель полей записи на выводе (символ).
  - `ORS` - разделитель записей на выводе AWK-программы (символ).
  - `OFMT` - формат распечатки чисел.

### Переменные полей

- `$0` - вся строка текста (запись).
- `$1` - первое поле.
- `$2` - второе поле.
- `$n` - n-ное поле.

## Вывести содержимое текстового файла

```bash
awk '{ print }' /etc/passwd
```

...или...

```bash
awk '{ print $0 }' /etc/passwd
```

## Вывести определённое поле

Параметром `-F` задаётся разделитель для разбивки на поля (столбцы). Вывести первое (`$1`) поле:

```bash
awk -F':' '{ print $1 }' '/etc/passwd'
```

Отсортировать вывод:

```bash
awk -F':' '{ print $1 }' '/etc/passwd' | sort
```

## Сопоставление с шаблоном

Можно вывести строки файла, которые соответствуют заданному шаблону. Например, вывести все строки из лога Apache HTTPD, если код ошибки HTTP равен 500 (код ошибки в 9-ом поле на каждой строке запроса HTTP):

```bash
awk '$9 == 500 { print $0 }' '/var/log/httpd/access.log'
```

Часть, которая находится за пределами скобок `{ ... }` называется шаблоном, а часть внутри скобок `{ ... }` - действием. Можно использовать следующие операторы сравнения:

```bash
== != < > <= >= ?:
```

Стоит обратить внимание на особенности работы с шаблонами:

- Если шаблон отсутствует, то действие применяется ко всем строкам.
- Если действие не указано, то выводится вся строка.
- Если `print` используется отдельно, выводится вся строка.

Поэтому, следующие команды эквивалентны:

```bash
awk '$9 == 500' '/var/log/httpd/access.log'
awk '$9 == 500 { print }' '/var/log/httpd/access.log'
awk '$9 == 500 { print $0 }' '/var/log/httpd/access.log'
```

## Вывести строки с Tom, Jerry и Vivek

```bash
awk '/tom|jerry|vivek/' '/etc/passwd'
```

## Вывести первую строку файла

```bash
awk "NR==1{ print; exit }" '/etc/resolv.conf'
```

## Использование математики

Сумма всех чисел в поле:

```bash
awk '{total += $1} END {print total}' 'earnings.txt'
```

Командная оболочка не может вычислять числа с плавающей запятой, но AWK может:

```bash
awk 'BEGIN {printf "%.3f\n", 2005.50 / 3}'
```

## Работа с конвейером

Показать 10 часто используемых команд:

```terminal
history | awk '{print $2}' | sort | uniq -c | sort -rn | head

   172 ls
    144 cd
     69 vi
     62 grep
     41 dsu
     36 yum
     29 tail
     28 netstat
     21 mysql
     20 cat
```

Определение даты истечения срока действия домена:

```terminal
whois 'cyberciti.com' | awk '/Registry Expiry Date:/ { print $4 }'
2018-07-31T18:42:58Z
```

Можно записать все команды AWK в файл и вызывать их в терминале:

```bash
awk -f 'mypgoram.awk' 'input.txt'
```
