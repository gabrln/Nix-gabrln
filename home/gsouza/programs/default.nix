{ config, pkgs, ... }:

{
  imports = [
    ./kitty.nix
    ./zsh.nix
    ./starship.nix
    ./yazi.nix
    ./zellij.nix
    ./fastfetch.nix
    ./nvim.nix
  ];
}
