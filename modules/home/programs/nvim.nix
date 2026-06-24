{ config, pkgs, lib, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;
    withPython3 = true;

    extraPackages = with pkgs; [
      nil
      bash-language-server
      ripgrep
      fd
      git
    ];
  };

  # Mutable LazyVim config - symlink individual files to avoid conflict with programs.neovim
  xdg.configFile."nvim/init.lua".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.config/nixos/modules/home/dotfiles/nvim/init.lua";

  xdg.configFile."nvim/lua".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.config/nixos/modules/home/dotfiles/nvim/lua";
}
