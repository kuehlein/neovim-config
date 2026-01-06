# Colemak DH Accommodations

This document describes keybinding changes made to accommodate the Colemak DH keyboard layout in Neovim.

## Colemak DH Accommodations - Index

**Quick Navigation:**
- [Core Philosophy](#core-philosophy) - Why and how we remap
- [Navigation Remaps](#navigation-remaps) - All movement keys
  - [Basic Movement](#basic-movement) - `mnei` for `hjkl`
  - [Display Line Movement](#display-line-movement-with-wrap) - `g` prefix movements
  - [Screen Scrolling](#screen-scrolling) - `z` prefix scrolling
  - [Window Navigation](#window-navigation) - `<C-w>` prefix
- [Cascading Remaps](#cascading-remaps) - Displaced commands
  - [Insert Mode](#insert-mode) - `t` for insert
  - [Word Movement](#word-movement) - `l` for end
  - [Marks](#marks) - `h` for marks
- [Search Navigation](#search-navigation) - `;` and `,` for search
- [Plugin Accommodations](#plugin-accommodations) - Plugin-specific changes
  - [Mini.ai](#miniai-textobjects) - `t` for textobjects
- [Switching Layouts](#switching-layouts) - Toggle between layouts
- [Resources](#resources) - External links

---

**Quick Reference - Key Remaps:**

| Category | Colemak DH | QWERTY | Why Changed |
|----------|------------|--------|-------------|
| **Navigation** | `mnei` | `hjkl` | Core Colemak adaptation |
| **Insert** | `t` / `T` | `i` / `I` | `i` used for navigation |
| **End of word** | `l` | `e` | `e` used for navigation |
| **Search next** | `;` / `,` | `n` / `N` | `n` used for navigation |
| **Marks** | `<C-m>` | `m` | `m` used for navigation |
| **Textobjects** | `t` | `i` | `i` used for navigation |


---

## Core Philosophy

Colemak DH places home row keys differently than QWERTY. To maintain ergonomic navigation while preserving Vim's modal editing philosophy, we remap navigation keys and cascade the changes to maintain consistency.

**Primary Navigation Remap:**
- `hjkl` (QWERTY) → `mnei` (Colemak DH)

This creates conflicts with existing Vim commands, which are then remapped to maintain functionality.

---

## Navigation Remaps

### Basic Movement

| Colemak DH | QWERTY | Action |
|------------|--------|--------|
| `m` | `h` | Move left |
| `n` | `j` | Move down |
| `e` | `k` | Move up |
| `i` | `l` | Move right |

### Display Line Movement (with wrap)

| Colemak DH | QWERTY | Action |
|------------|--------|--------|
| `gm` | `gh` | Move left (display line) |
| `gn` | `gj` | Move down (display line) |
| `ge` | `gk` | Move up (display line) |
| `gi` | `gl` | Move right (display line) |

### Screen Scrolling

| Colemak DH | QWERTY | Action |
|------------|--------|--------|
| `zm` | `zh` | Scroll screen left |
| `zn` | `zj` | Scroll screen down |
| `ze` | `zk` | Scroll screen up |
| `zi` | `zl` | Scroll screen right |
| `zM` | `zH` | Scroll screen all the way left |
| `zI` | `zL` | Scroll screen all the way right |

### Window Navigation

| Colemak DH | QWERTY | Action |
|------------|--------|--------|
| `<C-w>m` | `<C-w>h` | Move to left window |
| `<C-w>n` | `<C-w>j` | Move to below window |
| `<C-w>e` | `<C-w>k` | Move to above window |
| `<C-w>i` | `<C-w>l` | Move to right window |

### Menu Navigation

| Colemak DH | QWERTY | Action |
|------------|--------|--------|
| `<C-n>` | `<C-n>` (unchanged) | Move to next item |
| `<C-e>` | `<C-p>` | Move to previous item |

---

## Cascading Remaps

*Commands displaced by navigation keys are remapped to maintain their functionality*

### Insert Mode

| Colemak DH | QWERTY | Action | Mnemonic |
|------------|--------|--------|----------|
| `t` | `i` | Enter insert mode | **t**ype |
| `T` | `I` | Insert at beginning of line | **T**ype at start |

### Word Movement

| Colemak DH | QWERTY | Action | Mnemonic |
|------------|--------|--------|----------|
| `l` | `e` | Move to end of word | **l**ast character |

<!-- TODO: should we use `h` or just `<C-m>?` -->
### Marks

| Colemak DH | QWERTY | Action | Mnemonic |
|------------|--------|--------|----------|
| `h` | `m` | Set mark | **h**ighlight position |

**Note:** Due to `m` being used for navigation, the standard `m<char>` mark command is remapped to `h<char>` for local marks. See [Keybindings](Keybinds.md#navigation-overwrites) for details.

---

## Search Navigation

Standard search repeat commands are remapped due to `n` being used for downward navigation:

| Colemak DH | QWERTY | Action |
|------------|--------|--------|
| `;` | `n` | Next search result |
| `,` | `N` | Previous search result |

---

## Plugin Accommodations

### Mini.ai (Textobjects)

The default `i` prefix for "inside" textobjects conflicts with right navigation. We remap to use `t` instead:

| Colemak DH | QWERTY | Action | Mnemonic |
|------------|--------|--------|----------|
| `t` | `i` | Inside textobject | **t**extobject / **t**ype |
| `tn` | `in` | Inside next textobject | |
| `tl` | `il` | Inside last textobject | |

**Examples:**
- `dtw` - Delete inside word
- `ct"` - Change inside quotes
- `vab` - Visual select around brackets

---

## Switching Layouts

Use these commands to toggle between layouts:

- `:Colemak` - Enable Colemak DH keybindings (default)
- `:Qwerty` - Revert to standard QWERTY keybindings

---

## Resources

- [Colemak Mod-DH Official Site](https://colemakmods.github.io/mod-dh/)
