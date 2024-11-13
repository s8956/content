# Content

Content for Hugo **s8956**.

## Install

```
git submodule add 'https://github.com/s8956/content.git' 'content'
```

## Update

```
git submodule update --recursive --remote --merge
```

## Uninstall

```
m='content'; git submodule deinit -f "${m}"; git rm -r --cached "${m}"; rm -rf ".git/modules/${m}"; rm -rf "${m}"
```
