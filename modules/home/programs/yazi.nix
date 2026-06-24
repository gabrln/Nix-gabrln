{ ... }:

{
  programs.yazi = {
    enable = true;
    shellWrapperName = "y";
    enableZshIntegration = true;
    
    settings = {
      manager = {
        ratio = [ 1 3 4 ];
        sort_by = "natural";
        sort_sensitive = false;
        sort_reverse = false;
        sort_dir_first = true;
        show_hidden = true;
        show_symlink = true;
      };
      preview = {
        tab_size = 2;
        max_width = 1200;
        max_height = 900;
        cache_dir = "";
        image_filter = "triangle";
        image_quality = 75;
        sixel_fraction = 15;
        ueberzug_scale = 1;
        ueberzug_offset = [ 0 0 0 0 ];
      };
      tasks = {
        micro_workers = 10;
        macro_workers = 25;
        bizarre_retry = 5;
        image_alloc = 536870912;
        image_bound = [ 0 0 ];
        suppress_preload = false;
      };
      log = {
        enabled = false;
      };
      opener = {
        edit = [
          { run = "kitty -e nvim \"$@\""; desc = "nvim"; block = true; }
        ];
        open_text = [
          { run = "kitty -e nvim \"$@\""; desc = "nvim"; block = true; }
        ];
        open_image = [
          { run = "swayimg \"$@\""; desc = "swayimg"; }
        ];
        open_video = [
          { run = "mpv \"$@\""; desc = "mpv"; }
        ];
        open_audio = [
          { run = "mpv \"$@\""; desc = "mpv"; }
        ];
        open_pdf = [
          { run = "zathura \"$@\""; desc = "zathura"; }
        ];
        open_archive = [
          { run = "file-roller \"$@\""; desc = "file-roller"; }
        ];
        open_default = [
          { run = "xdg-open \"$@\""; desc = "system default"; }
        ];
      };
      open = {
        rules = [
          { mime = "text/*"; use = "open_text"; }
          { mime = "application/json"; use = "open_text"; }
          { mime = "application/xml"; use = "open_text"; }
          { mime = "application/javascript"; use = "open_text"; }
          { mime = "application/x-sh"; use = "open_text"; }
          { mime = "inode/x-empty"; use = "open_text"; }
          { mime = "image/*"; use = "open_image"; }
          { mime = "video/*"; use = "open_video"; }
          { mime = "audio/*"; use = "open_audio"; }
          { mime = "application/pdf"; use = "open_pdf"; }
          { mime = "application/zip"; use = "open_archive"; }
          { mime = "application/x-tar"; use = "open_archive"; }
          { mime = "application/x-bzip2"; use = "open_archive"; }
          { mime = "application/x-xz"; use = "open_archive"; }
          { mime = "application/x-7z-compressed"; use = "open_archive"; }
          { mime = "application/gzip"; use = "open_archive"; }
          { mime = "application/zstd"; use = "open_archive"; }
          { mime = "application/x-rar"; use = "open_archive"; }
          { mime = "*"; use = "open_default"; }
        ];
      };
    };
    
    
    keymap = {
      manager = {
        keymap = [
          { on = "k"; run = "arrow -1"; desc = "Up"; }
          { on = "j"; run = "arrow 1"; desc = "Down"; }
          { on = "h"; run = "leave"; desc = "Parent dir"; }
          { on = "l"; run = "enter"; desc = "Enter dir / open"; }
          { on = "g g"; run = "arrow -99999999"; desc = "Top"; }
          { on = "G"; run = "arrow 99999999"; desc = "Bottom"; }
          { on = "<C-u>"; run = "arrow -50%"; desc = "Half page up"; }
          { on = "<C-d>"; run = "arrow 50%"; desc = "Half page down"; }
          { on = "f"; run = "jump fzf"; desc = "Jump (fzf)"; }
          { on = "z"; run = "jump zoxide"; desc = "Jump (zoxide)"; }
          { on = "~"; run = "cd ~"; desc = "Home"; }
          { on = "<Enter>"; run = "open"; desc = "Open"; }
          { on = "e"; run = "open --interactive"; desc = "Open interactive"; }
          { on = "E"; run = "open"; desc = "Open with editor"; }
          { on = "<Space>"; run = "toggle"; desc = "Toggle selection"; }
          { on = "v"; run = "visual_mode"; desc = "Visual mode"; }
          { on = "V"; run = "select_all"; desc = "Select all"; }
          { on = "<Esc>"; run = "escape"; desc = "Escape"; }
          { on = "y"; run = "yank"; desc = "Copy"; }
          { on = "x"; run = "yank --cut"; desc = "Cut"; }
          { on = "p"; run = "paste"; desc = "Paste"; }
          { on = "P"; run = "paste --force"; desc = "Paste (overwrite)"; }
          { on = "d"; run = "remove --permanently"; desc = "Delete permanently"; }
          { on = "D"; run = "remove"; desc = "Trash"; }
          { on = "r"; run = "rename"; desc = "Rename"; }
          { on = "a"; run = "create"; desc = "Create file/dir"; }
          { on = "Y"; run = "copy path"; desc = "Copy path"; }
          { on = "c y"; run = "copy path"; desc = "Copy path"; }
          { on = "c n"; run = "copy filename"; desc = "Copy filename"; }
          { on = "c s"; run = "copy stem"; desc = "Copy stem"; }
          { on = "c e"; run = "copy extension"; desc = "Copy extension"; }
          { on = "."; run = "hidden toggle"; desc = "Toggle hidden files"; }
          { on = "s"; run = "search rg"; desc = "Search (ripgrep)"; }
          { on = "S"; run = "search fd"; desc = "Search (fd)"; }
          { on = "<C-r>"; run = "refresh"; desc = "Refresh"; }
          { on = "t"; run = "tab_create --current"; desc = "New tab"; }
          { on = "1"; run = "tab_switch 0"; desc = "Tab 1"; }
          { on = "2"; run = "tab_switch 1"; desc = "Tab 2"; }
          { on = "3"; run = "tab_switch 2"; desc = "Tab 3"; }
          { on = "["; run = "tab_switch -1 --relative"; desc = "Prev tab"; }
          { on = "]"; run = "tab_switch 1 --relative"; desc = "Next tab"; }
          { on = "!"; run = "shell --interactive"; desc = "Shell here"; }
          { on = "q"; run = "quit"; desc = "Quit"; }
          { on = "Q"; run = "quit --no-cwd-file"; desc = "Quit (no cwd)"; }
        ];
      };
      tasks = {
        keymap = [
          { on = "<Esc>"; run = "close"; desc = "Close task manager"; }
          { on = "w"; run = "close"; desc = "Close task manager"; }
          { on = "k"; run = "arrow -1"; desc = "Up"; }
          { on = "j"; run = "arrow 1"; desc = "Down"; }
        ];
      };
      select = {
        keymap = [
          { on = "<Esc>"; run = "close"; desc = "Cancel"; }
          { on = "k"; run = "arrow -1"; desc = "Up"; }
          { on = "j"; run = "arrow 1"; desc = "Down"; }
          { on = "<Enter>"; run = "close --submit"; desc = "Confirm"; }
        ];
      };
      input = {
        keymap = [
          { on = "<Esc>"; run = "close"; desc = "Cancel"; }
          { on = "<Enter>"; run = "close --submit"; desc = "Confirm"; }
          { on = "<Backspace>"; run = "backspace"; desc = "Backspace"; }
          { on = "<C-u>"; run = "kill_line"; desc = "Clear line"; }
          { on = "<C-w>"; run = "backward_kill_word"; desc = "Delete word"; }
          { on = "<Left>"; run = "move -1"; desc = "Left"; }
          { on = "<Right>"; run = "move 1"; desc = "Right"; }
          { on = "<Home>"; run = "move -999"; desc = "Line start"; }
          { on = "<End>"; run = "move 999"; desc = "Line end"; }
        ];
      };
    };
  };

  # Map flavors directory for noctalia.yazi theme
  xdg.configFile."yazi/flavors".source = ../dotfiles/yazi/flavors;
}
