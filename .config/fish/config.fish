set fish_greeting

set -gx EDITOR nvim
set -gx VISUAL nvim # use vim to edit command buffer
set -gx PAGER "bat --plain"
set -gx JJ_CONFIG "$HOME/.jj_config.toml"
set -gx BAT_THEME base16
set -gx MANPAGER "nvim +Man!" # use neovim to read man pages
set -gx ERL_AFLAGS "-kernel shell_history enabled" # enable history in iex sessions

set -gx XCURSOR_THEME Breeze_Snow
set -gx XCURSOR_SIZE 48

set -gx FZF_DEFAULT_COMMAND 'fd --type file'
set -gx FZF_DEFAULT_OPTS "--cycle --color=16,fg:white:dim,bg:-1,preview-fg:-1,preview-bg:-1,hl:yellow:regular,fg+:yellow:regular:bold,bg+:-1,gutter:-1,hl+:yellow:regular:bold,query:white,info:magenta,border:magenta:dim,prompt:magenta,marker:cyan:bold,spinner:magenta,disabled:gray,header:gray,pointer:yellow --bind ctrl-n:next-history --bind ctrl-p:prev-history --bind ctrl-o:toggle-all --bind ctrl-delete:backward-kill-word --bind home:first --bind end:last --bind change:first --pointer='█' --preview-border=sharp"
set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
set -gx ESCDELAY 0 # for some cursed reason, FZF defaults to 100

set -gx KAKOUNE_POSIX_SHELL $(which dash)

fish_add_path "$HOME/.bin"
fish_add_path "$HOME/.cargo/bin" # rust

# Load OS-specific configs so that they can add more things to path
# that may be needed below.
set -l OS (uname | string lower)
test -f "$HOME/.config/fish/$OS.fish"; and source "$HOME/.config/fish/$OS.fish"

if status is-interactive
    bind \cV edit_command_buffer

    jj util completion fish | source
    fzf --fish | source
    direnv hook fish | source

    abbr v nvim
    abbr vi nvim
    abbr vim nvim
    abbr n 'nnn -CReoA'
    abbr pn 'ping www.google.com -c 1'
    abbr j just
    abbr g git
    abbr we watchexec
    abbr w 'watch --color --interval 5'
    abbr yd yt-dlp

    abbr cdg 'cd ~/Projects/giga'
    abbr cds 'cd ~/Projects/sugo'
    abbr cdn 'cd ~/Sync/PKM'

    abbr kssh 'kitty +kitten ssh'

    abbr yd yt-dlp

    # alias d "git --git-dir $HOME/.dotfiles/ --work-tree $HOME"
    abbr d "just --justfile ~/.dotfiles.justfile"

    source "$HOME/.config/fish/functions/newline.fish"
end
