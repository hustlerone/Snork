nixpkgs: specialArgs: systemsFolder: modulesFolder: patchesFolder: profilesFolder: profileDefinitions:
let
  inherit (nixpkgs) lib;
  recursivelyImport = import ./recursivelyImport.nix { inherit lib; };

  getPatches =
    dir:
    if !(builtins.isNull dir) && builtins.pathExists dir then
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
      haveProfile = (builtins.pathExists modulesFolder) && (builtins.hasAttr Folder profileDefinitions);
      assembledArgs = {
        profileDefinitions =
          if haveProfile then (lib.genAttrs (builtins.getAttr Folder profileDefinitions) (x: true)) else { };
      }
      // specialArgs;
    in
    let
      main = (systemsFolder + "/${Folder}/configuration.nix");
      lib = nixpkgs.lib;
      pkgs = import nixpkgs { system = "x86_64-linux"; };
    in
    let
      nixpkgs' =
        if (builtins.length (getPatches patchesFolder) > 0) then
          (pkgs.applyPatches {
            name = "nixpkgs-snorked";
            src = nixpkgs;
            patches = getPatches patchesFolder;
          })
        else
          nixpkgs;
    in

    ### I can't execute the flake here. Cry me a river.
    ### Your patched `lib` won't carry over. Not that it matters.

    import ./nixosSystem.nix nixpkgs' {
      specialArgs = assembledArgs;
      system = null;

      modules = [
        main
        {
          networking.hostName = lib.mkDefault (builtins.toString Folder);
        }
      ]
      ++ (recursivelyImport (
        (if (builtins.pathExists modulesFolder) then [ modulesFolder ] else [ ])
        ++ (
          if haveProfile then
            builtins.map (x: profilesFolder + "/${x}") (builtins.getAttr Folder profileDefinitions)
          else
            [ ]
        )
      ));
    }
  ))
])
