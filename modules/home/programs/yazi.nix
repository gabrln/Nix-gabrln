{ config, lib, ... }:

{
  programs.yazi = {
    enable = true;
    shellWrapperName = "y";
    enableZshIntegration = true;
  };

  # Mutable dotfiles for Yazi config
  xdg.configFile."yazi/yazi.toml".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.config/nixos/modules/home/dotfiles/yazi/yazi.toml";

  xdg.configFile."yazi/keymap.toml".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.config/nixos/modules/home/dotfiles/yazi/keymap.toml";

  # Map flavors directory for noctalia.yazi theme
  xdg.configFile."yazi/flavors".source = ../dotfiles/yazi/flavors;
}
