{ pkgs, ... }:

{
  # Ananicy-cpp: auto nice daemon for process priority management
  services.ananicy = {
    enable = true;
    package = pkgs.ananicy-cpp;
  };
}