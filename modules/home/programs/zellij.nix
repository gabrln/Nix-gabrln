{ config, lib, ... }:

{
  programs.zellij = {
    enable = true;
    # Using default config - custom config.kdl via mutable dotfile
  };

  # Mutable dotfile for Zellij config
  xdg.configFile."zellij/config.kdl".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.config/nixos/modules/home/dotfiles/zellij/config.kdl";
}
