{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    kitty.nix 
  ];
  programs.kitty.enable = true;
  programs.kitty.settings = {
    background.opacity = lib.mkForce "0.85";
    modify_font = "cell_width 90%";
  };
}
