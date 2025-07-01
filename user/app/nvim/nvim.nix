{ config, pkgs, inputs, userSettings, ... }:

{

  
  home.packages = with pkgs; [
    vim
    neovim
  ];

  programs.nixvim = {
    defaultEditor = if (userSettings.editor == "nvim") then true else false;
    enable = true;
    #extraPlugins = with pkgs.vimPlugins; [
    #];


    colorschemes.base16 = {
      enable = true;
      autoLoad = true;
      colorscheme = {
        base00 = config.lib.stylix.colors.base00 ;
        base01 = config.lib.stylix.colors.base01 ;
        base02 = config.lib.stylix.colors.base02 ;
        base03 = config.lib.stylix.colors.base03 ;
        base04 = config.lib.stylix.colors.base04 ;
        base05 = config.lib.stylix.colors.base05 ;
        base06 = config.lib.stylix.colors.base06 ;
        base07 = config.lib.stylix.colors.base07 ;
        base08 = config.lib.stylix.colors.base08 ;
        base09 = config.lib.stylix.colors.base09 ;
        base0A = config.lib.stylix.colors.base0A ;
        base0B = config.lib.stylix.colors.base0B ;
        base0C = config.lib.stylix.colors.base0C ;
        base0D = config.lib.stylix.colors.base0D ;
        base0E = config.lib.stylix.colors.base0E ;
        base0F = config.lib.stylix.colors.base0F ;
      };
    };
# if I ever want to make that smaller I'll fix this       i = if ( i >= 10 ) then if ( i == 10) then "A" else if (i == 11) then "B" else if (i == 12) then "C" else if (i == 13) then "D" else if (i == 14) then "E" else if (i == 15) then "F" ; #godawful implementation but cry about it
 
  };

  #imports = [
   # ./plugins/lsp/omnisharp.nix
    #./plugins/lsp/yamlls.nix
    #./plugins/lsp/nixd.nix
    #./plugins/tree-sitter/tree-sitter.nix
  #];


}
