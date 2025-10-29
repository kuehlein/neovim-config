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

  # Have Nix manage installing language parsers instead of Treesitter
  treesitter = (vimPlugins.nvim-treesitter.withPlugins (p: [
    p.bash
    p.c
    p.comment
    p.css
    p.haskell
    p.html
    p.javascript
    p.json
    p.latex
    p.lua
    p.nix
    p.rust
    p.toml
    p.tsx
    p.typescript
    p.yaml
  ]));

  # TODO: if the list of plugins is actually pretty small, then maybe keep it a list
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

        git = with vimPlugins; [
          gitsigns-nvim
          vim-fugitive
        ];

        fileTree = with vimPlugins; [
          oil-nvim
        ];

        fuzzy_find = with vimPlugins; [
          fzf-lua
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

        snippets = with vimPlugins; [
          mini-snippets
        ];

        textObjects = with vimPlugins; [
          mini-ai
        ];

        theme = with vimPlugins; [
          gruvbox-nvim
        ];

        treesitter = [treesitter];
      }
    )
  );
in
{
  inherit plugins;
}
