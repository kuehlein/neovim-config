# Development

Notes on local development for this repo.

---

## Prerequisites

- [Nix package manager](https://nixos.org/download.html) installed
- Flakes enabled (add `experimental-features = nix-command flakes` to `~/.config/nix/nix.conf`)

**Note:** This works on any system with Nix installed (NixOS, Linux, macOS, WSL).

## Local Development

Run the repo locally:
```bash
  nix run .#
```

Nix flakes only include files tracked by Git. Before running the above command, make sure that all files are tracked by Git.

Alternatively, use the impure flag:
```bash
  nix run --impure .#
```

This will include files untracked by Git.
