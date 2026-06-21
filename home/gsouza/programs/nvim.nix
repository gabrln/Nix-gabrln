{ config, pkgs, ... }:

{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # Enable Wayland clipboard support via wl-copy
    clipboard.providers.wl-copy.enable = true;

    opts = {
      # Basics
      number = true;
      relativenumber = true;
      scrolloff = 8;
      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;
      smartindent = true;
      wrap = true;
      ignorecase = true;
      smartcase = true;
      termguicolors = true;
    };

    # Recommended plugins, without autocomplete popups (no nvim-cmp)
    plugins = {
      lualine.enable = true;      # Premium status bar
      bufferline.enable = true;   # View open buffers at the top
      treesitter.enable = true;   # Smart syntax highlighting
      telescope.enable = true;    # Fuzzy file and text finder
      web-devicons.enable = true; # Icons for the interface
      gitsigns.enable = true;     # Git modification indicators
      which-key.enable = true;    # Command and shortcut hints on screen
      comment.enable = true;      # Quickly comment/uncomment lines
      lsp = {
        enable = true;
        servers = {
          nil_ls.enable = true;   # Official Language Server for Nix
          bashls.enable = true;   # Language Server for Shell/Bash
        };
      };
    };

    extraPlugins = with pkgs.vimPlugins; [
      base16-nvim
    ];

    extraConfigLua = ''
      local ok, matugen = pcall(require, 'matugen')
      if ok then
        matugen.setup()
      end
    '';
  };
}
