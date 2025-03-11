{ inputs, pkgs, lib, ... }: let
  pkgs-hyprland = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports = [ ./wayland.nix
              ./pipewire.nix
              ./dbus.nix
              ./fonts.nix
            ];

  programs = {
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      xwayland = {
        enable = true;
      };
      portalPackage = pkgs-hyprland.xdg-desktop-portal-hyprland;
    };
  };
  services.xserver.excludePackages = [ pkgs.xterm ];
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd Hyprland";
        user = "tater";
      };
    };
  };

  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal";
    TTYReset = true;
    TTYHangup = true;
    TTYVTDisallocate = true;
  };

}
