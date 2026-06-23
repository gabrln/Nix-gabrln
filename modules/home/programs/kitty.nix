{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    package = pkgs.kitty;
  };

  # Use mutable dotfile for Kitty configuration
  # Changes apply immediately without rebuild
  xdg.configFile."kitty/kitty.conf".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.config/nixos/modules/home/dotfiles/kitty/kitty.conf";
}

