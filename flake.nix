{
  description = "NixOS configuration framework that doesn't suck";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, ... }@inputs:
    let
      inherit (inputs) self nixpkgs treefmt;

      allArchitectures = nixpkgs.lib.systems.flakeExposed;

      forEachArchitecture =
        architectures: apply:
        nixpkgs.lib.genAttrs architectures (system: apply nixpkgs.legacyPackages.${system});

      pkgs = nixpkgs.lib.genAttrs allArchitectures (system: import nixpkgs { inherit system; });
    in
    {
      inherit (nixpkgs) formatter;

      generateSystems =
        {
          systemsFolder ? null,
          modulesFolder ? null,
          patchesFolder ? null,
          specialArgs ? null,
          profilesFolder ? null,
          profileDefinitions ? { },
        }:
        let
          inherit (nixpkgs) lib;

          allLists =
            attrSet:
            !builtins.any (x: x == false) (
              builtins.map (x: builtins.typeOf x == "list") (builtins.attrValues attrSet)
            );
        in
        assert lib.assertMsg (
          !(builtins.isNull systemsFolder) && (builtins.pathExists systemsFolder)
        ) "Attribute `systemsFolder` is not valid. Make sure the folder exists and/or is tracked.";

        assert lib.assertMsg (
          (builtins.isNull modulesFolder) || (builtins.pathExists modulesFolder)
        ) "Attribute `modulesFolder` is not valid path.";

        assert lib.assertMsg (
          (builtins.isNull patchesFolder) || (builtins.pathExists patchesFolder)
        ) "Attribute `patchesFolder` is not valid path.";

        assert lib.assertMsg (
          (builtins.isNull profilesFolder) || (builtins.pathExists profilesFolder)
        ) "Attribute `profilesFolder` is not valid path.";

        assert lib.assertMsg (
          (builtins.isNull profilesFolder)
          || (builtins.pathExists profilesFolder && (allLists profileDefinitions))
        ) "Attribute `profileDefinitions` is not an attribute set of attribute list.";

        import ./lib/generateSystems.nix nixpkgs specialArgs systemsFolder modulesFolder patchesFolder
          profilesFolder
          profileDefinitions;

      templates = {
        quick-start = {
          description = ''
            A minimal (example) configuration to get started.
          '';

          path = ./templates/quick-start;
        };

        real-world-example = {
          description = ''
            An example configuration that's closer to a real world application.
          '';

          path = ./templates/complete-example;
        };
      };
    };
}
