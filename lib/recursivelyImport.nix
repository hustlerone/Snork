{ lib }:

let
  expandIfFolder =
    elem:
    if !builtins.isPath elem || builtins.readFileType elem != "directory" then
      [ elem ]
    else
      lib.filesystem.listFilesRecursive elem;

in
list:
builtins.filter
  # Filter out any path that doesn't look like `*.nix`. Don't forget to use
  # toString to prevent copying paths to the store unnecessarily
  (elem: !builtins.isPath elem || lib.hasSuffix ".nix" (toString elem))
  # Expand any folder to all the files within it.
  (lib.concatMap expandIfFolder list)
