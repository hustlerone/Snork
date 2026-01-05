# Snork
A NixOS configuration framework to ease maintainability of your flakes.

It strives to be the simplest and most generic solution to the problems some of us face when making a multi-system NixOS flake configuration.

## Yet another framework? Why?
I tried to use other people's frameworks before writing my config from scratch. However, they were never good enough. Either they barely achieved anything or they got in your way and left you banging your head against the wall.

To cut it short, they all just sucked.

Since I've put so much work into it, I might as well generalise it for everyone.

## What does it do?
It allows you to spend more time writing code instead of importing modules.


In terms of features, it:

- Allows you to "painlessly" apply patches to nixpkgs from a folder
- Allows you to import all modules contained within a folder with no additional setup

It also tries to get out of your way as much as possible.

## Getting Started
The easiest way to get started is to initialise from a template as such:
```sh
nix flake init -t github:hustlerone/snork#quick-start
```

All templates are inside the `templates` folder in the tree.

## Usage of the framework

Assume we have a simple config and we want to add an N amount of systems.

Since it'll require us to write a lot of boilerplate in order to, at the very least, add those systems, we're going to use this framework.

We're going to use a folder structure like so in our configuration:

```
├── flake.nix
├── flake.lock
└── systems
    ├── configurationA
    │   ├── [...]
    │   └── configuration.nix
    ├── configurationB
    │   ├── [...]
    │   └── configuration.nix
    ├── configurationC
    │   ├── [...]	
    │   └── configuration.nix
  [...]
    │
    │
    └── lastConfiguration
        ├── [...]
        └── configuration.nix
```

And our flake, for the sake of this specific demonstration, will look like this:

```
{
    description = "demonstration flake for documentation";
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
```

And that would pretty much be it for this case. All the systems under the folder `systems` in our flake are properly set up and buildable just like God intended.

### One thing to note is that by default the hostnames will match that of the system folder's name. Please make sure your hostname matches your system entry, or else the system to be used might differ from what you expect since NixOS relies on hostname for deciding this.

As of now, these are the parameters used by the framework:

- `systemsFolder`
- `modulesFolder`
- `patchesFolder`
- `specialArgs`
- `profilesFolder`
- `profileDefinitions`

### `modulesFolder`

If you want modules shared across all systems in your config, you might want them inside a folder specified by `modulesFolder`. They will all be automatically imported.

### `patchesFolder`

If you want to patch nixpkgs (i.e: you want to test a PR and merge it into your config), place your git patch file(s) inside a folder specified by `patchesFolder`. All patches inside will be applied. **Currently, because of a limitation with flakes, the patches will be done assuming we're using an x86_64 system. If your platform differs, its functionality is not guaranteed.**

### `specialArgs`

If you want to add specialArgs for all systems (i.e: you want your flake input(s) be accessible from a module), then specify them so in `specialArgs`. They will be accessible as a module input.

### `profileDefinitions`

If you want separate modules per profiles (let's say you want a set of modules to be for servers only and the other set for laptops only), you shall put each profile in a subfolder of where  `profilesFolder` is specified, like so:

```
├── flake.nix
├── flake.lock
└── profiles
    ├── profile1
    │   └── [...]
    ├── profile2
    │   └── [...]
    ├── profile3
    │   └── [...]
  [...]
    │
    │
    └── lastProfile
        └── [...]

# There can be as many subfolders per profile as you'd like. 
# It'll search the entire subdirectory for .nix files.
```

To apply a profile to a system, you're going to fill out profileDefinitions as an attribute set of an attribute list, whose key is the system and the value is the set of profiles to be imported by the system, like so:
```
{
    exampleConfiguration1 = [ "profile1" "profile2" ];
    exampleConfiguration2 = [ "profile3" "profile1" ];
    exampleConfiguration3 = [ "lastProfile" ];
	...
	finalExample = [ "profile1" "profile2" ... "lastProfile"];
}
```

# Something's missing? This framework sucks?
Don't hesitate to open an issue or a PR.
