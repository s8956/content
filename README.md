# Content

Content for Hugo **SITE-0003**.

## Install

```
git submodule add 'https://github.com/site-0003/content.git' 'content'
```

## Update

```
git submodule update --recursive --remote --merge
```

## Uninstall

```
m='content'; git submodule deinit -f "${m}"; git rm -r --cached "${m}"; rm -rf ".git/modules/${m}"; rm -rf "${m}"
```
