{
  config,
  pkgs,
  nixpkgs-master,
  neovim-nightly-overlay,
  ...
}: {
  networking.hostName = "macbook";

  hardware.asahi.enable = true;

  boot.loader.efi.canTouchEfiVariables = false;
  boot.kernelParams = ["appledrm.show_notch=1"];

  # services.tlp = {
  #   enable = false;
  #   settings = {
  #     CPU_SCALING_GOVERNOR_ON_AC = "schedutil";
  #     CPU_SCALING_GOVERNOR_ON_BAT = "schedutil";
  #     START_CHARGE_THRESH_BAT0 = 40;
  #     STOP_CHARGE_THRESH_BAT0 = 80;
  #   };
  # };
  # powerManagement.powertop.enable = false;

  # Cap battery charge to 80%
  systemd.services.battery-threshold = {
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/bin/sh -c 'echo 80 > /sys/class/power_supply/macsmc-battery/charge_control_end_threshold'";
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.11"; # Did you read the comment?
}
