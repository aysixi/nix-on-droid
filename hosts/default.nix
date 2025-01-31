{ inputs, self, ... }:
{
  flake.nixOnDroidConfigurations =
    let
      mi = import ../mi.nix;
    in
    let
      nixDro = inputs.nix-on-droid.lib.nixOnDroidConfiguration;
      # inherit (inputs.nixpkgs.lib) nixosSystem;
      homeImports = "${self}/home";
      mod = "${self}/system";
      specialArgs = {
        inherit inputs self mi;
      };
    in
    {
      android = nixDro {
        extraSpecialArgs = specialArgs;
        modules = [
          "${mod}/nix"
          "${mod}/core"
          # "${mod}/core/nixpkgs.nix"
          {
            home-manager = {
              config = homeImports;
              backupFileExtension = "hm-bak";
              # useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = specialArgs;
            };
          }
        ];
        pkgs = import inputs.nixpkgs {
          system = "aarch64-linux";
          overlays = [
            (final: prev: {
              aysixi = inputs.aysixi.packages."${prev.system}";
            })
            inputs.nix-on-droid.overlays.default
          ];
        };
        home-manager-path = inputs.home-manager.outPath;
      };
    };
}
