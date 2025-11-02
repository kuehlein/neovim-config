# neovim-config

Personal Neovim configuration built with Nix, optimized for the Colemak DH keyboard layout.

**Key Features:**
- **Nix-managed** - Reproducible, declarative configuration
- **Colemak DH optimized** - All keybindings adapted for Colemak DH
- **LSP** - Full language server support
- **Gruvbox theme** - Easy on the eyes

---

## Plugins

**Core Functionality:**
- **mini.nvim** - Lightweight plugin suite (completion, pairs, icons, diff, git, ai, snippets)
- **nvim-lspconfig** - LSP client configuration
- **nvim-treesitter** - Advanced syntax highlighting

**Navigation & Search:**
- **fzf-lua** - Fuzzy finder
- **harpoon** - Quick file switching
- **oil.nvim** - File explorer as a buffer

**Git:**
- **vim-fugitive** - Git integration
- **mini.diff** - Git diff in sign column
- **mini.git** - Additional Git helpers

**Editing:**
- **mini.pairs** - Auto-close brackets/quotes
- **mini.ai** - Enhanced text objects
- **undotree** - Visual undo history

**Theme & UI:**
- **gruvbox.nvim** - Colorscheme
- **lualine.nvim** - Statusline
- **mini.icons** - File/LSP icons

**Markdown & Notes:**
- **render-markdown.nvim** - In-editor markdown rendering
- **obsidian.nvim** - Obsidian vault integration

---

## Documentation

**[Keybindings Reference](docs/Keybinds.md)** - Complete list of all keybindings and commands

**[Colemak DH Guide](docs/ColemakDH.md)** - How navigation keys are remapped and why

**[Adding Languages](docs/Languages.md)** - How to add support for new languages

---

## Structure
```
.
├── flake.nix              # Nix flake & plugin management
├── plugins.nix            # Plugin declarations
├── init.lua               # Main entry point
├── lua/
│   ├── config/
│   │   ├── completion.lua # Mini.completion setup
│   │   ├── fzf.lua        # Fuzzy finder
│   │   ├── harpoon.lua    # Quick file navigation
│   │   ├── lsp.lua        # Language server configuration
│   │   ├── obsidian.lua   # Note-taking
│   │   ├── oil.lua        # File explorer
│   │   ├── preview.lua    # Markdown preview
│   │   ├── snippets.lua   # Code snippets
│   │   ├── treesitter.lua # Syntax highlighting
│   │   └── ...
│   ├── keymaps.lua        # Useful keymaps
│   ├── layouts.lua        # Colemak DH keybindings
│   ├── options.lua        # Vim options
│   ├── overwrite.lua      # Overload existing vim motions
│   └── theme.lua          # Setup theme
├── after/ftplugin/        # Language-specific settings
├── docs/                  # Misc. documentation
└── README.md
```

---

## Installation

**Prerequisites:**
- Nix with flakes enabled

**Quick Start:**
```bash
# Run directly (temporary)
nix shell github:kuehlein/neovim-config

# Or install permanently
nix profile install github:kuehlein/neovim-config
```

**For NixOS users:**
```nix
# In your configuration.nix
environment.systemPackages = [
  (pkgs.callPackage ./path/to/neovim-config {})
];
```

---

## Notes

This is my personal configuration. I haven't made this config with anyone other than myself in mind. Feel free to fork it or copy/paste as you please.
