{
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  fileSystems = {
    # I'm making this up. This is only an example!
    "/" = {
      device = "/dev/sda2";
      fsType = "ext4";
    };
  };

  # What do you mean that I should be using nix-minecraft?
  # I'm having enough on my plate already by setting this config up!
  services.minecraft-server = {
    enable = true;
    eula = true;
    openFirewall = true;
  };

  # NO!!! NOOO NOONOO!O!O!!O!!!!!!!!
  # MR . Stallman. .. He will be AngrY.
  # You have been warned, kid. You will get hacked.
  # We are anonymous. We do not forgive
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.11";
}
