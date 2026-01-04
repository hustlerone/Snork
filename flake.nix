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
    in
    {
      inherit (nixpkgs) formatter;

      generateSystems =
        {
          systemsFolder ? null,
          modulesFolder ? null,
          patchesFolder ? null,
          specialArgs ? null,
        }:
        let
          inherit (nixpkgs) lib;
        in
        assert lib.assertMsg (
          !(builtins.isNull systemsFolder) && (builtins.pathExists systemsFolder)
        ) "Attribute `systemsFolder` is not valid. Make sure the folder exists and/or is tracked.";

        assert lib.assertMsg (
          (builtins.isNull modulesFolder) || (builtins.pathExists modulesFolder)
        ) "Attribute `modulesFolder` is not valid path.";

        import ./lib/generateSystems.nix nixpkgs specialArgs systemsFolder modulesFolder patchesFolder;
    };
}
