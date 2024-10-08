---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'PowerShell: Сжатие видео при помощи FFmpeg'
description: ''
images:
  - 'https://images.unsplash.com/photo-1574717024653-61fd2cf4d44d'
categories:
  - 'windows'
  - 'terminal'
  - 'scripts'
tags:
  - 'powershell'
  - 'ffmpeg'
authors:
  - 'KaiKimera'
sources:
  - 'https://github.com/pkgstore/pwsh-ffmpeg'
  - 'https://trac.ffmpeg.org/wiki'
  - 'https://evanhahn.github.io/ffmpeg-buddy/'
  - 'http://wiki.rosalab.ru/ru/index.php/FFmpeg'
license: 'CC-BY-SA-4.0'
complexity: '0'
toc: 1
comments: 1

# -------------------------------------------------------------------------------------------------------------------- #
# DATE
# -------------------------------------------------------------------------------------------------------------------- #

date: '2023-10-22T17:06:44+03:00'
publishDate: '2023-10-22T17:06:44+03:00'
lastMod: '2023-10-22T17:06:44+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '2a73410a6611f70c1ab4dc8cc8998146fb869da5'
uuid: '2a73410a-6611-570c-9ab4-dc8cc8998146'
slug: '2a73410a-6611-570c-9ab4-dc8cc8998146'

draft: 0
---

Когда то в далёкой далёкой галактике... Ко мне на работе обратились с просьбой как то уменьшить видео, записанное на камеру в формате `.mov`. Естественно, я воспользовался библиотекой {{< tag "FFmpeg" >}}. Но скрипт автоматизации решил написать только сейчас...

<!--more-->

Скрипт прост как лапоть. Состоит из небольшого количества вводных параметров, большинство из которых изменять не требуется. Предназначен скрипт для быстрого пакетного конвертирования файлов видео из одного формата в другой, в основном, с целью уменьшения размера. Скрипт не предназначен для сложного редактирования видео!

## Параметры

- `-F` `-Files` - массив входящих файлов.
- `-CV` `-vCodec` - видео кодек, используемый для конвертации. По умолчанию: `libx265`. Поддерживаемые кодеки:
  - `'libx264'` - кодек "H.264".
  - `'libx265'` - кодек "H.265".
  - `'libvpx-vp9'` - кодек "VP9" ("WebM").
  - `'libaom-av1'` - кодек "AV1".
- `-CA` `-aCodec` - аудио кодек, используемый для конвертации. По умолчанию: `copy`. Поддерживаемые кодеки:
  - `'libfdk_aac'` - кодек "Fraunhofer FDK AAC".
  - `'aac'` - кодек "FFmpeg AAC".
  - `'libmp3lame'` - кодек "FFmpeg MP3".
- `-R` `-Framerate` - частота кадров выходящего файла (FPS). Сжатие кадров с учётом движения, где сцены движения кодируются с меньшим качеством, чем статичные сцены, что субъективно приводит к восприятию, как качественного, ибо визуально человек различает больше деталей в неподвижных объектах, чем в движущихся. Если параметр не указан, то значение берётся из входящего файла.
- `-C` `-CRF` - постоянный коэффициент потока (Constant Rate Factor). Это режим кодирования для кодеков "H.264" и "H.265" с постоянным воспринимаемым качеством, осуществляемый с помощью настройки качества (и управления скоростью). Если параметр не указан, то значение берётся по умолчанию, обычно это `28` при кодеке `libx265` и `23` при `libx264`.
- `-P` `-Preset` - пресеты. Это набор параметров, которые обеспечивают определённую скорость кодирования с степень сжатия. У каждого кодека видео свой набор пресетов. Нужно смотреть [документацию](https://trac.ffmpeg.org/wiki).
- `-EXT` `-Extension` - расширение выходящих файлов.

## Примеры

Конвертировать файлы `file_01.mov`, `file_02.mov` и `file_03.mov` в формат `mp4`:

```terminal {os="windows"}
Compress-Video -F 'file_01.mov', 'file_02.mov', 'file_03.mov'
```

Пакетная конвертация всех файлов с расширением `.mov` в формат `mp4`:

```terminal {os="windows"}
Compress-Video -F '*.mov'
```

## Алгоритм работы

Скрипт предназначен для быстрого пакетного преобразования файлов видео из одного формата в другой.

{{< alert "important" >}}
Для работы скрипта необходим файл `ffmpeg.exe`, архив которого можно скачать с сайта [gyan.dev](https://www.gyan.dev/ffmpeg/builds/), распаковать и разместить рядом с файлом скрипта или в любую дочернюю директорию. Скрипт сам найдёт файл `ffmpeg.exe` и начнёт его использовать.
{{< /alert >}}

## Скрипт

{{< gh-repo "pkgstore/pwsh-ffmpeg" >}}
