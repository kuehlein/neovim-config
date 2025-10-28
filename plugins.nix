# TODO: new plugins?
#        - mini.snippets (or lua snips?)
#        - mini.keymap?
#        - mini.pairs?
#        - basically anything mini? should probably be one of the last things to do

{ pkgs }:
let
  inherit (pkgs) vimPlugins vimUtils;

  # `harpoon2` is the most up-to-date version, use this unti `harpoon-2` is merged to `master`
  harpoon-2 = vimUtils.buildVimPlugin {
    doCheck = false;
    pname = "harpoon2";
    src = pkgs.fetchFromGitHub {
      hash = "sha256-L7FvOV6KvD58BnY3no5IudiKTdgkGqhpS85RoSxtl7U=";
      owner = "ThePrimeagen";
      repo = "harpoon";
      rev = "harpoon2";
    };
    version = "unstable";
  };

  plugins = pkgs.lib.unique (
    builtins.concatLists (
      builtins.attrValues {
        autoCompletion = with vimPlugins; [
          mini-completion
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
          harpoon-2
          plenary-nvim
        ];

        lsp = with vimPlugins; [
          nvim-lspconfig
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

        theme = with vimPlugins; [
          gruvbox-nvim
        ];

        treesitter = with vimPlugins; [
          nvim-treesitter
        ];
      }
    )
  );
in
{
  inherit plugins;
}
