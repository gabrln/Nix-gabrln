{ config, pkgs, inputs, lib, vars, ... }:

{
  imports = [
    inputs.noctalia.homeModules.default
    inputs.mango.hmModules.mango
    inputs.nixvim.homeModules.nixvim
    ./programs
    ./programs/webapps.nix
    ./wayland
  ];

  # Home Manager identity
  home.username = vars.userName;
  home.homeDirectory = "/home/${vars.userName}";
  home.stateVersion = "26.05";

  # XDG user directories configuration
  xdg.enable = true;
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    desktop = "${config.home.homeDirectory}/Desktop";
    documents = "${config.home.homeDirectory}/Documents";
    download = "${config.home.homeDirectory}/Downloads";
    music = "${config.home.homeDirectory}/Music";
    pictures = "${config.home.homeDirectory}/Pictures";
    publicShare = "${config.home.homeDirectory}/Public";
    templates = "${config.home.homeDirectory}/Templates";
    videos = "${config.home.homeDirectory}/Videos";
  };
  home.packages = with pkgs; [
    zathura      # PDF Viewer
    swayimg      # Image Viewer Wayland
    mpv          # Media Player
    file-roller  # Archive Manager
    rclone       # Cloud Sync
    protonup-qt  # Manage Proton-GE versions
    prismlauncher # Minecraft launcher
    spotify      # Spotify client
    nautilus     # File Manager (GUI)
    duf          # Disk Usage Free (Visual disk display)
    gping        # Graphical ping (Interactive latency display)
    tldr         # Simplified and community-driven man pages helper
    delta        # Syntax-highlighting pager for git/diffs
    procs        # Modern replacement for ps (processes viewer)
  ];

  # GTK theme configuration
  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    gtk4.theme = config.gtk.theme;
  };

  # Disable Home Manager management of gtk.css files to avoid conflicts with Noctalia
  xdg.configFile."gtk-3.0/gtk.css".enable = false;
  xdg.configFile."gtk-4.0/gtk.css".enable = false;


  # Qt theme configuration
  qt = {
    enable = false;
  };

  # Dconf settings for GTK4/Adwaita preference
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  # User cursor theme
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    name = "Bibata-Modern-Classic";
    size = 24;
    package = pkgs.bibata-cursors;
  };

  # Default file associations (MIME Types) imported from Vault notes
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/antigravity" = "antigravity.desktop";
      "inode/directory" = "yazi.desktop";
      "text/plain" = "nvim.desktop";
      "text/markdown" = "nvim.desktop";
      "text/html" = "firefox.desktop";
      "application/pdf" = "org.pwmt.zathura.desktop";
      "image/png" = "swayimg.desktop";
      "image/jpeg" = "swayimg.desktop";
      "image/gif" = "swayimg.desktop";
      "image/svg+xml" = "swayimg.desktop";
      "image/webp" = "swayimg.desktop";
      "video/mp4" = "mpv.desktop";
      "video/mkv" = "mpv.desktop";
      "video/webm" = "mpv.desktop";
      "video/x-matroska" = "mpv.desktop";
      "audio/mpeg" = "mpv.desktop";
      "audio/ogg" = "mpv.desktop";
      "audio/wav" = "mpv.desktop";
      "audio/x-wav" = "mpv.desktop";
      "audio/flac" = "mpv.desktop";
      "application/zip" = "org.gnome.FileRoller.desktop";
      "application/x-tar" = "org.gnome.FileRoller.desktop";
      "application/x-gzip" = "org.gnome.FileRoller.desktop";
      "application/x-bzip2" = "org.gnome.FileRoller.desktop";
      "application/x-7z-compressed" = "org.gnome.FileRoller.desktop";
      "application/x-rar" = "org.gnome.FileRoller.desktop";
      "x-scheme-handler/rclone" = "rclone-ui-handler.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/chrome" = "firefox.desktop";
      "application/x-extension-htm" = "firefox.desktop";
      "application/x-extension-html" = "firefox.desktop";
      "application/x-extension-shtml" = "firefox.desktop";
      "application/xhtml+xml" = "firefox.desktop";
      "application/x-extension-xhtml" = "firefox.desktop";
      "application/x-extension-xht" = "firefox.desktop";
    };
    associations.added = {
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/chrome" = "firefox.desktop";
      "application/x-extension-htm" = "firefox.desktop";
      "application/x-extension-html" = "firefox.desktop";
      "application/x-extension-shtml" = "firefox.desktop";
      "application/xhtml+xml" = "firefox.desktop";
      "application/x-extension-xhtml" = "firefox.desktop";
      "application/x-extension-xht" = "firefox.desktop";
    };
  };

  # Expose theme and icons to Flatpak apps by symlinking them into home directory
  home.file = {
    ".themes/adw-gtk3-dark".source = "${pkgs.adw-gtk3}/share/themes/adw-gtk3-dark";
    ".themes/adw-gtk3".source = "${pkgs.adw-gtk3}/share/themes/adw-gtk3";
    ".icons/Papirus-Dark".source = "${pkgs.papirus-icon-theme}/share/icons/Papirus-Dark";
    ".icons/Papirus".source = "${pkgs.papirus-icon-theme}/share/icons/Papirus";
  };


  # Ensure starship.toml is writable so Noctalia can write the color palette to it
  home.activation.setupStarshipConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    config_file="$HOME/.config/starship.toml"
    if [ -f "$config_file" ]; then
      chmod +w "$config_file"
    else
      mkdir -p "$HOME/.config"
      echo 'palette = "noctalia"' > "$config_file"
      echo 'add_newline = false' >> "$config_file"
      chmod 644 "$config_file"
    fi
  '';

  # Declaratively ensure Pictures/Screenshots and Pictures/Wallpapers directories exist
  home.activation.createPicturesDirs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "$HOME/Pictures/Screenshots"
    mkdir -p "$HOME/Pictures/Wallpapers"
  '';

  # Enable direnv and nix-direnv for automatic cached development shells
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
