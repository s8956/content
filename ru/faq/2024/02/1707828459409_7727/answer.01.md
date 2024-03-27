Чтобы создать общую директорию, в которой пользователи смогли размещать и читать файлы друг друга, необходимо выполнить следующие действия...


1. Создать группу, например, `shared`:

```terminal {os="linux", mode="root"}
groupadd 'shared'
```

2. Добавить эту группу к пользователям:

```terminal {os="linux", mode="root"}
for i in 'user_01' 'user_02' 'user_03'; do usermod -a -G 'shared' "${i}"; done;
```

3. Создать директорию `shared_dir` и применить к ней права:

```terminal {os="linux", mode="root"}
dir='shared_dir'; mkdir "${dir}" && chgrp 'shared' "${dir}" && chmod 2775 "${dir}";
```

{{< alert "tip" >}}
Бит `2` в `2775` указывает, что новые файлы и папки будут наследовать группу директории `shared_dir`.
{{< /alert >}}