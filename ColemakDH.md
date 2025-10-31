# Colemak DH Accommodations

This document describes keybinding changes made to accommodate the Colemak DH keyboard layout in Neovim.

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

**Note:** Due to `m` being used for navigation, the standard `m<char>` mark command is remapped to `<C-m><char>` for local marks. See [Keybindings](Keybinds.md#navigation-overwrites) for details.

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
<!-- TODO: make sure these work?? -->

---

## Switching Layouts

Use these commands to toggle between layouts:

- `:Colemak` - Enable Colemak DH keybindings (default)
- `:Qwerty` - Revert to standard QWERTY keybindings

---

## Resources

- [Colemak Mod-DH Official Site](https://colemakmods.github.io/mod-dh/)

















# Colemak DH Accomodations

## Colemak mnei(hjkl), t(i), <C-n>(f), l(e)
`m` => `h` - Move left
n', 'j', opts)   -- Move down
e', 'k', opts)   -- Move up
i', 'l', opts)   -- Move right

`gm` => `gh` - Move left (with wrap)
`gn` => `gj` - Move down (with wrap)
`ge` => `gk` - Move up (with wrap)
`gi` => `gl` - Move right (with wrap)

`zm` => `zh` - Move screen left
`zn` => `zj` - Move screen down
`ze` => `zk` - Move screen up
`zi` => `zl` - Move screen right
`zM` => `zH` - Move screen all the way left
`zI` => `zL` - Move screen all the way right

`t` => `i` - (t)ype replaces (i)nsert
`T` => `I` - (T)ype at bol replaces (I)nsert

`l` => `e` - (l)ast replaces (e)nd
`h` => `m` - (h)ighlight replaces (m)ark

`<C-w>m` => `<C-w>h` - move to the left window
`<C-w>n` => `<C-w>j` - move to the below window
`<C-w>e` => `<C-w>k` - move to the above window
`<C-w>i` => `<C-w>l` - move to the right window


## Mini.AI
We've had to overwrite some default keymaps...


