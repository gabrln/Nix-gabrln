{ pkgs, ... }:

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
    ];

    plugins = with pkgs.vimPlugins; [
      lualine-nvim
      bufferline-nvim
      nvim-treesitter
      telescope-nvim
      nvim-web-devicons
      gitsigns-nvim
      which-key-nvim
      comment-nvim
      nvim-lspconfig
      base16-nvim
    ];

    extraLuaConfig = ''
      -- Options
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

      -- Treesitter
      require('nvim-treesitter.configs').setup({
        ensure_installed = { "nix", "bash", "lua" },
        auto_install = true,
        highlight = { enable = true },
      })

      -- Lualine
      require('lualine').setup()

      -- Bufferline
      require('bufferline').setup()

      -- Telescope
      require('telescope').setup()

      -- Gitsigns
      require('gitsigns').setup()

      -- Which-key
      require('which-key').setup()

      -- Comment
      require('comment').setup()

      -- LSP
      local lspconfig = require('lspconfig')
      lspconfig.nil_ls.setup({})
      lspconfig.bashls.setup({})

      -- Noctalia dynamic theme template
      local ok, matugen = pcall(require, 'matugen')
      if ok then
        matugen.setup()
      end
    '';
  };
}
