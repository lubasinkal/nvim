# nvim

## Overview

This is my custom Neovim configuration based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim). It provides:

- A minimal, well-documented starting point.
- A single-file configuration approach.
- Easy customization for personal workflows.

## Installation

### Install Neovim

This configuration targets the latest **stable** and **nightly** versions of Neovim.  
Ensure that you have the latest version installed.

### External Requirements:
- Basic utilities: `git`, `make`, `unzip`, and a C compiler (`gcc`).
- [ripgrep](https://github.com/BurntSushi/ripgrep#installation)
- Clipboard tool (`xclip`, `xsel`, `win32yank`, or equivalent for your OS).
- A [Nerd Font](https://www.nerdfonts.com/) (optional, enhances icons).
  - If installed, set `vim.g.have_nerd_font` to `true` in `init.lua`.
- **Language Setup** (Optional, based on your workflow):
  - `npm` (for TypeScript development)
  - `go` (for Golang development)
  - etc.

> **Note:** [Backup](#faq) your previous Neovim configuration before proceeding.

### Configuration Paths

Neovim's configurations are stored at different locations depending on the OS:

| OS | Configuration Path |
| :- | :---------------- |
| **Linux, macOS** | `$XDG_CONFIG_HOME/nvim`, `~/.config/nvim` |
| **Windows (cmd)** | `%localappdata%\nvim\` |
| **Windows (PowerShell)** | `$env:LOCALAPPDATA\nvim\` |

### Clone and Install

#### Linux/macOS

```sh
git clone https://github.com/lubasinkal/nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
```

#### Windows (cmd.exe)

```sh
git clone https://github.com/lubasinkal/nvim.git "%localappdata%\nvim"
```

#### Windows (PowerShell)

```sh
git clone https://github.com/lubasinkal/nvim.git "${env:LOCALAPPDATA}\nvim"
```

---

### Post-Installation

Launch Neovim:

```sh
nvim
```

On the first launch, `lazy.nvim` will install all required plugins.  
Use `:Lazy` to check the current plugin status (press `q` to exit).

### Documentation

Check `init.lua` inside your configuration folder for details on customization and additional plugins.  

> **Tip:** Read the documentation for each plugin in their respective repositories.

---

## Getting Started

[📺 The Only Video You Need to Get Started with Neovim](https://youtu.be/m8C0Cq9Uv9o)

---

## FAQ

### What should I do if I already have a Neovim configuration?
1. **Backup your existing configuration** before installing:
   ```sh
   mv ~/.config/nvim ~/.config/nvim.backup
   mv ~/.local/share/nvim ~/.local/share/nvim.backup
   ```
2. Then, proceed with the installation.

### Can I keep my existing configuration while using this one?
Yes! You can use the `NVIM_APPNAME` environment variable:

```sh
alias nvim-kickstart='NVIM_APPNAME="nvim-kickstart" nvim'
```

This allows you to maintain multiple Neovim setups.

### How do I uninstall this configuration?
See [lazy.nvim uninstall guide](https://lazy.folke.io/usage#-uninstalling).

### Why is this configuration a single file?
Kickstart.nvim is designed as an educational tool, keeping everything in a single `init.lua` for simplicity.  
If you prefer a modular approach, consider [kickstart-modular.nvim](https://github.com/dam9000/kickstart-modular.nvim).

---

## Install Recipes

### Windows

#### Using Microsoft C++ Build Tools and CMake

Neovim may require additional build tools for certain plugins like `telescope-fzf-native`.  
Ensure you have CMake and Microsoft C++ Build Tools installed.

```lua
{'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
```

#### Using GCC/Make via Chocolatey

1. Install [Chocolatey](https://chocolatey.org/install):

   ```sh
   winget install --accept-source-agreements chocolatey.chocolatey
   ```

2. Install dependencies:

   ```sh
   choco install -y neovim git ripgrep wget fd unzip gzip fzf lazygit zoxide make zig nodejs
   ```

#### Windows Subsystem for Linux (WSL)

```sh
wsl --install
wsl
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update
sudo apt install make gcc ripgrep unzip git xclip neovim
```

---

### Linux

#### Ubuntu

```sh
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update
sudo apt install make gcc ripgrep unzip git xclip neovim
```

#### Debian

```sh
sudo apt update
sudo apt install make gcc ripgrep unzip git xclip curl

curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim-linux64
sudo mkdir -p /opt/nvim-linux64
sudo chmod a+rX /opt/nvim-linux64
sudo tar -C /opt -xzf nvim-linux64.tar.gz

sudo ln -sf /opt/nvim-linux64/bin/nvim /usr/local/bin/
```

#### Fedora

```sh
sudo dnf install -y gcc make git ripgrep fd-find unzip neovim
```

#### Arch

```sh
sudo pacman -S --noconfirm --needed gcc make git ripgrep fd unzip neovim
```

