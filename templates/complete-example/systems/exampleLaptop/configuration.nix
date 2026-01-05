{
  pkgs,
  ...
}:
# GRRRRR!!!!!!! GNOME... I hate you! I will expose you...
# I will expose the GNOME conspiracy,
# where they make a DE that works all the time to undermine other desktop environments...
# how dare you make plasmashell look bad????? What's wrong with you???????
{
  imports = [
    ./hardware-configuration.nix
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };

  services.desktopManager = {
    gnome.enable = true;
  };

  services.displayManager.gdm.enable = true;

  hardware.nvidia.prime = {
    nvidiaBusId = "PCI:1:33:7";
    intelBusId = "PCI:0:1:0";
  };

  fileSystems = {
    # I'm making this up. This is only an example!
    "/" = {
      device = "/dev/sda2";
      fsType = "f2fs";
    };
  };

  # IP Hacker (FOR HIRE)
  # Progessional adobe ip hacker

  # Cyber Specialist
  # I have hacked into NASA's database before.
  # Have DDosed many people before, you may be next.
  # **(I KNOW PYTHON)**
  users.users.hacker = {
    isNormalUser = true;
    createHome = true;

    initialPassword = "toor";

    # Fuck! forgot to save those epic 31337 instagram reels! That's all I know!
    # I will never be mr robot super hacker at this rate...
    packages = with pkgs; [
      aircrack-ng
      ettercap
    ];
  };

  system.stateVersion = "25.11";
}
