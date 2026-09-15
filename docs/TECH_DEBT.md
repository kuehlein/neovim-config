# Technical Debt

This document tracks technical debt, workarounds, and temporary solutions in this Neovim configuration.

---

## Package Management

### Claude Code CLI (Third-party Flake)

**Status:** Active workaround
**Location:** `flake.nix:16, 52`

**Problem:**
The official nixpkgs repository often lags behind Claude Code releases. Version 2.0.11 in nixpkgs had a critical bug (`Cannot read properties of null (reading 'alwaysThinking')`) that prevented normal operation.

**Current Solution:**
Using the third-party flake [`sadjow/claude-code-nix`](https://github.com/sadjow/claude-code-nix) which auto-updates hourly with new Claude Code releases from Anthropic.

```nix
# flake.nix inputs
claude-code-nix.url = "github:sadjow/claude-code-nix";

# Usage in tools
tools = [
  claude-code-nix.packages.${system}.default
];
```

**Update Process:**
```bash
# Get latest Claude Code version
nix flake update claude-code-nix
```

**Future Resolution:**
Once nixpkgs reliably keeps Claude Code up-to-date (or the auto-update flake becomes unmaintained), consider switching back to the official nixpkgs package.

**Risks:**
- Dependency on third-party flake maintenance
- Potential breaking changes from rapid updates

---

### Harpoon 2 (Custom Build)

**Status:** Active workaround
**Location:** `plugins.nix:5-16`

**Problem:**
The official nixpkgs `harpoon2` plugin is outdated. The maintainer renamed `harpoon2` to `harpoon-2` but nixpkgs hasn't merged this change yet.

**Current Solution:**
Custom build using `buildVimPlugin` that fetches directly from the GitHub repository:

```nix
harpoon-2 = vimUtils.buildVimPlugin {
  doCheck = false;
  pname = "harpoon2";
  src = pkgs.fetchFromGitHub {
    hash = "sha256-qQSPVMdldksNZDPZvnTiXxty+GSUqMGz8nYEFDRezrQ=";
    owner = "ThePrimeagen";
    repo = "harpoon";
    rev = "87b1a3506211538f460786c23f98ec63ad9af4e5";
  };
  version = "unstable";
};
```

**Update Process:**
1. Check for new commits at https://github.com/ThePrimeagen/harpoon
2. Update `rev` to the desired commit hash
3. Run `nix build .#` to get the correct hash error
4. Update `hash` with the correct value from the error

**Future Resolution:**
Once `harpoon-2` is available in nixpkgs, replace the custom build:

```nix
# Replace harpoon-2 custom build with:
harpoon = with vimPlugins; [
  harpoon-2  # From nixpkgs
  plenary-nvim
];
```

**References:**
- Comment in code: "use this until `harpoon-2` is merged to `master`"

---

## Configuration TODOs

### Project Maturity

**Status:** Planned improvements
**Priority:** Low

- Clean up git history
- Version 1.0.0 release
- Protected branch + GitHub Actions CI
- Changelog and proper versioning
- Linting requirements via CI

### Feature Improvements

**Status:** Enhancement requests
**Priority:** Medium-Low

- **Claude plugin layout broken**
```
Because we are resizing claude's split with `wincmd =`, the text in the terminal (where claude prompts us with "yes", "no", etc.) the text is can be quite messed up at times. So far, it seems like it is not worth the effort to fix this issue. In the future this problem may be resolved by changes in the plugin upstream.
```
- **Pressing "J" in rapid succession triggers error**
```
Error in CursorMoved Autocommands for "<buffer=3>":                                                                                                                                                             
Lua callback: ...wrapped-0.12.2/share/nvim/runtime/lua/vim/diagnostic.lua:2160: Invalid 'line': out of range                                                                                                    
stack traceback:                                                                                                                                                                                                
        [C]: in function 'nvim_buf_set_extmark'                                                                                                                                                                 
        ...wrapped-0.12.2/share/nvim/runtime/lua/vim/diagnostic.lua:2160: in function 'render_virtual_lines'                                                                                                    
        ...wrapped-0.12.2/share/nvim/runtime/lua/vim/diagnostic.lua:2213: in function <...wrapped-0.12.2/share/nvim/runtime/lua/vim/diagnostic.lua:2212>
```
- **Claude opens many diff windows when running parallel agents**
```
When Claude runs multiple sub-agents (or issues parallel tool calls), each proposed
change opens its own `openDiff` split at the same time, so several diff window pairs
stack up and it becomes hard to see what is going on.

The plugin (claudecode.nvim) processes diffs one-at-a-time and blocking for normal
single-agent use, so this only happens with concurrent agents. There is currently no
config option to queue, cap, or show only the "current" diff, and the plugin emits no
diff-open/close events to hook, so a custom serialization layer would be fragile.

Tracked upstream: coder/claudecode.nvim issues #205 (stale diffs accumulate) and #155
(spawns many split windows). Mitigation for now: avoid parallel agents when you want to
watch diffs land, or close leftovers with `<leader>ad` / `:q`.
```

### LSP `client.notify` Deprecation Warning

**Status:** Cosmetic - upstream
**Priority:** Low

**Problem:**
```
client.notify is deprecated. Run ":checkhealth vim.deprecated" for more information
```
Neovim 0.11+ deprecated the function-style `client.notify(...)` in favor of the method
form `client:notify(...)`. The warning is emitted by third-party plugins, not this
config - `client.notify(` still appears in `lazydev.nvim` (`lua/lazydev/lsp.lua`),
`oil.nvim` (`lua/oil/lsp/workspace.lua`), and `nvim-lspconfig`. lazydev is the most
frequent trigger since it pushes updated `lua_ls` settings on every attach.

**Current Solution:**
None needed in this config - it is a harmless deprecation notice.

**Future Resolution:**
Resolves automatically as those plugins migrate to the method form. Picked up via the
periodic `nix flake update nixpkgs` broad plugin refresh.

---

### Keyboard Protocol Limitations

**Status:** Known limitation - workaround applied
**Priority:** Low
**Location:** `lua/utils/layout.lua:27-28`

**Problem:**
Cannot distinguish `<Tab>` from `<C-i>` or `<CR>` (Enter) from `<C-m>` in Neovim keymaps, even with Kitty keyboard protocol enabled. While Kitty successfully sends distinct keycodes and Neovim receives them correctly, the `vim.keymap.set()` API doesn't support protocol-aware mapping strings.

**Technical Details:**
- Kitty keyboard protocol (CSI u) sends distinct codes for these legacy-ambiguous keys:
  - Tab = `CSI 9 u`, Ctrl-I = `CSI 105 ; 5 u`
  - Enter = `CSI 13 u`, Ctrl-M = `CSI 109 ; 5 u`
- Neovim receives these correctly (verified with `nvim --clean` testing)
- But `vim.keymap.set()` with `'<C-i>'` or `'<C-m>'` uses legacy keycodes that capture both keys
- This is a known Neovim limitation tracked in [issue #5916](https://github.com/neovim/neovim/issues/5916) since 2017

**Current Workaround:**
Originally used `<C-i>` (conflicts with Tab) and `<C-m>` (conflicts with Enter) for Harpoon next/prev navigation in Colemak layout. Keeping current mappings despite conflicts - user accepts the limitation.

**Future Resolution:**
- Wait for Neovim to add protocol-aware mapping API
- Monitor [issue #5916](https://github.com/neovim/neovim/issues/5916) for updates
- Alternative: Could map raw escape sequences, but fragile and not recommended

---

## Maintenance Notes

**When updating this document:**
1. Add new technical debt items as they're discovered
2. Remove items that have been resolved
3. Update status/priority as situations change
4. Keep "Future Resolution" sections current with the latest approach

**When resolving technical debt:**
1. Update this document to reflect the resolution
2. Consider if similar patterns exist elsewhere in the codebase
3. Document lessons learned for future reference
