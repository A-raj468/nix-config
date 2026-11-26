# NixOS Configuration

My personal NixOS configuration for **Windows Subsystem for Linux (WSL)**.

This repository contains my declarative NixOS system configuration, managed using Nix Flakes.

## About

This NixOS environment runs inside WSL and was installed using the official [`nixos.wsl`](https://github.com/nix-community/NixOS-WSL) distribution.

The configuration is tailored for my WSL development environment, with system settings, packages, and other customizations managed declaratively through Nix.

## System

- **OS:** NixOS
- **Environment:** Windows Subsystem for Linux (WSL)
- **Distribution:** Official NixOS-WSL image (`nixos.wsl`)
- **Configuration:** Nix Flakes
- **Hostname:** `nixos`

## Repository Structure

```text
nix-config/
├── LICENSE
├── README.md
├── flake.nix
├── flake.lock
├── nixos
│   └── configuration.nix
├── home
│   ├── maxi.nix
│   └── programs
│       └── ...
└── ...
```

*The structure may evolve as the configuration grows.*

## Usage

All commands below should be run from the root of this repository.

### Apply Configuration

Build and activate the system configuration:

```bash
sudo nixos-rebuild switch --flake .#nixos
```

### Update Flake Inputs

Update dependencies pinned in `flake.lock`:

```bash
nix flake update
```

Apply the updated configuration:

```bash
sudo nixos-rebuild switch --flake .#nixos
```

### Test Configuration

Build and activate the configuration without making it the default boot configuration:

```bash
sudo nixos-rebuild test --flake .#nixos
```

### Check Configuration

Evaluate the flake and check for common issues:

```bash
nix flake check
```

## Notes

- This configuration targets my NixOS WSL environment, not a bare-metal NixOS installation.
- The initial NixOS installation is provided by the official NixOS-WSL distribution.
- System changes are managed declaratively through Nix.
- `flake.lock` is committed to keep dependency versions reproducible.

