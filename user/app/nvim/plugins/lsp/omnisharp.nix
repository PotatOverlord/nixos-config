{ pkgs, ... }:
{
  home.packages = with pkgs; [ omnisharp-roslyn ];
  programs.nixvim.plugins.lsp.servers.omnisharp = {
    enable = true;
  };
}
