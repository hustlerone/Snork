{
  description = "Real world Snork-based NixOS system.";
  inputs = {
    # I really like to play it safe with a stable channel
    # but I really would've liked if some PRs could be backported...

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    snork = {
      url = "github:hustlerone/Snork";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, ... }@inputs:
    {
      nixosConfigurations = inputs.snork.generateSystems {
        systemsFolder = ./systems;
        modulesFolder = ./modules;
        patchesFolder = ./patches; # If only.

        specialArgs = { inherit inputs self; };

        profilesFolder = ./profiles;
        profileDefinitions = {
          exampleLaptop = [
            "laptop"
          ];

          exampleServer = [
            "server"
          ];
        };
      };
    };
}
