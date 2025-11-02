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
  treesitter = (
    vimPlugins.nvim-treesitter.withPlugins (p: [
      p.bash
      p.c
      p.comment
      p.css
      p.haskell
      p.html
      p.javascript
      p.json
      p.lua
      p.nix
      p.rust
      p.toml
      p.tsx
      p.typescript
      p.yaml
    ])
  );

  # Some plugins may require peer dependencies that are duplicates.
  # We filter the duplicates out here.
  plugins = pkgs.lib.unique (
    builtins.concatLists (
      builtins.attrValues {
        autoCompletion = with vimPlugins; [ mini-completion ];
        db = with vimPlugins; [ vim-dadbod vim-dadbod-completion vim-dadbod-ui ];
        git = with vimPlugins; [ mini-diff mini-git vim-fugitive ];
        fileTree = with vimPlugins; [ oil-nvim ];
        fuzzy_find = with vimPlugins; [ fzf-lua ];
        harpoon = with vimPlugins; [ harpoon-2 plenary-nvim ];
        lsp = with vimPlugins; [ nvim-lspconfig ];
        obsidian = with vimPlugins; [ obsidian-nvim ];
        pairs = with vimPlugins; [ mini-pairs ];
        preview = with vimPlugins; [ render-markdown-nvim ];
        snippets = with vimPlugins; [ mini-snippets ];
        textObjects = with vimPlugins; [ mini-ai ];
        theme = with vimPlugins; [ gruvbox-nvim lualine-nvim ];
        treesitter = [ treesitter ];
        undo = with vimPlugins; [ undotree ];
      }
    )
  );
in {
  inherit plugins;
}
