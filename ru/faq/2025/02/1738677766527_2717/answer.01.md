Ошибка возникает из-за того, что {{< tag "VMware" >}} не предоставляет интерфейс этого уровня для доступа к ядру Linux. Для решения этой проблемы необходимо добавить `i2c-piix4` в чёрный список модулей ядра:

```bash
echo 'blacklist i2c-piix4' > '/etc/modprobe.d/piix4-blacklist.conf' && update-initramfs -u -k all
```
