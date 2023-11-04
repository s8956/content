Переименовать компьютер можно при помощи cmdlet'а `Rename-Computer`:

```powershell
Rename-Computer -NewName 'PCName01'
```

И перезагрузить компьютер:

```powershell
Restart-Computer
```

Если компьютер находится в доменной сети, необходимо указать учётные данные администратора домена:

```powershell
Rename-Computer -NewName 'PCName01' -DomainCredential 'DomainName\Admin01'
```
