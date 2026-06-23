#!/usr/bin/env bash
# Custom Unified Cheat Sheet using FZF.

# Define shortcuts array
shortcuts=(
  # MangoWM bindings
  "[MangoWM] :: SUPER + Return :: Open Terminal :: kitty"
  "[MangoWM] :: SUPER + B :: Launch Browser :: firefox"
  "[MangoWM] :: SUPER + E :: File Manager (Yazi) :: kitty -e yazi"
  "[MangoWM] :: SUPER + SHIFT + E :: File Manager (Nautilus GUI) :: nautilus"
  "[MangoWM] :: SUPER + D :: App Launcher :: noctalia msg panel-toggle launcher"
  "[MangoWM] :: SUPER + V :: Clipboard Manager :: noctalia msg panel-toggle clipboard"
  "[MangoWM] :: SUPER + P :: Control Center / Audio :: noctalia msg panel-toggle session"
  "[MangoWM] :: SUPER + I :: Noctalia Settings Panel :: noctalia msg settings-toggle"
  "[MangoWM] :: SUPER + SHIFT + N :: Notification Panel :: noctalia msg panel-toggle control-center notifications"
  "[MangoWM] :: SUPER + SHIFT + D :: Active Window Info :: ~/.config/mango/scripts/WindowInfo.sh"
  "[MangoWM] :: CTRL + ALT + L :: Lock Screen :: noctalia msg session lock"
  "[MangoWM] :: CTRL + ALT + Delete :: Exit MangoWM Session :: mmsg dispatch quit"
  "[MangoWM] :: SUPER + Q :: Close Window :: mmsg dispatch killclient"
  "[MangoWM] :: ALT + F4 :: Force Kill Window (script) :: ~/.config/mango/scripts/AltF4.sh"
  "[MangoWM] :: SUPER + F :: Toggle Fullscreen :: mmsg dispatch togglefullscreen"
  "[MangoWM] :: SUPER + M :: Toggle Maximized :: mmsg dispatch togglemaximizescreen"
  "[MangoWM] :: SUPER + Space :: Toggle Float :: mmsg dispatch togglefloating"
  "[MangoWM] :: SUPER + O :: Toggle Overlay (Pin/Sticky) :: mmsg dispatch toggleoverlay"
  "[MangoWM] :: SUPER + H :: Show Unified Cheat Sheet :: KeyHints.sh"
  "[MangoWM] :: SUPER + F1 :: Dropdown System Monitor (btop) :: toggle btop"
  "[MangoWM] :: SUPER + SHIFT + Return :: Dropdown Terminal (kitty-drop) :: toggle kitty"
  "[MangoWM] :: SUPER + U :: Toggle Scratchpad (special workspace) :: toggle_scratchpad"
  "[MangoWM] :: ALT + E :: Set Proportion to 1.0 :: mmsg dispatch set_proportion,1.0"
  "[MangoWM] :: ALT + X :: Switch Proportion Preset :: mmsg dispatch switch_proportion_preset"
  "[MangoWM] :: SUPER + Arrow Keys :: Move Focus (Directional) :: mmsg dispatch focusdir [left|right|up|down]"
  "[MangoWM] :: SUPER + SHIFT + Arrow Keys :: Swap Window Position :: mmsg dispatch exchange_client [left|right|up|down]"
  "[MangoWM] :: CTRL + ALT + Arrow Keys :: Resize Window :: mmsg dispatch resizewin [x,y]"
  "[MangoWM] :: SUPER + [0-9] :: Switch to Tag [1-10] :: mmsg dispatch view [1-10]"
  "[MangoWM] :: SUPER + SHIFT + [0-9] :: Move Window to Tag [1-10] :: mmsg dispatch tag [1-10]"
  "[MangoWM] :: SUPER + TAB :: Next Tag :: mmsg dispatch viewtoright"
  "[MangoWM] :: SUPER + SHIFT + TAB :: Previous Tag :: mmsg dispatch viewtoleft"
  "[MangoWM] :: ALT + TAB :: Toggle Overview :: mmsg dispatch toggleoverview"
  "[MangoWM] :: SUPER + N :: Toggle Night Light :: noctalia msg nightlight-toggle"
  "[MangoWM] :: SUPER + Y :: Toggle Caffeine (No Sleep) :: noctalia msg caffeine-toggle"
  "[MangoWM] :: SUPER + W :: Random Wallpaper :: noctalia msg wallpaper-random"
  "[MangoWM] :: SUPER + SHIFT + T :: Toggle Dark/Light Theme :: noctalia msg theme-mode-toggle"
  "[MangoWM] :: SUPER + SHIFT + B :: Toggle Screen Blur :: ~/.config/mango/scripts/ToggleBlur.sh"
  "[MangoWM] :: SUPER + SHIFT + G :: Toggle Gamemode :: ~/.config/mango/scripts/ToggleGamemode.sh"
  "[MangoWM] :: SUPER + Print :: Screenshot Fullscreen :: noctalia msg screenshot-fullscreen"
  "[MangoWM] :: SUPER + SHIFT + Print :: Screenshot Region :: noctalia msg screenshot-region"
  "[MangoWM] :: ALT + Print :: Screenshot Active Window :: noctalia msg screenshot-fullscreen pick"
  "[MangoWM] :: Volume/Brightness Keys :: Volume/Brightness controls :: noctalia volume/brightness"
  "[MangoWM] :: Play/Pause/Next/Prev :: Media controls :: noctalia msg media toggle/next/prev"
  "[MangoWM] :: SUPER + F2 :: Toggle Microphone Mute :: noctalia msg mic-mute"

  # Zsh Aliases
  "[Zsh/Alias] :: c :: Clear terminal :: clear"
  "[Zsh/Alias] :: q :: Exit terminal :: exit"
  "[Zsh/Alias] :: .. :: Go up one directory :: cd .."
  "[Zsh/Alias] :: ... :: Go up two directories :: cd ../.."
  "[Zsh/Alias] :: - :: Go to previous directory :: cd -"
  "[Zsh/Alias] :: ls :: Modern file listing (eza) :: eza --icons --color=always --group-directories-first"
  "[Zsh/Alias] :: ll :: Detailed modern list :: eza -lah --icons --color=always --group-directories-first"
  "[Zsh/Alias] :: lt / tree :: Display directory tree :: eza --tree --icons"
  "[Zsh/Alias] :: cat :: Modern file view (bat) :: bat --style=plain"
  "[Zsh/Alias] :: grep :: Ripgrep file search :: rg"
  "[Zsh/Alias] :: find :: Fast file/dir find :: fd"
  "[Zsh/Alias] :: y :: Open Yazi (cd on exit) :: y"
  "[Zsh/Alias] :: zj :: Zellij multiplexer :: zellij"
  "[Zsh/Alias] :: zja :: Zellij attach :: zellij attach"
  "[Zsh/Alias] :: zjl :: Zellij list sessions :: zellij list-sessions"

  # Config
  "[Zsh/Alias] :: conf-nix :: Edit NixOS flake configuration :: nvim ~/.config/nixos/flake.nix"
  "[Zsh/Alias] :: conf-mango :: Edit MangoWM configuration :: nvim ~/.config/nixos/home/gabrln/wayland/mango.nix"
  "[Zsh/Alias] :: conf-zsh :: Edit Zsh configuration :: nvim ~/.config/nixos/home/gabrln/programs/zsh.nix"
  "[Zsh/Alias] :: conf-zj :: Edit Zellij config :: nvim ~/.config/zellij/config.kdl"
  "[Zsh/Alias] :: reload-zsh :: Reload Zsh configuration :: source ~/.zshrc"

  # Nix
  "[Nix/System] :: rebuild :: Rebuild NixOS switch :: nh os switch"
  "[Nix/System] :: update :: Update Nix flake and rebuild :: nix flake update && nh os switch"
  "[Nix/System] :: nxi <pkg> :: Install Nix package user-profile :: nix profile install nixpkgs#<pkg>"
  "[Nix/System] :: nxu <pkg> :: Remove Nix package user-profile :: nix profile remove <pkg>"
  "[Nix/System] :: nxl :: List user-profile installed packages :: nix profile list"
  "[Nix/System] :: nxs <pkg> :: Enter temporary shell with package :: nix shell nixpkgs#<pkg>"
  "[Nix/System] :: nxr <pkg> :: Run package without installing :: nix run nixpkgs#<pkg>"
  "[Nix/System] :: nxsearch <pkg> :: Search Nixpkgs registry :: nix search nixpkgs <pkg>"
  "[Nix/System] :: nxd :: Develop Nix environment (flake) :: nix develop"

  # Git
  "[Git] :: g :: Git wrapper :: git"
  "[Git] :: gst :: Git status (short format) :: git status -sb"
  "[Git] :: gd :: Git diff :: git diff"
  "[Git] :: gp :: Git push :: git push"
  "[Git] :: gpl :: Git pull :: git pull"
  "[Git] :: ga <files> :: Stage files :: git add"
  "[Git] :: gc '<msg>' :: Commit with message :: git commit -m"
  "[Git] :: gadog :: Fancy git log graph :: git log --all --decorate --oneline --graph"

  # Yazi
  "[Yazi] :: i / Enter :: Open selected file/folder :: Yazi native"
  "[Yazi] :: q :: Quit Yazi :: Yazi native"
  "[Yazi] :: ~ :: Show Yazi help cheatsheet :: Yazi native"
  "[Yazi] :: v :: Toggle visual selection mode :: Yazi native"
  "[Yazi] :: y :: Copy/yank selected file :: Yazi native"
  "[Yazi] :: x :: Cut selected file :: Yazi native"
  "[Yazi] :: p :: Paste copied/cut file :: Yazi native"
  "[Yazi] :: d :: Delete file to Trash :: Yazi native"
  "[Yazi] :: D :: Delete file permanently :: Yazi native"
  "[Yazi] :: g g :: Go to top of list :: Yazi native"
  "[Yazi] :: G :: Go to bottom of list :: Yazi native"
  "[Yazi] :: c a :: Create new file :: Yazi native"
  "[Yazi] :: c d :: Create new directory :: Yazi native"
  "[Yazi] :: r :: Rename file/directory :: Yazi native"
  "[Yazi] :: / :: Search files in current folder :: Yazi native"
)

