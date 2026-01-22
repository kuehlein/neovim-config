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

## Updating Plugins

Updating the plugins used in this configuration is as simple as running:
```bash
  nix flake update
```

For local development, you should be able to run everything normally, but to finalize the updates, commit any changes to git, push the repo, then update the inputs of your system as you normally would.

**NOTE**: Breaking changes will obviously break the configuration after updating.


