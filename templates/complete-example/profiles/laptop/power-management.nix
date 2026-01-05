{ lib, ... }:
# One time I almost went bankrupt because I did not set up some sort of power management.
# I actually exaggerated the situation a thousandfold, but why would you care?
{
  services.power-profiles-daemon.enable = lib.mkForce false;
  services.tlp = {
    enable = true;
    settings = {
      PCIE_ASPM_ON_BAT = "powersupersave";

      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

      START_CHARGE_THRESH_BAT1 = 50;
      STOP_CHARGE_THRESH_BAT1 = 60;
      RESTORE_THRESHOLDS_ON_BAT = 1;

      CPU_MIN_PERF_ON_AC = 30;
      CPU_MAX_PERF_ON_AC = 100;

      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 60;

      SOUND_POWER_SAVE_ON_AC = 0;
      BAY_POWEROFF_ON_BAT = 1;
    };
  };
}
