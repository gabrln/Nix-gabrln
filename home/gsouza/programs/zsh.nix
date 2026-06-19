{ config, pkgs, ... }:

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

  # Zsh Shell Config
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
    shellAliases = {
      c = "clear";
      q = "exit";
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "-" = "cd -";
      
      # Modern replacements from Obsidian notes
      ls = "eza --icons --color=always --group-directories-first";
      ll = "eza -lah --icons --color=always --group-directories-first";
      la = "eza -A --icons --color=always";
      lt = "eza --tree --level=2 --icons";
      tree = "eza --tree --icons";
      cat = "bat --style=plain";
      grep = "rg";
      find = "fd";

      # NixOS config shortcuts (adapted from vault notes)
      conf-nix = "nvim ~/.config/nixos/flake.nix";
      conf-mango = "nvim ~/.config/nixos/home/gsouza/wayland/mango.nix";
      conf-zsh = "nvim ~/.config/nixos/home/gsouza/programs/zsh.nix";
      reload-zsh = "source ~/.zshrc && echo 'Zsh config reloaded!'";

      # Docker aliases
      dk-start = "docker-start";
      dk-stop = "docker-stop";
      dk-status = "docker-status";

      g = "git";
      gst = "git status -sb";
      gd = "git diff";
      gl = "git log --oneline -n 10";
      gp = "git push";
      gpl = "git pull";
      ga = "git add";
      gc = "git commit -m";
      glog = "PAGER=\"less -F -X\" git log";
      gadog = "PAGER=\"less -F -X\" git log --all --decorate --oneline --graph";
      zj = "zellij";
      zja = "zellij attach";
      zjl = "zellij list-sessions";
      zjda = "zellij delete-all-sessions --force";
      conf-zj = "nvim ~/.config/zellij/config.kdl";
      nxi = "nix profile install nixpkgs#";
      nxu = "nix profile remove";
      nxl = "nix profile list";
      nxs = "nix shell nixpkgs#";
      nxr = "nix run nixpkgs#";
      nxsearch = "nix search nixpkgs";
      nxd = "nix develop";
    };
    sessionVariables = {
      VIRTUAL_ENV_DISABLE_PROMPT = "1";
      FUNCNEST = "100";
    };
    initExtra = ''
      # =========================================================
      # Zsh Completion & Zstyle settings from vault
      # =========================================================
      zstyle ':completion:*' menu select
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

      # =========================================================
      # Docker Automation Functions from vault
      # =========================================================
      docker-start() {
        sudo systemctl start docker
        if systemctl is-active --quiet docker; then
          notify-send "Docker" "Active" -i docker -u normal
        else
          notify-send "Docker" "Failed to start" -i dialog-error -u critical
        fi
      }
      docker-stop() {
        sudo systemctl stop docker
        if ! systemctl is-active --quiet docker; then
          notify-send "Docker" "Inactive" -i docker -u normal
        else
          notify-send "Docker" "Failed to stop" -i dialog-error -u critical
        fi
      }
      docker-status() {
        if systemctl is-active --quiet docker; then
          notify-send "Docker" "Active" -i docker
        else
          notify-send "Docker" "Inactive" -i docker
        fi
      }

      # =========================================================
      # Zsh Vi Mode & Keybindings
      # =========================================================
      # Cursor shape per vi mode
      ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BEAM
      ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLOCK
      ZVM_VISUAL_MODE_CURSOR=$ZVM_CURSOR_BLOCK

      # Disable command mode line highlight
      ZVM_VI_HIGHLIGHT_BACKGROUND=none
      ZVM_VI_HIGHLIGHT_FOREGROUND=none
      ZVM_VI_HIGHLIGHT_EXTRASTYLE=none

      # Custom keybindings register via zsh-vi-mode hook to survive reset
      zvm_after_init() {
        # Ctrl+Right -> move forward one word
        bindkey '^[[1;5C' forward-word
        # Ctrl+Left -> move backward one word
        bindkey '^[[1;5D' backward-word

        # Ctrl+F -> fzf file picker (no hidden files)
        if command -v fzf &>/dev/null && command -v fd &>/dev/null; then
          bindkey '^F' _fzf_file_no_hidden
        fi

        # Ctrl+\ -> toggle autosuggestions
        bindkey '^\' autosuggest-toggle

        # Up/Down -> history search by substring
        bindkey '^[[A' history-substring-search-up
        bindkey '^[[B' history-substring-search-down
      }

      # Fallback bindings if zsh-vi-mode is not active or hasn't loaded yet
      bindkey '^[[1;5C' forward-word
      bindkey '^[[1;5D' backward-word
      if command -v fzf &>/dev/null && command -v fd &>/dev/null; then
        bindkey '^F' _fzf_file_no_hidden
      fi
      bindkey '^\' autosuggest-toggle
      bindkey '^[[A' history-substring-search-up
      bindkey '^[[B' history-substring-search-down

      # =========================================================
      # FZF Configuration
      # =========================================================
      if command -v fzf &>/dev/null && command -v fd &>/dev/null; then
        # Use fd as backend
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --strip-cwd-prefix --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

        # Styling & Layout
        export FZF_DEFAULT_OPTS='
          --height=60%
          --layout=reverse
          --border=rounded
          --prompt="  "
          --pointer="  "
          --preview-window=right:65%:wrap:border-left
        '

        # Bat as preview engine if available
        if command -v bat &>/dev/null; then
          export _FZF_PREVIEW_CMD='bat --color=always --style=plain,numbers --line-range=:500 {}'
          export FZF_CTRL_T_OPTS="--preview '$_FZF_PREVIEW_CMD'"
        fi

        # Ctrl+F: file picker excluding hidden files
        _fzf_file_no_hidden() {
          local cmd result
          cmd="''${FZF_DEFAULT_COMMAND/--hidden /}"
          if command -v bat &>/dev/null; then
            result=$(eval "''${cmd:-find . -type f}" | fzf --preview "$_FZF_PREVIEW_CMD")
          else
            result=$(eval "''${cmd:-find . -type f}" | fzf)
          fi
          if [[ -n "$result" ]]; then
            LBUFFER+="$result"
          fi
          zle reset-prompt
        }
        zle -N _fzf_file_no_hidden
      fi
    '';
  };

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
