# TODO: config to make this work for non-linux? (do this later)
# TODO: clean up git history
# TODO: version 1.0.0
# TODO: protected branch, github actions, etc?
# TODO: linting requirements?

# TODO: when completion menu opens, make it select first option by default?
# TODO: mini.ai `t` seems to not really work well
# TODO: dadbod
# TODO: mini.snippets

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

        languageServers = with pkgs; [
          bash-language-server # Bash
          clang-tools # C
          haskell-language-server # Haskell
          lua-language-server # Lua
          nil # Nix
          rust-analyzer # Rust
          taplo # TOML
          typescript-language-server # Typescript/Javascript
          vscode-langservers-extracted # CSS, HTML, JSON
          yaml-language-server # YAML
        ];

        # Symlink your config dir into the store
        configDir = pkgs.stdenv.mkDerivation {
          name = "neovim-config";
          src = ./.;
          installPhase = ''
            mkdir -p $out
            cp -r lua $out/
            cp -r after $out/
            cp -r plugin $out/
            cp init.lua $out/
          '';
        };

        customRC = ''
          set runtimepath^=${configDir}
          set runtimepath+=${configDir}/after

          lua << EOF
          dofile('${configDir}/init.lua')
          EOF
        '';

        neovimConfig =
          let
            baseNeovimConfig = pkgs.neovimUtils.makeNeovimConfig {
              customRC = customRC;
              plugins = plugins.plugins;
            };
            wrappedNeovimConfig = pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped baseNeovimConfig;
          in
            pkgs.symlinkJoin {
              buildInputs = [ pkgs.makeWrapper ];
              name = "neovim-with-lsp";
              paths = [ wrappedNeovimConfig ];
              postBuild = ''
                wrapProgram $out/bin/nvim \
                  --prefix PATH : ${pkgs.lib.makeBinPath languageServers}
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
