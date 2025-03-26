set fish_greeting

set -gx EDITOR "nvim"
set -gx VISUAL "nvim" # use vim to edit command buffer
set -gx PAGER "bat --plain"
set -gx JJ_CONFIG "$HOME/.jj_config.toml"
set -gx BAT_THEME "base16"
set -gx MANPAGER "nvim +Man!" # use neovim to read man pages
set -gx ERL_AFLAGS "-kernel shell_history enabled" # enable history in iex sessions
set -gx HOMEBREW_NO_AUTO_UPDATE "1"


set -gx FZF_DEFAULT_COMMAND 'fd --type file'
set -gx FZF_DEFAULT_OPTS "--cycle --color=16,fg:white:dim,bg:-1,preview-fg:-1,preview-bg:-1,hl:yellow:regular,fg+:yellow:regular:bold,bg+:-1,gutter:-1,hl+:yellow:regular:bold,query:white,info:magenta,border:magenta:dim,prompt:magenta,marker:cyan:bold,spinner:magenta,disabled:gray,header:gray,pointer:yellow --bind ctrl-n:next-history --bind ctrl-p:prev-history --bind ctrl-o:toggle-all --bind ctrl-delete:backward-kill-word --bind home:first --bind end:last --pointer='█'"
set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"

# recommended when installing sqlite, but might not need anymore
set -gx LDFLAGS "-L/opt/homebrew/opt/openssl@1.1/lib"
set -gx CPPFLAGS "-I/opt/homebrew/opt/openssl@1.1/include"

fish_add_path "$HOME/.bin"
fish_add_path "$HOME/.cargo/bin" # rust
fish_add_path "/opt/homebrew/bin/"
fish_add_path "/usr/local/bin"


if status is-interactive
    bind \cV edit_command_buffer

    jj util completion fish | source
    fzf --fish | source
    direnv hook fish | source
    fnm env --use-on-cd --shell fish | source

    abbr v "nvim"
    abbr vi "nvim"
    abbr vim "nvim"
    abbr n 'nnn -CReorA'
    abbr pn 'ping www.google.com -c 1'
    abbr j 'just'
    abbr g 'git'
    abbr we 'watchexec'
    abbr d 'date -r'
    abbr w 'watch --color --interval 5'

    abbr cdg 'cd ~/Projects/giga'
    abbr cds 'cd ~/Projects/sugo'

    abbr dots "git --git-dir $HOME/.dotfiles/ --work-tree $HOME"
    abbr sdots "git --git-dir $HOME/.dotfiles.secret/ --work-tree $HOME"

    abbr vi 'nvim'
    abbr vim 'nvim'

    abbr kssh 'kitty +kitten ssh'

    abbr cdbe 'cd ~/Projects/cinderblock'
    abbr cdber 'cd ~/Projects/cinderblock-ro'
    abbr cdos 'cd ~/Projects/ops-scripts'
    abbr cdfe 'cd ~/Projects/mosaic'
    abbr cdoa 'cd ~/Projects/cinderblock-openapi'
    abbr cdt 'cd ~/Projects/terraform'
    abbr cdbp 'cd ~/Projects/mosaic/packages/blueprint'

    alias pw 'watchexec --restart --exts py,html,css --ignore "**/__snapshots__/**" --clear --'
    alias pwt 'fd --type file --extension py test_ tests/ | fzf --multi --history /tmp/fzf-history-pytest | xargs watchexec --restart --exts py,html,css --ignore "**/__snapshots__/**" --clear -- pytest -n0'
    alias pwtc 'fd --type file --extension py test_ tests/ | fzf --multi --history /tmp/fzf-history-pytest | xargs watchexec --restart --exts py,html,css --ignore "**/__snapshots__/**" --clear -- pytest -n0 --create-db'
    alias pwtp 'fd --type file --extension py test_ tests/ | fzf --multi --history /tmp/fzf-history-pytest | xargs watchexec --restart --exts py,html,css --ignore "**/__snapshots__/**" --clear -- pytest'

    source "$HOME/.config/fish/functions/newline.fish"
end
