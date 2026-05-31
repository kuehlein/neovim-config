# Keybindings

## Keybindings Index

**Quick Navigation:**
- [Navigation Overwrites](#navigation-overwrites) - Colemak DH adaptations
- [General Overwrites](#general-overwrites) - Quality of life improvements
- [File Navigation & Search](#file-navigation--search) - Finding files and content
- [Oil.nvim](#oilnvim) - File explorer
- [Debugging](#debugging) - Debugging (nvim-dap)
- [Claude](#Claude) - Claude integration
- [Floating Terminal](#floating-terminal) - Floating terminal
- [Notepad](#notepad) - Notepad
- [Completion](#completion) - Autocompletion menu
- [Harpoon](#harpoon) - Quick file switching
- [Git](#git-vim-fugitive) - Version control
- [LSP & Treesitter](#lsp--treesitter) - Code intelligence
- [Mini.ai](#miniai-textobjects) - Text objects
- [Flutter](#Flutter) - Flutter app development
- [Dadbod.vim](#dadbodvim) - Database UI
- [Undotree](#undotree) - Undo history
- [Markdown Preview](#markdown-preview) - Live preview
- [Snippets](#snippets) - Code templates
- [Custom Commands](#custom-commands) - Layout switching
- [Miscellaneous](#miscellaneous) - Other utilities

---

**Quick Reference - Most Used:**
| Action | Key | Plugin |
|--------|-----|--------|
| Leader key | `Space` | |
| Find files | `<leader>ff` | Fuzzy finder |
| Live grep | `<leader>fg` | Fuzzy finder |
| File explorer | `-` | Oil.nvim |
| Toggle breakpoints | `<leader>db` | nvim-dap |
| Toggle debug UI | `<leader>du` | nvim-dap |
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

*Changes to default Vim behavior due to [Colemak DH layout](COLEMAKDH.md)*

- `hjkl` → `mnei` - Navigation keys remapped for Colemak DH. See [Colemak DH Notes](COLEMAKDH.md) for details.
  - `<C-p>` → `<C-m>` - Navigation to previous option in menu.
  - `<C-n>` → `<C-i>` - Navigation to next option in menu.

- `n`/`N` → `;`/`,` - Search next/previous remapped due to navigation conflicts.
  - `;` - Jump to next search result (centers page)
  - `,` - Jump to previous search result (centers page)

- `h + <char>` - Toggle mark in local buffer (a-z marks).
  - Default `m` command overwritten due to Colemak DH navigation.
  - Enhanced with toggle functionality: press again on same line to remove mark.
  - For global marks across files, use [Harpoon](#harpoon).

---

## General Overwrites

*Quality of life improvements to default Vim behavior*

- `<C-d>` - Page down and centers page
- `<C-u>` - Page up and centers page
- `'[a-z]` - Jumping to mark centers page
- `J` - Join lines while preserving cursor position
- `Q` - Disabled (Ex mode)

---

## File Navigation & Search

- `<leader>ff` - Find files
- `<leader>fg` - Live grep (search in files)
- `<leader>fb` - Find buffers
- `<leader>fh` - Search help tags
- `<leader>fo` - Recent files

---

## Oil.nvim

- `-` - Open parent directory
- `<CR>` - Select file/directory
- `<C-p>` - Open/close preview
- `<C-r>` - Refresh display

---

## Debugging (nvim-dap)

- `<leader>db` - Toggle breakpoints
- `<leader>dc` - Continue execution
- `<leader>di` - Step into function
- `<leader>do` - Step over line
- `<leader>dO` - Step out of function
- `<leader>dt` - Terminate debug session
- `<leader>du` - Toggle debug UI

---

## AI (claude)

- `<leader>ai` - Toggle the AI terminal window (previous session)
- `<leader>an` - Toggle the AI terminal window (new session)
- `<leader>al` - List previous sessions
- `<leader>am` - Select AI model and open terminal
- `<leader>as` - Send current visual selection to AI
- `<leader>at` - Add file to AI context (in oil/netrw)
- `<leader>aa` - Accept diff changes proposed by AI
- `<leader>ad` - Reject diff changes proposed by AI

---

## Floating Terminal

- `<leader>t` - Open floating terminal
- `<Esc>` - Close floating terminal (state is preserved)

---

## Notepad

- `<leader>n` - Open Notepad
- `<Esc>` - Close Notepad (when open in normal mode)
- `<C-s>` - Save note to workspace root

---

## Completion

- `<C-m>` - Previous item in completion menu
  - `<C-p>` - For Qwerty bindings
- `<C-i>` - Next item in completion menu
  - `<C-n>` - For Qwerty bindings
- `<C-y>` - Accept selected completion
- `<C-Space>` - Show all completions (LSP, snippets, etc.)
- `<C-j>` - Show only snippet completions

---

## Harpoon

*Quick file navigation*

- `<leader>ah` - Add current buffer to Harpoon list
- `<leader><leader>` - Open Harpoon file list
- `<C-1>` through `<C-5>` - Jump to file 1-9 in list
- `<C-m>` - Previous file in Harpoon list (for Colemak bindings)
  - `<C-p>` (For Qwerty bindings)
- `<C-i>` - Next file in Harpoon list (for Colemak bindings)
  - `<C-n>` (for Qwerty bindings)

---

## Git (vim-fugitive)

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
- `gm` - Go to implementation
- `gr` - Show references
- `gy` - Go to type definition

**Information**
- `K` - Hover documentation
- `<C-k>` - Signature help
- `ds` - Document symbols

**Editing**
- `<leader>rn` - Rename symbol
- `<leader>ra` - Code action
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

*Uses default Vim text objects - no conflicts with Colemak!*

Text objects work in operator-pending mode (after `d`, `c`, `y`), which doesn't conflict with Colemak navigation:

- `i` - Inside textobject
- `in` - Inside next textobject
- `il` - Inside last textobject
- `a` - Around textobject

**Examples:**
- `diw` - Delete inside word
- `ci"` - Change inside quotes
- `dab` - Delete around brackets
- `via` - Visual select inside argument

---

## Flutter

- `<leader>ls` - Run Flutter app
- `<leader>lq` - Quit app
- `<leader>ld` - Select device
- `<leader>le` - Select emulator
- `<leader>lr` - Hot reload (fast)
- `<leader>lR` - Hot restart (full)
- `<leader>lo` - Toggle widget outline
- `<leader>ll` - Show dev logs

---

## Dadbod.vim (Database UI)

- `<leader>bo` - Toggle DB UI
- `<leader>bf` - Find DB buffer
- `<leader>br` - Rename DB buffer
- `<leader>bq` - Last query info
- `<leader>ba` - Add new database connection

---

## Undotree

- `<leader>u` - Toggle Undotree

---

## Markdown Preview

- `<leader>pt` - Preview toggle (for `.md` files)

---

## Snippets

**Keybindings:**
- `<C-j>` - Browse available snippets (shows snippet-only completion menu)
- `<Tab>` - Expand snippet / Jump to next tab stop
- `<S-Tab>` - Jump to previous tab stop
- `<CR>` - Exit snippet mode

**How to use snippets:**
1. **Enter INSERT mode**
2. **Either:**
   - Type the prefix (e.g., `fn`, `td`, `p`) and press `<Tab>` to expand
   - Press `<C-j>` to browse all available snippets for current filetype
3. Navigate between tab stops with `<Tab>` (next) and `<S-Tab>` (previous)
4. Press `<CR>` to exit snippet mode when done

**Available for 19 languages:** Bash, C, CSS, Dart, Haskell, HTML, JavaScript, JSON, Lua, Nix, Rust, SCSS, SQL, TOML, TypeScript, YAML

**Common snippet conventions:**
- `td` - TODO comment (adapts to language's comment syntax)
- `p` - Print/log statement (`console.log`, `println!`, `print`, etc.)
- `db` - Debug print (`console.debug`, `dbg!`, `debugPrint`)
- `fn` - Function definition
- `if`/`ie`/`ieie` - If/if-else/if-elseif-else statements
- `for` - For loop (with variants: `fori`, `foro`, `forp`)
- `wl` - While loop
- `tc` - Try-catch block
- `cl` - Class definition

**Global snippets (work in all filetypes):**
- `@date` - Insert current date (YYYY-MM-DD)
- `@time` - Insert current time (HH:MM:SS)
- `@datetime` - Insert date and time

*Note: Full snippet reference available in `lua/config/snippets.lua`*

---

## Custom Commands

- `:Colemak` - Enable Colemak DH keybindings (default)
- `:Qwerty` - Switch to QWERTY keybindings

See [Colemak DH Notes](COLEMAKDH.md) for layout details.

---

## Miscellaneous

- `<leader>p` - Paste without yanking to clipboard
- `<leader>d` - Delete without yanking to clipboard
