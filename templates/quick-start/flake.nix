{
    description = "NixOS flake based on Snork";
    inputs = {
         nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
         snork = {
            url = "github:hustlerone/Snork";
            inputs.nixpkgs.follows = "nixpkgs";
         };
    };

    outputs = { self, ... }@inputs:{
        nixosConfigurations = inputs.snork.generateSystems {
            systemsFolder = ./systems;
        };
    };
}