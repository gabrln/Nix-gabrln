{ pkgs, inputs, ... }:
let
  fetchFavicon = { name, url, sha256 }: let
    sanitized = builtins.replaceStrings [" "] ["-"] name;
    matchResult = builtins.match "https?://([^/]+).*" url;
    domain = if matchResult != null then builtins.head matchResult else sanitized;
    rawIcon = pkgs.fetchurl {
      url = "https://www.google.com/s2/favicons?domain=${domain}&sz=256";
      name = "${sanitized}-favicon.png";
      inherit sha256;
    };
  in rawIcon;

  brave-origin = inputs.brave-origin.packages.${pkgs.stdenv.hostPlatform.system}.default;

  mkWebApp = { name, url, sha256 }: let
    iconPath = fetchFavicon { inherit name url sha256; };
  in {
    inherit name;
    exec = "${brave-origin}/bin/brave-origin --start-maximized --app=${url}";
    icon = "${iconPath}";
    terminal = false;
    type = "Application";
    categories = ["Network" "WebBrowser"];
  };

  webApps = [
    {
      name = "Github";
      url = "https://github.com";
      sha256 = "sha256-GoH7+/Co7+CoqaFvCVHmedu9oTH+AUoVAXYFYZmWjgY=";
    }
    {
      name = "Reddit";
      url = "https://www.reddit.com";
      sha256 = "sha256-NjwuoqwsnmBuOG6ihwzxzGtB4Ldr8bHXgy7R98fZDdE=";
    }
  ];
in {
  xdg.desktopEntries = builtins.listToAttrs (map (app: {
    name = app.name;
    value = mkWebApp app;
  }) webApps);
}
