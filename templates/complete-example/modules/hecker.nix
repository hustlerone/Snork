{ lib, pkgs, ... }:
{
  services = {
    kmscon = {
      enable = lib.mkDefault true;
      useXkbConfig = true;
      hwRender = true;

      extraConfig = ''
        mouse
      '';
    };
  };

  console.useXkbConfig = true;
}
