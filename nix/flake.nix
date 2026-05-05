{
  description = "Home Manager configuration of daniel.luna";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-tmux35a.url = "github:NixOS/nixpkgs/5b5b46259bef947314345ab3f702c56b7788cab8"; # NOTE: found via https://lazamar.co.uk/nix-versions/?channel=nixpkgs-25.05-darwin&package=tmux
  };

  outputs = { nixpkgs, home-manager, nixpkgs-tmux35a, ... }:
    let
      mkHome = system:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          extraSpecialArgs = {
            tmux35pkgs = nixpkgs-tmux35a.legacyPackages.${system};
          };
          modules = [ ./home.nix ];
        };
    in {
      homeConfigurations = {
        dcluna-mac = mkHome "aarch64-darwin";
        dcluna-linux = mkHome "x86_64-linux";
      };
    };
}
