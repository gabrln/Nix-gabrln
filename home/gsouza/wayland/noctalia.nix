{ config, pkgs, ... }:

{
  programs.noctalia = {
    enable = true;
    systemd.enable = true;
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
    builtin_ids = [ "kitty", "starship", "qt" ]
    community_ids = [ "yazi", "neovim" ]
  '';

  # Custom Noctalia Template mapping for MangoWM to override scratchpad border color
  xdg.configFile."noctalia/user-templates.toml".text = ''
    [templates.mango]
    input_path = "${config.home.homeDirectory}/.config/noctalia/templates/mango.conf"
    output_path = "${config.home.homeDirectory}/.config/mango/noctalia.conf"
    post_hook = "mmsg dispatch reload_config"
  '';

  # Custom Mango theme template using focuscolor (primary) for scratchpad borders
  xdg.configFile."noctalia/templates/mango.conf".text = ''
    # Noctalia Theme for Mango (Custom Template)
    # Generated automatically by Noctalia Shell

    shadowscolor = 0x{{colors.shadow.default.hex_stripped}}ff
    rootcolor = 0x{{colors.surface.default.hex_stripped}}ff
    bordercolor = 0x{{colors.outline.default.hex_stripped}}ff
    dropcolor = 0x{{colors.primary.default.hex_stripped}}80
    splitcolor = 0x{{colors.tertiary.default.hex_stripped}}ff
    focuscolor = 0x{{colors.primary.default.hex_stripped}}ff
    maximizescreencolor = 0x{{colors.secondary.default.hex_stripped}}ff
    urgentcolor = 0x{{colors.error.default.hex_stripped}}ff
    scratchpadcolor = 0x{{colors.primary.default.hex_stripped}}ff
    globalcolor = 0x{{colors.primary_container.default.hex_stripped}}ff
    overlaycolor = 0x{{colors.secondary_container.default.hex_stripped}}ff
  '';
}
