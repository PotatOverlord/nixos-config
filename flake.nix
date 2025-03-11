{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let 
      systemSettings = {
        system = "x86_64-linux";
        hostname = "cheese";
        profile = "laptop";
        timezone = "Europe/London";
        locale = "en_GB.UTF-8";
        bootMountPath = "/boot";
        gpuType = "intel";
      };

      userSettings = rec {
        username = "tater";
        name = "Potato Overlord";
        dotfilesDir = "~/nixos-dotfiles/";
        theme = "atelier-sulphurpool";
        browser = "qutebrowser";
        term = "alacritty";
        font = "Intel One Mono";
        fontPkg = pkgs.intel-one-mono;
        editor = "vim";
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
          ];
          specialArgs = {
            inherit pkgs;
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
          };
        };
      };
    };
}
