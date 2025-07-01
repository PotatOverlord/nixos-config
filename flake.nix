{
  description = "Every day I get closer to eating my computer and never having to look at an error ever again";

  outputs = { self, nixpkgs, home-manager,  ... }@inputs:
    let 
      systemSettings = {
        system = "x86_64-linux";
        hostname = "cheese";
        profile = "cheese";
        timezone = "Europe/London";
        locale = "en_GB.UTF-8";
        bootMountPath = "/boot";
        bootMode = "uefi";
        gpuType = "intel";
        root = "sda";
        aux = "";
      };

      userSettings = rec {
        username = "tater";
        name = "Potato Overlord";
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

      #pkgs = nixpkgs.legacyPackages.${systemSettings.system};
      pkgs = pkgs-unstable;
      lib = nixpkgs.lib;
    in
    {

      nixosConfigurations = {
        system =  lib.nixosSystem {
          system = systemSettings.system;
          modules = [
            (./. + "/profiles" + ("/" + systemSettings.profile) + "/configuration.nix")
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
            #inputs.nixvim.homeManager.nixvim
          ];
          extraSpecialArgs = {
            inherit systemSettings;
            inherit userSettings;
            inherit inputs;
            inherit pkgs-stable;
            inherit pkgs-unstable;
            #inherit nixvim;
          };
        };
      };
    };

  inputs = {
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-25.05";

    home-manager-unstable = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-stable = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland/v0.49.0?submodules=true";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:nix-community/stylix";

  };
}
