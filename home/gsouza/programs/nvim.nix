{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    extraLuaConfig = ''
      -- Clipboard (Wayland via wl-clipboard)
      vim.opt.clipboard = "unnamedplus"

      -- Basics
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.scrolloff = 8
      vim.opt.tabstop = 2
      vim.opt.shiftwidth = 2
      vim.opt.expandtab = true
      vim.opt.smartindent = true
      vim.opt.wrap = true
      vim.opt.ignorecase = true
      vim.opt.smartcase = true
      vim.opt.termguicolors = true
    '';
  };
}
