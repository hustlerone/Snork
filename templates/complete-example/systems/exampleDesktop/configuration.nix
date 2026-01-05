{
  pkgs,
  lib,
  ...
}:
# You see, I'm actually a moderator at r/unixporn. I know! I'm such a lady magnet!
# I would've riced my kernel so much with BORE and uhhhh other things!
# ..If it weren't for those evil bastards at #users:nixos.org telling me how stupid that sounded..
# They'll see how many more wenches i'll pull in after they see my zen xanmod ultrarice + hyprland + ironbar + one piece episode undecillion wallpaper!
{
  imports = [ ./hardware-configuration.nix ];

  boot = {
    loader = {
      grub = {
        # Yeah, it's legacy BIOS. Jealous of my heckin libreboot huh????
        # Too bad, im like mr robot guy now!

        device = "/dev/sda";
        configurationName = "Anonymous hack 1337";
        enable = true;
        efiSupport = false;
      };
    };
    kernelPackages = pkgs.linuxPackages_zen;
  };

  fileSystems = {
    "/" = {
      # Yeah! How about that huh? I bet this doesn't even work in the real world!
      device = "saittama_narto";
      fsType = "zfs";
    };
  };

  services.displayManager.ly.enable = true;

  # Yea so uhh.... i uhh..... have my epic hyprland config on home manager standalone!
  # I know, I'm a genius!
  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    hyprlock.enable = true;
    steam.enable = true;
  };

  nixpkgs = {
    config = {
      # Called it.
      config.allowBroken = true;

      allowUnfreePredicate =
        pkg:
        builtins.elem (lib.getName pkg) [
          "steam"
          "steam-unwrapped"
        ];
    };
  };

  system.stateVersion = "25.11";
  networking.hostId = "8425e349";
}
