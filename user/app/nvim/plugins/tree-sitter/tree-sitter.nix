{ pkgs, ... }:
{

  home.packages = with pkgs; [
    tree-sitter
  ];

  programs.nixvim.plugins.treesitter = {
    enable = true;

    #grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars ; [

    #];
  };
}
