{ config, pkgs, ... }:

{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # Habilita suporte a clipboard do Wayland via wl-copy
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

    # Plugins recomendados, sem autocompletar popups (no nvim-cmp)
    plugins = {
      lualine.enable = true;      # Barra de status premium
      bufferline.enable = true;   # Visualizar buffers abertos no topo
      treesitter.enable = true;   # Destaque de sintaxe inteligente
      telescope.enable = true;    # Localizador fuzzy de arquivos e texto
      web-devicons.enable = true; # Ícones para a interface
      gitsigns.enable = true;     # Indicadores de modificações git
      which-key.enable = true;    # Dicas de comandos e atalhos na tela
      comment.enable = true;      # Comentar/descomentar linhas rapidamente
      lsp = {
        enable = true;
        servers = {
          nil_ls.enable = true;   # Language Server oficial para Nix
          bashls.enable = true;   # Language Server para Shell/Bash
        };
      };
    };
  };
}
