{ config, pkgs, ... }:

{
    environment.sessionVariables.NIXOS_OZONE_WL= "1";
  # For xwayland
  services.xserver = {
    enable = true;
    xkb = {
      layout = "gb";
      variant = "";
      options = "caps:escape";
    };
  };
}
