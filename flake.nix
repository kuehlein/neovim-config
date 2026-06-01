{
  description = "Neovim config";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Third-party flake for up-to-date Claude Code (see docs/TECH_DEBT.md)
    claude-code-nix.url = "github:sadjow/claude-code-nix";
  };

  outputs =
    {
      self,
      flake-utils,
      nixpkgs,
      claude-code-nix,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        plugins = import ./plugins.nix { inherit pkgs; };

        languageServers = with pkgs; [
          bash-language-server # Bash
          clang-tools # C
          dart # Dart (Flutter)
          # haskell-language-server # Haskell (provided by project environment)
          lua-language-server # Lua
          nil # Nix
          rust-analyzer # Rust
          sqls # SQL
          taplo # TOML
          typescript-language-server # Typescript/Javascript
          vscode-langservers-extracted # CSS, HTML, JSON
          yaml-language-server # YAML
        ];

        tools = [
          claude-code-nix.packages.${system}.default # Claude Code CLI (always up-to-date)
        ];

        # Symlink config dir into the store
        configDir = pkgs.stdenv.mkDerivation {
          name = "neovim-config";
          src = ./.;
          installPhase = ''
            mkdir -p $out
            cp -r lua $out/
            cp -r after $out/
            cp -r docs $out/
            # cp -r plugin $out/
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
                --prefix PATH : ${pkgs.lib.makeBinPath (languageServers ++ tools)}
            '';
          };

      in
      {
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
