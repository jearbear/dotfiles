export KEYTIMEOUT=1
export EDITOR=nvim
export PAGER=less
export PATH=~/.bin:~/.cargo/bin:$PATH
export BUILDDIR=/tmp/makepkg makepkg
export MAKEFLAGS='-j${nproc}'
export PKGEXT='.pkg.tar'
export GPG_TTY=`tty`
