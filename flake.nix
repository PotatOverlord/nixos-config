{
  description = "Every day I get closer to eating my computer and never having to look at an error ever again";

  outputs = { self, nixpkgs, home-manager, disko, ... }@inputs:
    let 
      systemSettings = {
        system = "x86_64-linux";
        hostname = "lasagne";
        profile = "lasagne";
        timezone = "Europe/London";
        locale = "en_GB.UTF-8";
        bootMountPath = "/boot";
        bootMode = "uefi";
        gpuType = "nvidia";
        root = "sda";
        aux = "";
      };

      userSettings = rec {
        username = "tater";
        name = "Potato Overlord";
        gitName = "PotatOverlord";
        gitEmail = "160378192+PotatOverlord@users.noreply.github.com";
        dotfilesDir = "~/nixos-config/";
        theme = "atelier-sulphurpool";
        browser = "qutebrowser";
        term = "alacritty";
        font = "Intel One Mono";
        fontPkg = pkgs.intel-one-mono;
        editor = "nvim";
      };
      
      pkgs-stable = import inputs.nixpkgs-stable {
        system = systemSettings.system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
        };
      };

      pkgs-unstable = import inputs.nixpkgs-unstable {
        system = systemSettings.system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
        };
      };

      pkgs = nixpkgs.legacyPackages.${systemSettings.system};
      #lib = nixpkgs.lib;
    in
    {

      nixosConfigurations = {
        system =  nixpkgs.lib.nixosSystem {
          system = systemSettings.system;
          modules = [
            (./. + "/profiles" + ("/" + systemSettings.profile) + "/configuration.nix")
            disko.nixosModules.disko
          ];
          specialArgs = {
            inherit pkgs;
            inherit pkgs-stable;
            inherit pkgs-unstable;
            inherit systemSettings;
            inherit userSettings;
            inherit inputs;
          };
        };
      };
      homeConfigurations = {
        user =  home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            (./. + "/profiles/" + ("/" + systemSettings.profile) + "/home.nix")
          ];
          extraSpecialArgs = {
            inherit systemSettings;
            inherit userSettings;
            inherit inputs;
            inherit pkgs-stable;
            inherit pkgs-unstable;
            inherit pkgs;
          };
        };
      };
    };

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";

    home-manager-unstable = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-stable = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:danth/stylix";

  };
}
