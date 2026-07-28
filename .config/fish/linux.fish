set -gx NNN_OPENER xdg-open

if status is-interactive
    abbr ne 'nvim ~/.config/nixos/common/configuration.nix'
    abbr nb 'sudo nixos-rebuild switch --flake ~/.config/nixos#$(hostname)'
    abbr nr --set-cursor 'nix run nixpkgs#%'
    abbr ns 'nix search nixpkgs'
    abbr npi --set-cursor 'nix path-info nixpkgs#%'
    abbr c qalc
    abbr --position anywhere copy wl-copy
    abbr --position anywhere paste wl-paste
end
