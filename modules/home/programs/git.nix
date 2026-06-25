{ ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Gabriel de Souza";
        email = "gabrln@users.noreply.github.com";
      };
      init = {
        defaultBranch = "experimental";
      };
      pull = {
        ff = "only";
      };
      diff = {
        algorithm = "histogram";
      };
      push = {
        autoSetupRemote = true;
      };
      merge = {
        conflictstyle = "zdiff3";
      };
    };
  };

  # Delta config is now under programs.delta in modern Home Manager
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      line-numbers = true;
      side-by-side = true;
      theme = "ansi"; # Uses terminal colors to match Noctalia theme
    };
  };
}
