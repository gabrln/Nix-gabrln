{ config, pkgs, lib, ... }:

{
  # User Packages
  home.packages = with pkgs; [
    eza
    bat
    fd
    ripgrep
    zoxide
    starship
    kitty
    libnotify
    jq
  ];

  # Zsh Shell - minimal config via Home Manager
  # Main configuration loaded from mutable dotfile
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history = {
      size = 100000;
      save = 100000;
      share = true;
      ignoreDups = true;
      ignoreSpace = true;
      expireDuplicatesFirst = true;
    };
    plugins = [
      {
        name = "zsh-vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
      {
        name = "zsh-history-substring-search";
        src = pkgs.zsh-history-substring-search;
        file = "share/zsh-history-substring-search/zsh-history-substring-search.zsh";
      }
    ];
    initContent = ''
      # Load mutable dotfile configuration
      [[ -f ~/.config/nixos/modules/home/dotfiles/zsh/.zshrc ]] && source ~/.config/nixos/modules/home/dotfiles/zsh/.zshrc
    '';
  };

  # Ensure config directory exists
  home.activation.ensureConfigDirs = lib.hm.dag.entryBefore [ "writeBoundary" ] ''
    mkdir -p "$HOME/.config/kitty/themes"
  '';

  # Zoxide (Autojump)
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  # FZF
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}
