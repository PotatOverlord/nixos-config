{ pks, ... }:

{
  enviroment.systemPackages = [ pkgs.gamemode ];
  programs.gamemode.enable = true;
}
