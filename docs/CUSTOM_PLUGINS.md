# Custom Plugins

This document describes the plugins made specifically for this configuration.

## Custom Plugins - Index

**Quick Navigation:**
- [Marks](#marks) - Increase usability of marks
- [Terminal](#terminal) - Convenient shortcut for terminal
- [Notepad](#notepad) - Convenient shortcut for notepad

---

## Marks

Displays buffer-local marks in the sign column. Also, adds the ability to toggle marks on and off with the same motion.

**`h + <char>`** - Toggle mark in local buffer (a-z marks).
  - Default `m` command overwritten due to Colemak DH navigation.
  - Enhanced with toggle functionality: press again on same line to remove mark.
  - For global marks across files, use [Harpoon](#harpoon).

---

## Terminal

Opens a persistent, floating terminal. Good for running a process in the background.

- `<leader>t` - Toggle open terminal.
- `<Esc>` - Close terminal (when it is open).

---

## Notepad

Opens a persistent, floating terminal. Good for running a process in the background.

- `<leader>n` - Toggle open notepad.
- `<Esc>` - Close notepad (when it is open and in normal mode).
  - When in insert mode, `<Esc>` will toggle to normal mode.
- `<C-s>` - Open a dialogue to save the note to the current workspace.
  - The dialogue allows the user to type the name and file extension of the new file.
  - `<Enter>` - Saves the new file.
  - `<Esc>` / `q` - Exits the save dialogue.
