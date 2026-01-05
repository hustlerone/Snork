{ lib, ... }:
{
  # You see, back in my day, Mr Robot got 31337 h4ck3d by scary Anonymous hacker Richard Stallman using his signature™ Xbox 360 running Gentoo.
  # Restricting nix daemon access surely would've bought him 5 more minutes to pull the plug. SCARY!

  nix.settings.allowed-users = lib.mkForce [
    "root"
    "@wheel"
  ];
}