# Pipe array through column formatting and into FZF
selected=$(printf "%s\n" "${shortcuts[@]}" | column -t -s '::' | \
  fzf --header=" [ ENTER: Copiar comando para o clipboard | ESC: Sair | Filtre digitando 'mango', 'zsh', 'yazi' ]" \
      --layout=reverse \
      --border=rounded \
      --prompt="🔍 Pesquisar atalho: ")

if [[ -n "$selected" ]]; then
  selected_trimmed=$(echo "$selected" | xargs)
  
  for item in "${shortcuts[@]}"; do
    item_formatted=$(echo "$item" | sed 's/ :: /   /g' | xargs)
    if [[ "$selected_trimmed" == "$item_formatted"* ]]; then
      action=$(echo "$item" | awk -F ' :: ' '{print $4}')
      if [[ -n "$action" ]]; then
        # Check if selected item is a native Yazi binding
        if [[ "$action" == "Yazi native" ]]; then
          notify-send -a "Sistema" "Atalho Yazi" "Atalho nativo dentro do Yazi" -t 2000 -i dialog-information
        else
          echo -n "$action" | wl-copy
          notify-send -a "Sistema" "Atalho Copiado" "Comando '$action' copiado para o clipboard!" -t 2000 -i edit-copy
        fi
      fi
      break
    fi
  done
fi
