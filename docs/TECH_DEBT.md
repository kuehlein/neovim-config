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
