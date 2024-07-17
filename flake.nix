{
  description = "Some custom modules and packages for my nixOS config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { ... }: {
    homeManagerModules = {
        jrnl.imports = [ ./jrnl.nix ];
      };
  };
}
