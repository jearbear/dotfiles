{
  description = "A simple NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # Allows opting into new versions for one package without needing to update
    # the entire system at once. You can update just this via:
    # `nix flake update nixpkgs-master`
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-master,
    ...
  } @ inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux:";
      specialArgs = {inherit nixpkgs-master;};
      modules = [
        ./hardware-configuration.nix
        ./configuration.nix
      ];
    };
  };
}
