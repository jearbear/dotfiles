{
  config,
  pkgs,
  nixpkgs-master,
  neovim-nightly-overlay,
  ...
}: let
  pkgs-master = import nixpkgs-master {
    system = "x86_64-linux";
  };
in {
  # Use latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
