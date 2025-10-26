# TODO: config to make this work for non-linux? (do this later)
# TODO: clean up github repos & history
# TODO: rice zsh

{
  description = "Neovim config.";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, flake-utils, nixpkgs, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        plugins = import ./plugins.nix { inherit pkgs; };

        lspServers = with pkgs; [
          lua-language-server
          nil
        ];

        # Symlink your config dir into the store
        configDir = pkgs.stdenv.mkDerivation {
          name = "neovim-config";
          src = ./.;
          installPhase = ''
            mkdir -p $out
            cp -r lua $out/
            cp -r after $out/
            cp init.lua $out/
          '';
        };

        customRC = ''
          set runtimepath^=${configDir}
          set runtimepath+=${configDir}/after

          lua << EOF
          vim.g.mapleader = " "
          vim.g.maplocalleader = "\\"

          dofile('${configDir}/init.lua')
          EOF
        '';

        neovimConfig = pkgs.wrapNeovim pkgs.neovim-unwrapped {
          configure = {
            customRC = customRC;
            packages.myPlugins.start = plugins.plugins;
          };
          extraMakeWrapperArgs = ''
            --prefix PATH : ${pkgs.lib.makeBinPath lspServers}
          '';
        };

      in {
        packages = {
          default = neovimConfig;
          neovim-config = neovimConfig;
        };

        apps.default = {
          type = "app";
          program = "${neovimConfig}/bin/nvim";
        };

        overlays.default = final: prev: {
          neovim-config = neovimConfig;
        };
      }
    );
}
