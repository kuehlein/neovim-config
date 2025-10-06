{
  description = "Neovim config & Nix flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixvim.url = "github:nix-community/nixvim";  # NEW: Add nixvim input (pins to latest stable)
  };

  outputs = { self, nixpkgs, nixvim }: let
    system = "x86_64-linux";  # TODO: make this dynamic
    pkgs = nixpkgs.legacyPackages.${system};

    # TODO: do we want the latest version of harpoon?
    # harpoon-2 = pkgs.vimUtils.buildVimPlugin {
    #   pname = "harpoon";
    #   src = pkgs.fetchFromGitHub {
    #     hash = "sha256-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX="; # replace with output from `nix-prefetch-github`
    #     owner = "ThePrimeagen";
    #     repo = "harpoon";
    #     rev = "harpoon2";
    #   };
    #   version = "unstable";
    # };

    # Custom plugin for displaying marks
    marks-plugin = pkgs.vimUtils.buildVimPlugin {
      pname = "marks";
      src = ./plugin;
      version = "local";
    };

    # TODO: currently some plugins have overlapping dependencies (e.g. `neogit` and `telescope` both need `plenary-nvim`)
    # removing one  may remove both if I'm not careful. Is there a better way to do this?
    myPlugins = with pkgs.vimPlugins; [
      # Auto-completion
      nvim-cmp
      lspkind-nvim
      cmp-nvim-lsp
      cmp-path
      cmp-buffer
      cmp-nvim-lua
      luasnip
      cmp_luasnip

      # Comment utility
      comment-nvim

      # Custom plugins
      marks-plugin

      # Debugger
      nvim-dap
      nvim-dap-go
      nvim-dap-ui
      nvim-dap-virtual-text
      nvim-nio
      mason-nvim

      # Harpoon
      harpoon # harpoon-2

      # LSP
      nvim-lspconfig
      neodev-nvim
      mason-lspconfig-nvim
      mason-tool-installer-nvim
      fidget-nvim
      conform-nvim
      SchemaStore-nvim

      # Mini modules
      mini-nvim

      # Neogit
      neogit
      plenary-nvim
      diffview-nvim
      telescope-nvim

      # SQL tools
      vim-dadbod
      vim-dadbod-completion
      vim-dadbod-ui

      # Telescope
      # telescope-nvim # dupe
      # plenary-nvim # dupe
      telescope-fzf-native-nvim
      telescope-smart-history-nvim
      telescope-ui-select-nvim
      sqlite-lua

      # Treesitter
      nvim-treesitter

      # TypeScript tools
      typescript-tools-nvim
    ];

    mkHomeModule = { pkgs, ... }: {
      imports = [ nixvim.homeManagerModules.nixvim ];

      programs.nixvim = {
        enable = true;
        extraPackages = with pkgs; [
          fd
          nixfmt
          ripgrep
        ];
        extraPlugins = myPlugins;

        # TODO: how to just import this as a raw lua file
        # TODO: move `config/` into `init.lua`?
        luaConfig = ''
          ${builtins.readFile ./init.lua}  # Direct import

          -- Additional configuration for plugins (via require)
          require("config.comment")
          require("config.completion")
          require("config.dap")
          require("config.harpoon")
          require("config.lspconfig")
          require("config.mini")
          require("config.neogit")
          require("config.treesitter")
          require("config.typescript")
        '';
      };
    };
  in {
    homeManagerModules.default = mkHomeModule;
    # packages.${system}.default = neovim-config;
  };
}
