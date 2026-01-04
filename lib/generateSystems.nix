nixpkgs: specialArgs: systemsFolder: modulesFolder: patchesFolder:
let
  inherit (nixpkgs) lib;
  recursivelyImport = import ./recursivelyImport.nix { inherit lib; };

  getPatches =
    dir:
    if builtins.pathExists dir then
      (map (file: dir + "/${file}") (builtins.attrNames (builtins.readDir dir)))
    else
      [ ];
in
(lib.pipe systemsFolder [
  builtins.readDir
  (lib.filterAttrs (_: v: v == "directory"))
  (builtins.mapAttrs (
    Folder: _:
    let
      main = (systemsFolder + "/${Folder}/configuration.nix");
      entrypoint = import main {
        config = { };
        pkgs = { };
        inherit lib;
      };
      pkgs = (import nixpkgs { inherit (entrypoint.nixpkgs) hostPlatform; });
      lib = nixpkgs.lib;
    in
    let
      nixpkgs' = lib.mkIf (builtins.length (getPatches patchesFolder) > 0) (
        pkgs.applyPatches {
          name = "nixpkgs-snorked";
          src = nixpkgs;
          patches = getPatches patchesFolder;
        }
      );

      nixpkgs = lib.mkIf (builtins.isNull nixpkgs') (
        import "${nixpkgs'}/flake.nix".outputs { self = "${nixpkgs'}/flake.nix".outputs; }
      );
    in
    lib.nixosSystem {
      inherit (entrypoint) system;

      specialArgs = (if builtins.isAttrs specialArgs then specialArgs else { });

      modules = [
        main
      ]
      ++ (
        if (!(builtins.isNull modulesFolder)) && builtins.pathExists modulesFolder then
          recursivelyImport [
            (lib.mkIf (!(builtins.isNull modulesFolder) && builtins.pathExists modulesFolder) modulesFolder)
          ]
        else
          [ ]
      );
    }
  ))
])
