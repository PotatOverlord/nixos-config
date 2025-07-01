{ pkgs, ... }:
{
  home.packages = with pkgs; [ nixd ];
  programs.nixvim.plugins.lsp.servers.nixd = {
    enable = true;
  };
}
