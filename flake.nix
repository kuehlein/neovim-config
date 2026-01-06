# TODO: clean up git history
# TODO: version 1.0.0
# TODO: protected branch, github actions, etc?
# TODO: change log, versioning, etc.
# TODO: linting requirements (via CI)
# TODO: check for updates for plugins/neovim (and add docs for this)

# TODO: consider ayu theme
# TODO: some lsp functionality doesn't seem to work in rust...? (e.g. `gd`)
# TODO: harpoon keybinds conflict with <C-e> for moving page (<C-e> and <C-y>)
# TODO: mini.ai `t` seems to not really work well
# TODO: mini.snippets
# TODO: completion menu is kinda fucked... sometimes it inserts these weird characters?
# TODO: have ai generate types for lua code
# TODO: add git shortcuts
# TODO: shortcut for `:term` (<leader>t?) - maybe in floating window?
# TODO: decrement under cursor keymap is overwritten by oil.nvim
# TODO: improve obsidian configuration

{
  description = "Neovim config";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    {
      self,
      flake-utils,
      nixpkgs,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
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
          sqls # SQL
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
                --prefix PATH : ${pkgs.lib.makeBinPath languageServers}
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
