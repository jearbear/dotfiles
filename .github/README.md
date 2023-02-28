# setup

setup up a temporary alias

```bash
alias dots='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```

clone dotfiles into a bare repo

```bash
git clone --bare git@github.com:jearbear/dotfiles.git $HOME/.dotfiles
```

unpack dotfiles (this might fail if it would overwrite files)

```bash
dots checkout
```
