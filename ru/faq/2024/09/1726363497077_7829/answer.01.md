Для удаления файлов `sync-conflict` можно воспользоваться следующей командой:

```bash
find . -name '*.sync-conflict-*' -print0 | xargs -0 rm
```
