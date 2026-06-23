{ config, pkgs, ... }:

{
  imports = [
    ./mango.nix
    ./noctalia.nix
  ];
}
