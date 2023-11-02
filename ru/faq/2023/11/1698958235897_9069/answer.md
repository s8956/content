Для перевода PowerShell на кодировку UTF-8 нужно выполнить следующую команду:

```powershell
$OutputEncoding = [Console]::InputEncoding = [Console]::OutputEncoding = New-Object System.Text.UTF8Encoding
```

Стоит учитывать некоторые особенности:

- В UNIX-системах **PowerShell (Core) 7+** по умолчанию использует UTF-8.
- В ОС Windows шрифт в терминале должен поддерживать Unicode.
