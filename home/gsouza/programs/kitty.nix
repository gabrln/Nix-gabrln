{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 11.0;
      package = pkgs.nerd-fonts.jetbrains-mono;
    };
    keybindings = {
      "ctrl+insert" = "copy_to_clipboard";
      "shift+insert" = "paste_from_clipboard";
    };
    settings = {
      background_opacity = "0.9";
      window_padding_width = 14;
      hide_window_decorations = "yes";
      confirm_os_window_close = 0;
      cursor_shape = "beam";
      cursor_blink_interval = 0;
      cursor_trail = 1;
      cursor_trail_decay = "0.1 0.4";
      cursor_trail_start_threshold = 2;
      shell_integration = "no-cursor";
      enable_audio_bell = "no";
      copy_on_select = "clipboard";
      allow_remote_control = "yes";
      tab_bar_edge = "bottom";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      tab_title_template = "{title}{' :({}):'.format(num_windows) if num_windows > 1 else ''}";
    };
    extraConfig = ''
      # Catppuccin Mocha theme (Noctalia colors)
      color0 #45475a
      color1 #f38ba8
      color2 #a6e3a1
      color3 #f9e2af
      color4 #89b4fa
      color5 #f5c2e7
      color6 #94e2d5
      color7 #a6adc8
      color8 #585b70
      color9 #f37799
      color10 #89d88b
      color11 #ebd391
      color12 #74a8fc
      color13 #f2aede
      color14 #6bd7ca
      color15 #bac2de

      cursor                #f5e0dc
      cursor_text_color     #1e1e2e
      background            #1e1e2e
      foreground            #cdd6f4
      selection_foreground  #cdd6f4
      selection_background  #585b70
      active_border_color   #cba6f7
      inactive_border_color #313244
      url_color             #cba6f7

      active_tab_foreground   #11111b
      active_tab_background   #cba6f7
      inactive_tab_foreground #a3b4eb
      inactive_tab_background #313244
      cursor_trail_color      #a3b4eb

      # Noctalia dynamic theme integration
      include themes/noctalia.conf
    '';
  };
}
