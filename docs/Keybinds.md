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
| Find files | `<leader>ff` | Fuzzy finder |
| Live grep | `<leader>fg` | Fuzzy finder |
| File explorer | `<leader>-` | Oil.nvim |
| Quick files | `<leader><leader>` | Harpoon |
| Git status | `<leader>gs` | Fugitive |
| Format code | `<leader>f` | LSP |
| Show docs | `K` | LSP |
| Diagnostics | `<leader>e` | LSP |

---

**Leader key:** `Space`

---

## Navigation Overwrites

*Changes to default Vim behavior due to [Colemak DH layout](ColemakDH.md)*

- **`hjkl` → `mnei`** - Navigation keys remapped for Colemak DH. See [Colemak DH Notes](ColemakDH.md) for details.

- **`n`/`N` → `;`/`,`** - Search next/previous remapped due to navigation conflicts.
  - `;` - Jump to next search result (centers page)
  - `,` - Jump to previous search result (centers page)
  <!-- TODO: `;` and `,` don't seem to be working -->

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

- `K` - Show hover documentation

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

- `<leader>e` - Open diagnostics window (`:q` to close)
- `<leader>f` - Format current buffer
- `<leader>p` - Paste without yanking to clipboard
- `<leader>d` - Delete without yanking to clipboard
- `+` / `-` - Increment/decrement number under cursor

---

## Built-in Keybindings Worth Remembering

**Diagnostics** (available by default in Neovim):
- `]d` - Next diagnostic
- `[d` - Previous diagnostic  
- `]D` - Last diagnostic in buffer
- `[D` - First diagnostic in buffer
- `<C-w>d` - Show diagnostic in floating window
<!-- TODO: also <leader>e does same thing as above, except moves cursor to the menu  -->

**Miscellaneous:**
- `gx` - Open URL under cursor in browser
