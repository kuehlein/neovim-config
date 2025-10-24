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

  outputs = { self, flake-utils, nixpkgs, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
	plugins = import ./plugins.nix { inherit pkgs; };

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

        neovimConfig = pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped {
          configure = {
            customRC = ''
	      lua << EOF
              vim.opt.runtimepath:prepend('${configDir}')
              dotfile('${configDir}/init.lua')
	      EOF
            '';
            packages.myPlugins = {
              start = plugins.plugins;
            };
          };
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











# {
#   description = "Neovim config.";
#
#   inputs = {
#     flake-utils.url = "github:numtide/flake-utils";
#     nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
#   };
#
#   outputs = inputs @ { self, flake-utils, nixpkgs, ... }:
#     flake-utils.lib.eachDefaultSystem (system:
#     let
#       pkgs = nixpkgs.legacyPackages.${system};
#       pluginsModule = import ./plugins.nix { inherit pkgs; };
#
#       configDir = pkgs.runCommand "nvim-config" {} ''
#         mkdir -p $out/share/nvim-config
#
#         echo "Running configDir build" > $out/debug.txt
#         if [ -f ${./init.lua} ]; then
#           cp ${./init.lua} $out/share/nvim-config/init.lua
#         else
#           echo "init.lua not found in repo" > $out/error.txt
#         fi
#
#         ${pkgs.lib.optionalString (builtins.pathExists ./lua) "cp -r ${./lua} $out/share/nvim-config/lua || true"}
#         ${pkgs.lib.optionalString (builtins.pathExists ./plugin) "cp -r ${./plugin} $out/share/nvim-config/plugin || true"}
#         ${pkgs.lib.optionalString (builtins.pathExists ./after) "cp -r ${./after} $out/share/nvim-config/after || true"}
#
#         ls -R $out > $out/contents.txt || echo "Failed to list output" >> $out/error.txt
#       '';
#
#       neovimConfig = pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped {
#         configure = {
#           luaRcContent = ''
#             vim.opt.runtimepath:prepend("${configDir}/share/nvim-config")
#             vim.cmd('source ${configDir}/share/nvim-config/init.lua')
#           '';
#           packages.all.start = pluginsModule.plugins;
#         };
#         extraMakeWrapperArgs = [ "--prefix" "PATH" ":" (pkgs.lib.makeBinPath pluginsModule.extraPackages) ];
#       };
#
#     in {
#       packages = {
#         default = neovimConfig; # `nix build .#default` builds this
#         neovim-config = neovimConfig; # Alias for clarity
#       };
#
#       # # TODO: what is this for?
#       # devShells.default = pkgs.mkShell {
#       #   packages = [ customNeovim ];
#       # };
#     });
# }
