{ pkgs, ... }:
{
  home.packages = with pkgs.aysixi; [
    tlock-arrch64
  ];
}
