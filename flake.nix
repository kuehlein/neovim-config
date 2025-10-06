{
  description = "Neovim config & Nix flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: let
    system = "x86_64-linux";  # Hardcoded for your T490
    pkgs = nixpkgs.legacyPackages.${system};

    # harpoon-2 = pkgs.vimUtils.buildVimPlugin {
    #   pname = "harpoon";
    #   src = pkgs.fetchFromGitHub {
    #     hash = "sha256-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX=";  # Replace with output from nix-prefetch-github (see Step 2)
    #     owner = "ThePrimeagen";
    #     repo = "harpoon";
    #     rev = "harpoon2";
    #   };
    #   version = "unstable";
    # };

    # Custom plugin for displaying marks
    marks-plugin = pkgs.vimUtils.buildVimPlugin {
      pname = "marks";
      src = ./plugin;  # Directory containing marks.lua (Nix expects a dir with lua/ or plugin/ subdirs ideally)
      version = "local";
    };

    # Custom Neovim with plugins
    neovim-config = pkgs.neovim.override {
      configure = {
        packages.myPlugins = with pkgs.vimPlugins; {
          start = [
            # Auto-completion and related
            nvim-cmp
            lspkind-nvim
            cmp-nvim-lsp
            cmp-path
            cmp-buffer
            cmp-nvim-lua
            luasnip
            cmp-luasnip

            # Comment utility
            Comment-nvim

            # Custom plugins
            marks-plugin

            # Debugger and related
            nvim-dap
            nvim-dap-go
            nvim-dap-ui
            nvim-dap-virtual-text
            nvim-nio
            mason-nvim

            # Harpoon
            harpoon # Uncomment and replace with harpoon-2 after Step 2 for latest version

            # LSP and related
            nvim-lspconfig
            neodev-nvim
            mason-lspconfig-nvim
            mason-tool-installer-nvim
            fidget-nvim
            conform-nvim
            SchemaStore-nvim

            # Mini modules
            mini-nvim

            # Neogit and dependencies
            neogit
            plenary-nvim
            diffview-nvim
            telescope-nvim  # Optional for neogit, but included as dependency

            # SQL tools
            vim-dadbod
            vim-dadbod-completion
            vim-dadbod-ui

            # Telescope and deps/extensions (from your example)
            telescope-nvim
            plenary-nvim
            telescope-fzf-native
            telescope-smart-history-nvim
            telescope-ui-select-nvim
            sqlite-lua  # For smart_history

            # Treesitter
            nvim-treesitter

            # TypeScript tools
            typescript-tools-nvim
          ];
          opt = [];
        };

        # TODO: how to just import this as raw lua file?
        customRC = ''
          lua << EOF

          ${builtins.readFile ./init.lua}

          -- Additional configuration for plugins
          require("config.comment")
          require("config.completion")
          require("config.dap")
          require("config.harpoon")
          require("config.lspconfig")
          require("config.mini")
          require("config.neogit")
          require("config.treesitter")
          require("config.typescript")

          EOF
        '';
      };
    };

    mkHomeModule = { pkgs, ... }: {
      programs.neovim = {
        enable = true;
        package = neovim-config;  # Direct reference—no self or system needed
        extraPackages = with pkgs; [
          fd
          nixfmt
          ripgrep
        ];
      };
    };
  in {
    homeManagerModules.default = mkHomeModule;
    packages.${system}.default = neovim-config;
  };
}
