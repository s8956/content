1. [Скачать](https://www.intel.com/content/www/us/en/download/19347) `SetupChipset.exe` на компьютер.
2. Запустить терминал и в терминале перейти в директорию, где лежит `SetupChipset.exe`.
3. Ввести команду:

```batch
SetupChipset.exe -extract "%UserProfile%\Downloads\IntelSetupChipset"
```

Здесь переменная `%UserProfile%` содержит путь к профилю текущего пользователя. Поэтому, директория `IntelSetupChipset` с распакованным содержимым из `SetupChipset.exe` появится в загрузках вашего профиля.
