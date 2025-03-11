{ config, pkgs, ... }:

{
  # For xwayland
  services.xserver = {
    enable = true;
    xkb = {
      layout = "uk";
      variant = "";
      options = "caps:escape";
    };
  };
}
