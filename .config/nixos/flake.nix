{
  description = "A simple NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # Allows opting into new versions for one package without needing to update
    # the entire system at once. You can update just this via:
    # `nix flake update nixpkgs-master`
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-master,
    neovim-nightly-overlay,
    ...
  } @ inputs: {
    nixosConfigurations = {
      thinkpad = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux:";
        specialArgs = {
          inherit nixpkgs-master;
          inherit neovim-nightly-overlay;
        };
        modules = [
          ./common/configuration.nix
          ./hosts/thinkpad/hardware-configuration.nix
          ./hosts/thinkpad/configuration.nix
        ];
      };

      macbook = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux:";
        specialArgs = {
          inherit nixpkgs-master;
          inherit neovim-nightly-overlay;
        };
        modules = [
          /etc/nixos/apple-silicon-support
          ./common/configuration.nix
          ./hosts/macbook/hardware-configuration.nix
          ./hosts/macbook/configuration.nix
        ];
      };
    };
  };
}
