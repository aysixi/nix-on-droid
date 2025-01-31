{ self, inputs, ... }:
{
  imports = [
    # ./nixpkgs.nix
    ./substituters.nix
  ];
  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
}
