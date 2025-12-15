# Neovim Configuration (`nvim`)

## Overview

This repository contains my personal **Neovim configuration**, originally bootstrapped from
[kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim).

The goals of this setup are:

* Minimal and readable configuration
* Sensible defaults with room to grow
* Fast startup and low dependency overhead
* Practical tooling for development, research, and writing

Although inspired by Kickstart, this configuration has evolved into a more opinionated, workflow-driven setup.

---

## Requirements

### Neovim

This configuration targets **Neovim stable or nightly**.

* Minimum recommended version: **0.9+**
* Nightly builds are supported

---

### Core External Dependencies (Required)

These tools are used directly by Neovim or plugins:

* `git` – plugin management
* `ripgrep (rg)` – project-wide search (used heavily)
* `make` + C compiler (`gcc` / `clang`) – native plugin builds
* `unzip` – plugin installation

---

### Optional but Strongly Recommended

* Clipboard provider:

  * Linux: `xclip` or `xsel`
  * Windows: `win32yank`
* A [Nerd Font](https://www.nerdfonts.com/) (icons & UI polish)

  * If installed, set:

    ```lua
    vim.g.have_nerd_font = true
    ```

---

### Language Toolchains (Optional)

Install only what you actually use:

* `nodejs` / `npm` – JavaScript / TypeScript
* `go` – Golang
* `zig` – Zig toolchain & C compiler alternative which i used to build telescope native fzf
* `python` – scripting & tooling

---

## Installation

### Configuration Paths

| OS                   | Path                     |
| -------------------- | ------------------------ |
| Linux / macOS        | `~/.config/nvim`         |
| Windows (PowerShell) | `$env:LOCALAPPDATA\nvim` |
| Windows (cmd.exe)    | `%LOCALAPPDATA%\nvim`    |

---

### Clone the Configuration

#### Linux / macOS

```sh
git clone https://github.com/lubasinkal/nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
```

#### Windows (PowerShell)

```powershell
git clone https://github.com/lubasinkal/nvim.git "$env:LOCALAPPDATA\nvim"
```

#### Windows (cmd.exe)

```cmd
git clone https://github.com/lubasinkal/nvim.git "%LOCALAPPDATA%\nvim"
```

---

## First Launch

Start Neovim:

```sh
nvim
```

On first launch:

* `lazy.nvim` will automatically install plugins
* Native extensions will compile as needed

Check plugin status anytime with:

```
:Lazy
```

---

## Dependency Installation Recipes

### Windows (Recommended: Scoop)

[Scoop](https://scoop.sh/) provides clean, scriptable installs and works well with Neovim.

#### Install Scoop

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
irm get.scoop.sh | iex
```

#### Add Buckets

```powershell
scoop bucket add extras
scoop bucket add nerd-fonts
```

#### Install Core Dependencies

```powershell
scoop install `
  neovim `
  git `
  ripgrep `
  fd `
  unzip `
  gzip `
  make `
  zig `
  nodejs `
  win32yank `
  fzf `
  lazygit `
  zoxide
```

(Optional) Install a Nerd Font:

```powershell
scoop install CascadiaCode-NF
```

Restart your terminal after installing fonts.

---

### Windows (Alternative: Chocolatey)

```powershell
winget install --accept-source-agreements chocolatey.chocolatey
choco install -y neovim git ripgrep fd unzip gzip make zig nodejs win32yank
```

---

### Linux

#### Ubuntu / Debian (PPA)

```sh
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update
sudo apt install -y \
  neovim \
  git \
  ripgrep \
  fd-find \
  unzip \
  make \
  gcc \
  xclip
```

#### Fedora

```sh
sudo dnf install -y neovim git ripgrep fd-find unzip make gcc
```

#### Arch Linux

```sh
sudo pacman -S --needed neovim git ripgrep fd unzip make gcc
```

---

## Multiple Neovim Configurations

You can keep this configuration alongside others using `NVIM_APPNAME`.

Example:

```sh
alias nvim-custom='NVIM_APPNAME="nvim-custom" nvim'
```

This allows parallel configs without conflicts.

---

## FAQ

### I already have a Neovim config. What should I do?

Back it up before installing:

```sh
mv ~/.config/nvim ~/.config/nvim.backup
mv ~/.local/share/nvim ~/.local/share/nvim.backup
```

Then proceed with installation.

---

### How do I uninstall this configuration?

Follow the official guide:
[https://lazy.folke.io/usage#-uninstalling](https://lazy.folke.io/usage#-uninstalling)

---

### Why not split everything into modules?

This configuration started from Kickstart’s single-file philosophy for clarity and learning.
It is gradually modularized where it improves readability and maintenance.

If you prefer a fully modular baseline, see:
[https://github.com/dam9000/kickstart-modular.nvim](https://github.com/dam9000/kickstart-modular.nvim)

---

## Learning Resources

* 🎥 [The Only Video You Need to Get Started with Neovim](https://youtu.be/m8C0Cq9Uv9o)
* `:help nvim`
* `:help lua-guide`

---

