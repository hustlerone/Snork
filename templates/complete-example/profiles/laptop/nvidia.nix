{ config, lib, ... }:
# In this household we are only allowed to be extorted by NVIDIA!
{
  nixpkgs = {
    config = {
      allowUnfreePredicate =
        pkg:
        builtins.elem (lib.getName pkg) [
          "nvidia-x11"
          "nvidia-settings"
        ];
    };
  };

  hardware = {
    nvidia = {
      modesetting.enable = lib.mkDefault true;
      nvidiaSettings = true;
      open = true;

      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
      };
    };
  };

  services.xserver.videoDrivers = lib.mkIf config.hardware.nvidia.modesetting.enable [ "nvidia" ];
}
