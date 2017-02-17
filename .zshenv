export KEYTIMEOUT=1
export EDITOR=nvim
export PATH=./:~/.bin:~/.cargo/bin:$PATH
export BUILDDIR=/tmp/makepkg makepkg
export MAKEFLAGS='-j${nproc}'
export PKGEXT='.pkg.tar'
export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
