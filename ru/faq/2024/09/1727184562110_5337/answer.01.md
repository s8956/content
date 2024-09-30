Для поиска и выполнения различных действий с почтовыми ящиками у администратора должна быть группа `Discovery Management`. Чтобы добавить администратора в эту группу, необходимо выполнить следующую команду:

```powershell
Add-RoleGroupMember 'Discovery Management' -Member 'admin@domain.com'
```

Найти на резервном почтовом ящике `recovery@domain.com` письма для `user@domain.com` за временной период `20/06/2024 10:00 - 22/09/2024 14:00` и копировать их в почтовый ящик `user@domain.com` в директорию `Inbox`:

```powershell
Get-Mailbox 'recovery@domain.com' | Search-Mailbox -SearchQuery '(to:"user@domain.com") AND (received:20/06/2024 10:00..22/09/2024 14:00)' -TargetMailbox 'user@domain.com' -TargetFolder 'Inbox'
```

Найти на резервном почтовом ящике `recovery@domain.com` письма от `user@domain.com` за временной период `20/06/2024 10:00 - 22/09/2024 14:00` и копировать их в почтовый ящик `user@domain.com` в директорию `Sent Items`:

```powershell
Get-Mailbox 'recovery@domain.com' | Search-Mailbox -SearchQuery '(from:"user@domain.com") AND (received:20/06/2024 10:00..22/09/2024 14:00)' -TargetMailbox 'user@domain.com' -TargetFolder 'Sent Items'
```

{{< alert "tip" >}}
Для проверки корректности запроса можно использовать параметр `-EstimateResultOnly`, который позволяет оценить результаты запроса без выполнения каких-либо действий.

Параметр `-EstimateResultOnly` несовместим с параметром `-TargetMailbox`.
{{< /alert >}}

{{< alert "important" >}}
Для локализованной версии MS Exchange необходимо использовать ключи поиска на языке локализации. То есть, если установлена русская версия MS Exchange, то ключи поиска должны вводиться на русском языке.
{{< /alert >}}
