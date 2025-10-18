# TODO: new plugins?
#        - mini.snippets (or lua snips?)
#        - mini.keymap?
#        - mini.pairs?
#        - basically anything mini? should probably be one of the last things to do

{ pkgs }:
let
  inherit (pkgs) vimPlugins vimUtils;

  # TODO: do we want the latest version of harpoon?
  # harpoon-2 = vimUtils.buildVimPlugin {
  #   pname = "harpoon";
  #   src = pkgs.fetchFromGitHub {
  #     hash = "sha256-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX="; # replace with output from `nix-prefetch-github`
  #     owner = "ThePrimeagen";
  #     repo = "harpoon";
  #     rev = "harpoon2";
  #   };
  #   version = "unstable";
  # };

  plugins = nixpkgs.lib.unique (builtins.concatLists (builtins.attrValues {
    # TODO: mini.completion?
    autoCompletion = with vimPlugins; [
      cmp-buffer
      cmp_luasnip
      cmp-path
      cmp-nvim-lsp
      cmp-nvim-lua
      lspkind-nvim
      luasnip
      nvim-cmp
    ];

    # TODO: mini.comment?
    comment = with vimPlugins; [
      comment-nvim
    ];

    # TODO: what does this do?
    dadbod = with vimPlugins; [
      vim-dadbod
      vim-dadbod-completion
      vim-dadbod-ui
    ];

    debugger = with vimPlugins; [
      mason-nvim # TODO: what is this?
      nvim-dap
      nvim-dap-go
      nvim-dap-ui
      nvim-dap-virtual-text
      nvim-nio
    ];

    harpoon = with vimPlugins; [
      harpoon # harpoon-2
    ];

    # TODO: does this change now? use easy lsp setup for now
    lsp = with vimPlugins; [
      lua_ls
      nil
      # conform-nvim
      # fidget-nvim
      # mason-lspconfig-nvim
      # mason-tool-installer-nvim
      # neodev-nvim
      # nvim-lspconfig
      # SchemaStore-nvim
    ];

    mini = with vimPlugins; [
      mini-nvim
    ]; 

    neogit = with vimPlugins; [
      diffview-nvim
      neogit
      plenary-nvim
      telescope-nvim
    ];

    # TODO: or fzf-lua??
    search = with vimPlugins; [
      # mini-pick-nvim
    ];

    # TODO: is this ok?
    theme = with vimPlugins; [
      gruvbox-nvim
    ];

    treesitter = with vimPlugins; [
      nvim-treesitter
    ];
  };
in {
  inherit plugins;
};

