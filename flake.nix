# TODO: read the nix flake guide: https://vtimofeenko.com/posts/practical-nix-flake-anatomy-a-guided-tour-of-flake.nix/
#   - create a flake that works with nixos and without it
#   - streamline neovim config
#      - minimize plugins
#      - no useless config
#      - switch to gruvbox theme

# TODO: config to make this work for non-linux? (do this later)

# TODO: update symbol layer
#         - move = onto home row?
#         - fix ' and "
#             - ! <=> `
#             - ? <=> '
#             - not sure..
#         - homerow mods?

# TODO: clean up github repos & history

# TODO: proceed with nixos config
#    - seems cool: https://github.com/Mjoyufull/fsel
#    - rice zsh

{
  description = "Neovim config.";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = inputs @ { self, flake-utils, nixpkgs, ... }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      pluginsMod = import ./plugins.nix { inherit pkgs };

      # Package your entire config dir (init.lua + subdirs) into a derivation
      # This copies everything to $out, preserving structure
      configDir = pkgs.runCommand "nvim-config" {} ''
        mkdir -p $out
        cp ${./init.lua} $out/init.lua
        cp -r ${./lua} $out/lua
        cp -r ${./plugin} $out/plugin
        cp -r ${./after} $out/after
      '';

      neovimConfig = pkgs.wrapNeovimUnstable pkgs.neovim-unstable {
        configure = {
          customRC = ''
            lua vim.opt.runtimepath:prepend("${configDir}")
            luafile ${configDir}/init.lua
          '';
          extraMakeWrapperArgs = [ "--prefix" "PATH" ":" (pkgs.lib.makeBinPath pluginsMod.extraPackages) ];
          packages.all.start = pluginsMod.plugins;
        };
      };
    in {
      packages = {
        default = neovimConfig; # `nix build .#default` builds this
        neovim = neovimConfig; # Alias for clarity
      };

      # # TODO: what is this for?
      # devShells.default = pkgs.mkShell {
      #   packages = [ customNeovim ];
      # };
    });
}
