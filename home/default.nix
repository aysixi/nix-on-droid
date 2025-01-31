{
  config,
  lib,
  pkgs,
  inputs,
  self,
  ...
}:

{
  # Read the changelog before changing this value
  home.stateVersion = "23.11";

  imports = [
    ./shell
    ./editors
    ./programs
    ../system/nix/nixpkgs.nix
  ] ++ [ inputs.nix-index-database.hmModules.nix-index ];

  home.file.".config/nix/nix.conf".text = ''
    builders-use-substitutes = true
  '';

  # insert home-manager config
}
