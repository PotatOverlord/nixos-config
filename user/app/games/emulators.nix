{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
  dolphin-emu
  vbam
  mgba
  ];
}
