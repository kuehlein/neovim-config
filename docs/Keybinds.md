# Keybindings

## Keybindings Index

**Quick Navigation:**
- [Navigation Overwrites](#navigation-overwrites) - Colemak DH adaptations
- [General Overwrites](#general-overwrites) - Quality of life improvements
- [File Navigation & Search](#file-navigation--search) - Finding files and content
- [Oil.nvim](#oilnvim) - File explorer
- [Completion](#completion) - Autocompletion menu
- [Harpoon](#harpoon) - Quick file switching
- [Git](#git-vim-fugitive) - Version control
- [LSP & Treesitter](#lsp--treesitter) - Code intelligence
- [Mini.ai](#miniai-textobjects) - Text objects
- [Undotree](#undotree) - Undo history
- [Markdown Preview](#markdown-preview) - Live preview
- [Snippets](#snippets) - Code templates
- [Custom Commands](#custom-commands) - Layout switching
- [Miscellaneous](#miscellaneous) - Other utilities
- [Built-in Keybindings](#built-in-keybindings-worth-remembering) - Neovim defaults

---

**Quick Reference - Most Used:**
| Action | Key | Plugin |
|--------|-----|--------|
| Leader key | `Space` | |
| Find files | `<leader>ff` | Fuzzy finder |
| Live grep | `<leader>fg` | Fuzzy finder |
| File explorer | `<leader>-` | Oil.nvim |
| Quick files | `<leader><leader>` | Harpoon |
| Select quick files | `<C-1>`-`<C-5>` | Harpoon |
| Git status | `<leader>gs` | Fugitive |
| Go to definition | `gd` | LSP |
| Show references | `grr` | LSP |
| Show docs | `K` | LSP |
| Rename symbol | `grn` | LSP |
| Code action | `gra` | LSP |
| Format code | `<leader>f` | LSP |
| Diagnostics | `<leader>e` | LSP |
| Next/Prev Diagnostic | `]d`/`[d` | LSP |


---

## Navigation Overwrites

*Changes to default Vim behavior due to [Colemak DH layout](ColemakDH.md)*

- **`hjkl` → `mnei`** - Navigation keys remapped for Colemak DH. See [Colemak DH Notes](ColemakDH.md) for details.

- **`n`/`N` → `;`/`,`** - Search next/previous remapped due to navigation conflicts.
  - `;` - Jump to next search result (centers page)
  - `,` - Jump to previous search result (centers page)

- **`<C-m> + <char>`** - Toggle mark in local buffer (a-z marks).
  - Default `m` command overwritten due to Colemak DH navigation.
  - Enhanced with toggle functionality: press again on same line to remove mark.
  - For global marks across files, use [Harpoon](#harpoon).

---

## General Overwrites

*Quality of life improvements to default Vim behavior*

- **`<C-d>`** - Page down and centers page
- **`<C-u>`** - Page up and centers page
- **`J`** - Join lines while preserving cursor position
- **`Q`** - Disabled (Ex mode)

---

## File Navigation & Search

- `<leader>ff` - Find files
- `<leader>fg` - Live grep (search in files)
- `<leader>fb` - Find buffers
- `<leader>fh` - Search help tags
- `<leader>fo` - Recent files

---

## Oil.nvim

- `<leader>-` - Open parent directory
- `<CR>` - Select file/directory
- `<C-p>` - Open/close preview
- `<C-r>` - Refresh display

---

## Completion

- `<C-n>` - Next item in completion menu
- `<C-e>` - Previous item in completion menu
- `<C-y>` - Accept selected completion
- `<C-Space>` - Force two-step completion

---

## Harpoon

*Quick file navigation*

- `<leader>a` - Add current buffer to Harpoon list
- `<leader><leader>` - Open Harpoon file list
- `<C-1>` through `<C-5>` - Jump to file 1-5 in list
- `<C-n>` - Next file in Harpoon list
- `<C-p>` - Previous file in Harpoon list

---

## Git (vim-ugitive)

- `<leader>gs` - Git status
- `<leader>gc` - Git commit
- `<leader>gp` - Git push
- `<leader>gl` - Git pull
- `<leader>gb` - Git blame
- `<leader>gd` - Git diff

---

## LSP & Treesitter

**Navigation**
- `gd` - Go to definition
- `gD` - Go to declaration
- `gri` - Go to implementation
- `grr` - Show references
- `gt` - Go to type definition

**Information**
- `K` - Hover documentation
- `<C-k>` - Signature help
- `gO` - Document symbols

**Editing**
- `grn` - Rename symbol
- `gra` - Code action
- `<leader>f` - Format buffer

**Diagnostics**
- `[d` - Previous diagnostic
- `]d` - Next diagnostic
- `[D` - First diagnostic
- `]D` - Last diagnostic
- `<leader>e` - Show diagnostic (`q` to close)
  - Shortcut for `<C-w>d<C-w>w`

---

## Mini.ai (Textobjects)

*Remapped due to Colemak DH conflicts*

<!-- TODO: this section seems wrong -->
Default `i` (inside) prefix conflicts with navigation, so we use `t` instead:

- `t` - Inside textobject
- `tn` - Inside next textobject
- `tl` - Inside last textobject

**Examples:**
- `dtt` - Delete inside word
- `ct"` - Change inside quotes

---

## Dadbod.vim (Database UI)

- `<leader>db` - Toggle DB UI
- `<leader>df` - Find DB buffer
- `<leader>dr` - Rename DB buffer
- `<leader>de` - Execute query
- `<leader>dq` - Last query info

---

## Undotree

- `<leader>u` - Toggle Undotree

---

## Markdown Preview

- `<leader>tp` - Toggle preview (for `.md` files)

---

## Snippets

### Global
*Coming soon*

### Rust
*Coming soon*

### Lua
*Coming soon*

---

## Custom Commands

- `:Colemak` - Enable Colemak DH keybindings (default)
- `:Qwerty` - Switch to QWERTY keybindings

See [Colemak DH Notes](ColemakDH.md) for layout details.

---

## Miscellaneous

- `<leader>p` - Paste without yanking to clipboard
- `<leader>d` - Delete without yanking to clipboard
- `+` / `-` - Increment/decrement number under cursor
