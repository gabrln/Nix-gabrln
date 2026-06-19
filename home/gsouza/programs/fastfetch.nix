{ config, pkgs, ... }:

{
  programs.fastfetch.enable = true;

  # Delega a renderização para o arquivo JSONC original não modificado pelo Nix
  xdg.configFile."fastfetch/config.jsonc".source = ./../../../configs/fastfetch/config.jsonc;
  xdg.configFile."fastfetch/logos".source = ./../../../configs/fastfetch/logos;
  xdg.configFile."fastfetch/scripts".source = ./../../../configs/fastfetch/scripts;
}
