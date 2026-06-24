# Zsh Shell Configuration
# Mutable dotfile - changes apply immediately without rebuild

# =========================================================
# Completion & Zstyle Settings
# =========================================================
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

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
    cmd="${FZF_DEFAULT_COMMAND/--hidden /}"
    if command -v bat &>/dev/null; then
      result=$(eval "${cmd:-find . -type f}" | fzf --preview "$_FZF_PREVIEW_CMD")
    else
      result=$(eval "${cmd:-find . -type f}" | fzf)
    fi
    if [[ -n "$result" ]]; then
      LBUFFER+="$result"
    fi
    zle reset-prompt
  }
  zle -N _fzf_file_no_hidden
fi

# Initialize Starship Prompt
eval "$(starship init zsh)"

# =========================================================
# Shell Aliases (Modern replacements)
# =========================================================
alias c="clear"
alias q="exit"
alias ".."="cd .."
alias "..."="cd ../.."
alias "...."="cd ../../.."
alias -- "-"="cd -"

# Modern replacements from Obsidian notes
alias ls="eza --icons --color=always --group-directories-first"
alias ll="eza -lah --icons --color=always --group-directories-first"
alias la="eza -A --icons --color=always"
alias lt="eza --tree --level=2 --icons"
alias tree="eza --tree --icons"
alias cat="bat --style=plain"
alias grep="rg"
alias find="fd"

# NixOS config shortcuts
alias conf-nix="nvim ~/.config/nixos/flake.nix"
alias conf-mango="nvim ~/.config/nixos/modules/home/wayland/mango.nix"
alias conf-kitty="nvim ~/.config/nixos/modules/home/dotfiles/kitty/kitty.conf"
alias conf-zsh="nvim ~/.config/nixos/modules/home/dotfiles/zsh/.zshrc"
alias reload-zsh="source ~/.zshrc && echo 'Zsh config reloaded!'"

# Git shortcuts
alias g="git"
alias gst="git status -sb"
alias gd="git diff"
alias gl="git log --oneline -n 10"
alias gp="git push"
alias gpl="git pull"
alias ga="git add"
alias gc="git commit -m"
alias glog="PAGER=\"less -F -X\" git log"
alias gadog="PAGER=\"less -F -X\" git log --all --decorate --oneline --graph"

# Zellij shortcuts
alias zj="zellij"
alias zm="zellij attach main || zellij --session main"
alias zjl="zellij list-sessions"
alias zjda="zellij delete-all-sessions --force"
alias conf-zj="nvim ~/.config/zellij/config.kdl"

# Nix shortcuts
alias rebuild="cd ~/.config/nixos && sudo nixos-rebuild switch --flake ."
alias update="cd ~/.config/nixos && nix flake update && sudo nixos-rebuild switch --flake ."
alias nxi="nix profile install nixpkgs#"
alias nxu="nix profile remove"
alias nxl="nix profile list"
alias nxs="nix shell nixpkgs#"
alias nxr="nix run nixpkgs#"
alias nxsearch="nix search nixpkgs"
alias nxd="nix develop"

# =========================================================
# Environment Variables
# =========================================================
export VIRTUAL_ENV_DISABLE_PROMPT=1
export FUNCNEST=100
