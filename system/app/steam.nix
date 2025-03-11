{ pkgs, ... }:

{
  hardware.opengl.driSupport32Bit = true;
  programs.steam.enable = true;
  enviroment.systemPackages = [ pks.steam ];
}
