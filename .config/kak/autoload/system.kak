# Ensure that we still load the standard set of plugins
nop %sh{
    mkdir -p "$kak_config/autoload"
    ln -s "$kak_runtime/autoload" "$kak_config/autoload/stdlib"
}
