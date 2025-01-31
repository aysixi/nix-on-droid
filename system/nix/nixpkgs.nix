{
  inputs,
  self,
  ...
}:
{
  nixpkgs = {
    config = {
      allowBroken = true;
      allowUnsupportedSystem = true;
      allowUnfree = true;
    };
    overlays = [
      inputs.nix-on-droid.overlays.default
      inputs.rust-overlay.overlays.default

      (final: prev: {
        aysixi = inputs.aysixi.packages."${prev.system}";
      })
    ];
  };
}
