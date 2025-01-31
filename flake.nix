{
  description = "Advanced example of Nix-on-Droid system config with home-manager.";

  outputs =
    inputs@{ self, ... }:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      debug = true;
      systems = [
        # "x86_64-linux"
        "aarch64-linux"
      ];
      imports =
        [
          ./hosts
          # To import a flake module
          # 1. Add foo to inputs
          # 2. Add foo as a parameter to the outputs function
          # 3. Add here: foo.flakeModule
        ]
        ++ [
          inputs.flake-root.flakeModule
          inputs.treefmt-nix.flakeModule
        ];
      flake = {
        # overlays.default = selfPkgs.overlay;
        overlays.default = inputs.nix-on-droid.overlays.default;
      };
      # systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem =
        {
          config,
          pkgs,
          system,
          ...
        }:
        {
          # NOTE: These overlays apply to the Nix shell only. See `modules/nix.nix` for system overlays.
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [
              #inputs.foo.overlays.default
            ];
          };

          treefmt.config = {
            inherit (config.flake-root) projectRootFile;
            flakeCheck = true;
            settings = {
              global.excludes = [
                "*.png"
                "*.conf"
                "*.rasi"
                "*.fish"
                "justfile"
                "*.dae"
              ];
            };
            package = pkgs.treefmt;
            programs.nixfmt-rfc-style.enable = true;
            programs.prettier.enable = true;
            programs.taplo.enable = true;
            programs.shfmt.enable = true;
            programs.stylua = {
              enable = true;
              settings = {
                indent_type = "Spaces";
                indent_width = 2;
              };
            };
          };

          devShells = {
            # run by `nix devlop` or `nix-shell`(legacy)
            # Temporarily enable experimental features, run by`nix develop --extra-experimental-features nix-command --extra-experimental-features flakes`
            default = pkgs.mkShell {
              nativeBuildInputs = with pkgs; [
                git
                neovim
                sbctl
                just
              ];
              inputsFrom = [
                config.flake-root.devShell
              ];
            };
            # run by `nix develop .#<name>`
            # NOTE: Here are some of the steps I documented, see `https://github.com/Mic92/sops-nix` for more details
            # ```
            # mkdir -p ~/.config/sops/age
            # age-keygen -o ~/.config/sops/age/keys.txt
            # age-keygen -y ~/.config/sops/age/keys.txt
            # sudo mkdir -p /var/lib/sops-nix
            # sudo cp ~/.config/sops/age/keys.txt /var/lib/sops-nix/keys.txt
            # nvim $FLAKE_ROOT/.sops.yaml
            # mkdir $FLAKE_ROOT/secrets
            # sops $FLAKE_ROOT/secrets/secrets.yaml
            # ```
            secret = pkgs.mkShell {
              name = "secret";
              nativeBuildInputs = with pkgs; [
                sops
                age
                neovim
                ssh-to-age
              ];
              shellHook = ''
                export $EDITOR=nvim
                export PS1="\[\e[0;31m\](Secret)\$ \[\e[m\]"
              '';
              inputsFrom = [
                config.flake-root.devShell
              ];
            };
          };
          # used by the `nix fmt` command
          formatter = config.treefmt.build.wrapper;
        };
    };

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-root.url = "github:srid/flake-root";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvim-flake.url = "github:aysixi/nvim-flake";
    nixd.url = "github:nix-community/nixd";
    rust-overlay.url = "github:oxalica/rust-overlay";
    aysixi = {
      url = "github:aysixi/nur-packages";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
