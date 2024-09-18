Для того, чтобы переместить виртуальную машину со старого VMware ESXi на новый, необходимо:

- Включить SSH на обоих ESXi (*Host / Actions / Services / Enable SSH*).
- Проверить, включён ли порт SSH (`22`) в брандмауэре на обоих ESXi (*Networking / Firewall rules*).
- Зайти по SSH на старый ESXi, где находится виртуальная машина и ввести следующую команду:

```bash
scp -r '/vmfs/volumes/datastore1/vm_example' 'root@192.168.11.22:/vmfs/volumes/datastore1/'
```

Где:

- `vm_example` - директория виртуальной машины.
- `root@192.168.11.22` - логин и IP-адрес нового ESXi, на который необходимо переместить виртуальную машину.
- `/vmfs/volumes/` - путь к датасторам.
