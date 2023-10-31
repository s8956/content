---
title: 'Получение и установка MS Office 2021 LTSC'
description: ''
images:
  - 'https://images.unsplash.com/photo-1649433391420-542fcd3835ea'
cover:
  crop: 'entropy'
  fit: 'crop'
categories:
  - 'windows'
  - 'scripts'
tags:
  - 'office'
  - 'cmd'
  - 'активация'
authors:
  - 'KitsuneSolar'
sources:
  - 'https://learn.microsoft.com/en-us/office/troubleshoot/installation/how-to-download-office-install-not-in-vlsc'
license: 'CC-BY-SA-4.0'
complexity: '0'
toc: 1
comments: 1

date: '2023-09-26T20:17:18+03:00'
hash: 'dd5a3e1a596b20d59070b2a065f99f3283ef3e90'
uuid: 'dd5a3e1a-596b-50d5-b070-b2a065f99f32'
slug: 'dd5a3e1a-596b-50d5-b070-b2a065f99f32'

draft: 0
---

MS Office является самым популярным набором приложений для офисной работы. На момент написания этой статьи, актуальной версией MS Office является 2021. Её можно купить в магазине. Но здесь я расскажу как получить актуальную версию MS Office 2021 LTSC с серверов Microsoft.

<!--more-->

MS Office 2021 LTSC просто так не купить, это программное обеспечение распространяется для организаций по соглашению о корпоративном лицензировании. MS Office 2021 LTSC поддерживает устройства только с операционными системами **MS Windows 10** или **MS Windows 11**.

## Получение MS Office 2021 LTSC

Для получения установочного дистрибутива необходимо выполнить подготовительные шаги:

1. Скачать и запустить [Office Deployment Tool](https://www.microsoft.com/download/details.aspx?id=49117).
2. Во время установки, выбрать директорию для распаковки **Office Deployment Tool**. В эту директорию будет в дальнейшем загружен установочный дистрибутив MS Office 2021 LTSC.
3. После завершения процесса установки, открыть консоль и перейти в директорию (`cd <path>`), куда был установлен Office Deployment Tool.
4. В корне директории Office Deployment Tool создать файл `office.2021.xml` следующего содержания:

{{< file "office.2021.xml" >}}

Далее, в консоли выполните команду `setup.exe /download office.2021.xml`. Команда запускает формирование и скачивание установочного дистрибутива MS Office 2021 LTCS с серверов Microsoft. Команда может не отображать процесс своей работы. После завершения команды, консоль вернёт управление пользователю, тем самым можно контролировать завершение получения установочного дистрибутива.

## Установка полной версии MS Office 2021 LTSC

После получения установочного дистрибутива MS Office 2021 LTCS, в той же консоли необходимо выполнить команду `setup.exe /configure office.2021.xml`. Эта команда запускает процесс установки **полной версии** MS Office 2021 LTCS на компьютер пользователя со всеми дополнительными модулями.

## Установка минимальной версии MS Office 2021 LTSC

Для администраторов, которые хотят установить на компьютер пользователя только самые необходимые компоненты (Access, Excel, Outlook, PowerPoint и World), предлагаю следующий конфигурационный файл:

{{< file "office.2021.minimal.xml" >}}

Сохраните его под названием `office.2021.minimal.xml` и запустите процесс установки при помощи команды `setup.exe /configure office.2021.minimal.xml`.

## Создание собственных конфигураций

Приведённые выше XML-файлы это файлы конфигураций. Их можно создавать самому при помощи веб-инструмента [Office Deployment Center](https://config.office.com/deploymentsettings). На странице создания конфигураций укажите необходимые параметры и настройки, и нажмите кнопку {{< key "Импорт" >}}.

Полученный XML-файл можно указывать в командах `setup.exe /download <XML_FILE>` и `setup.exe /configure <XML_FILE>` для конфигурирования установочного дистрибутива.

## Активация при помощи KMS-сервера

Если в сети вашей организации присутствует KMS-сервер, установленный MS Office 2021 можно активировать при помощи этого сервера.

{{< alert "tip" >}}
Подобным способом активируются следующие версии MS Office:

- Microsoft Office 2016 Volume License Pack.
- Microsoft Office 2019 Volume License Pack.
- Microsoft Office LTSC 2021 Volume License Pack.
{{< /alert >}}

Для активации MS Office при помощи KMS-сервера, необходимо открыть консоль и перейти в директорию с файлом `ospp.vbs`. Обычно, этот файл находится в директории `\Program Files\Microsoft Office\Office16`. После того, как консоль будет находится в необходимой директории с файлом `ospp.vbs`, можно выполнять следующие команды в зависимости от задачи.

1. Указать адрес KMS-сервера для клиента MS Office:

```terminal {os="windows"}
cscript ospp.vbs /sethst:kms.example.com
```

2. Указать нестандартный порт (`1689`) KMS-сервера:

```terminal {os="windows"}
cscript ospp.vbs /setprt:1689
```

3. Выполнить активацию MS Office на KMS-сервере:

```terminal {os="windows"}
cscript ospp.vbs /act
```

4. Узнать текущий статус активации MS Office:

```terminal {os="windows"}
cscript ospp.vbs /dstatusall
```

В интернете можно найти открытые KMS-серверы для нелегальной активации MS Office. Но подобные действия имеют противоправный характер. {{< emoji ":winking_face_with_tongue:" >}}