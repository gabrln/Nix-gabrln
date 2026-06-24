{ config, ... }:

{
  programs.noctalia = {
    enable = true;
    settings = {
      theme = {
        mode = "dark";
        source = "builtin";
        builtin = "Catppuccin";
      };
      shell = {
        launch_apps_as_systemd_services = true;
        panel = {
          shadow = false;
        };
      };
      bar = {
        main = {
          shadow = false;
          contact_shadow = false;
        };
      };
      dock = {
        shadow = false;
      };
    };
  };

  # Noctalia Templates Configuration for Auto-Theming
  xdg.configFile."noctalia/templates.toml".text = ''
    [theme.templates]
    enable_builtin_templates = true
    enable_community_templates = true
    builtin_ids = [ "btop", "cava", "gtk3", "gtk4", "kitty", "mango", "qt", "starship" ]
    community_ids = [ "neovim", "yazi" ]
  '';

  # Custom Noctalia Template for Neovim dynamic theming
  xdg.configFile."noctalia/user-templates.toml".text = ''
    [templates.neovim]
    input_path = "${config.home.homeDirectory}/.config/noctalia/templates/neovim.lua"
    output_path = "${config.home.homeDirectory}/.config/nvim/lua/matugen.lua"
    post_hook = "pkill -SIGUSR1 nvim"
  '';

  xdg.configFile."noctalia/templates/neovim.lua".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.config/nixos/modules/home/dotfiles/noctalia/templates/neovim.lua";
}
