{ pkgs, ... }:
let
  jetbrains = pkgs.aysixi.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
  fontPath = "share/fonts/truetype/NerdFonts/JetBrainsMonoNerdFontMono-Regular.ttf";
in
{
  user = {
    uid = 10215;
    gid = 10215;
    #  userName = "android";
    shell = "${pkgs.fish}/bin/fish";
  };
  terminal = {
    font = "${jetbrains}/${fontPath}";
    colors = import ./theme.nix;
  };

}
