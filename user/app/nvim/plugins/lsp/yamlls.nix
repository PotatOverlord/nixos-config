{ pkgs, ... }:
{
  home.packages = with pkgs; [ yaml-language-server ];

  programs.nixvim.lsp.servers.yamlls = { 
    enable = true;
  };
}
