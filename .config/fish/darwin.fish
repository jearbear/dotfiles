set -gx HOMEBREW_NO_AUTO_UPDATE 1

# recommended when installing sqlite, but might not need anymore
set -gx LDFLAGS "-L/opt/homebrew/opt/openssl@1.1/lib"
set -gx CPPFLAGS "-I/opt/homebrew/opt/openssl@1.1/include"

set -gx PNPM_HOME "$HOME/Library/pnpm"

fish_add_path /opt/homebrew/bin/
fish_add_path /usr/local/bin
fish_add_path "$PNPM_HOME"
fish_add_path /opt/homebrew/opt/coreutils/libexec/gnubin
fish_add_path /opt/homebrew/opt/grep/libexec/gnubin
fish_add_path /opt/homebrew/opt/gnu-sed/libexec/gnubin
fish_add_path /opt/homebrew/opt/findutils/libexec/gnubin

if status is-interactive
    source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish'

    fnm env --use-on-cd --shell fish | source

    abbr cdbe 'cd ~/Projects/cinderblock'
    abbr cdber 'cd ~/Projects/cinderblock-ro'
    abbr cdos 'cd ~/Projects/ops-scripts'
    abbr cdfe 'cd ~/Projects/mosaic'
    abbr cdoa 'cd ~/Projects/cinderblock-openapi'
    abbr cdt 'cd ~/Projects/terraform'
    abbr cdbp 'cd ~/Projects/mosaic/packages/blueprint'
    abbr cdn 'cd "/Users/jerry/Library/Mobile Documents/iCloud~md~obsidian/Documents/PKM"'

    alias pw 'watchexec --restart --exts py,html,css --ignore "**/__snapshots__/**" --clear --'

    function pwt -a pattern
        set pytest_args
        if test -n "$pattern"
            set pytest_args "-k $pattern"
        end

        fd --type file --extension py test_ tests/ | fzf --multi --history /tmp/fzf-history-pytest | xargs watchexec --restart --exts py,html,css --ignore "**/__snapshots__/**" --clear -- pytest -n0 $pytest_args
    end
    alias pwtp 'fd --type file --extension py test_ tests/ | fzf --multi --history /tmp/fzf-history-pytest | xargs watchexec --restart --exts py,html,css --ignore "**/__snapshots__/**" --clear -- pytest'

    source "$HOME/.config/fish/functions/newline.fish"
end
