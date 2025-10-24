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

        # Symlink your config dir into the store (handles subfiles automatically)
        # configDir = pkgs.symlinkJoin {
        #   name = "neovim-config";
        #   paths = [ "${./.}" ];
        # };

        configDir = pkgs.runCommand "neovim-config" {} ''
          mkdir -p $out/lua $out/after $out/plugin  # Create subdirs
          cp ${./init.lua} $out/init.lua
          cp -r ${./lua}/* $out/lua/
          cp -r ${./after}/* $out/after/  # If after/ exists
          cp -r ${./plugin}/* $out/plugin/  # If plugin/ exists
        '';

        neovimConfig = pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped {
          configure = {
            customRC = ''
	      vim.notify('LuaRC starting', vim.log.levels.INFO)
              vim.opt.runtimepath:prepend('${configDir}')
              vim.opt.runtimepath:append('${configDir}/after')
              vim.opt.runtimepath:append('${configDir}/plugin')
              vim.notify('rtp set: ' .. vim.inspect(vim.opt.runtimepath:get()), vim.log.levels.INFO)
              vim.notify('Sourcing init.lua', vim.log.levels.INFO)
              dofile('${configDir}/init.lua')  -- Lua equivalent of luafile
              vim.notify('LuaRC done', vim.log.levels.INFO)
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
