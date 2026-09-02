# 🚀 Personal Neovim Configuration

A modern, high-performance Neovim configuration bootstrapped from [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim). Designed for speed, aesthetics, and a seamless developer experience with plugins managed via Neovim 0.12's built-in `vim.pack`.

## ⚡ Features

- **Blazing Fast:** Optimized startup with eager/deferred plugin loading.
- **Modern UI:** Clean statusline, tabline with icons, and floating windows.
- **Git Integration:** Inline blame and hunk management via `gitsigns`.
- **Search & Navigation:** Blazing-fast file/grep via [`fff.nvim`](https://github.com/dmtrKovalenko/fff) (frecency, Rust index) + `mini.pick` + `flash.nvim`.
- **File Management:** `neo-tree` for sidebar exploration and `oil.nvim` for buffer-like FS editing.
- **LSP & Autocomplete:** Full LSP support (Mason-managed) with `blink.cmp` for superior completion.
- **Productivity:** `mini.nvim` modules for surround, pairs, commenting, and more.

## 📋 Requirements

- **Neovim 0.12+** (Recommended for latest features)
- **Git** (For plugin management)
- **Ripgrep** (For fast searching)
- **FD** (For fast file finding)
- **Nerd Font** (Optional, but highly recommended for icons)

### Optional Dependencies
- **Rust toolchain / cargo** (to build `fff` — or auto-downloads prebuilt binary)
- **unzip**, **make**, **gcc/zig** (For compiling treesitter/others)
- **xclip/xsel** (Linux) or **win32yank** (Windows) for system clipboard support.

## 📥 Installation

### 1. Clone the repository

**Linux / macOS**
```sh
git clone https://github.com/lubasinkal/nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
```

**Windows (PowerShell)**
```powershell
git clone https://github.com/lubasinkal/nvim.git "$env:LOCALAPPDATA\nvim"
```

### 2. Launch Neovim
Simply run `nvim`. All plugins will automatically download and install on the first launch.

### 🚀 Quick Setup (Windows/Scoop)
If you use [Scoop](https://scoop.sh/), you can install all dependencies at once:
```powershell
scoop bucket add extras
scoop install neovim git ripgrep fd unzip make zig nodejs win32yank lazygit
```

## ⌨️ Keybindings

This config uses `<Space>` as the **Leader** key.

| Group | Key | Description |
|---|---|---|
| **Explorer** | `<leader>e` | Toggle Neo-tree |
| **Search** | `<leader>sf` | [F]ind Files |
| **Search** | `<leader>sg` | By [G]rep |
| **Sessions** | `<leader>ws` | [S]ave Session |
| **Terminal** | `<leader>tt` | [T]oggle Floating Terminal |
| **UI** | `<leader>ub` | Toggle Inline [B]lame |

> **Pro Tip:** Press `<leader>` and wait for a second; `which-key` will pop up and show you all available mappings!

## 🛠️ Customization

Most custom logic resides in `lua/config/`:
- `options.lua`: Vim settings.
- `keymaps.lua`: Global keybindings.
- `plugins/`: Individual plugin configurations.
- `util/`: Helper scripts for terminal, sessions, and tabs.

## 📚 Resources

- `:help kickstart` - Documentation for the base config.
- `:help lua-guide` - Neovim's official Lua guide.
- [vim.pack](https://neovim.io/doc/user/usr_05.html#vim.pack) - Built-in plugin manager (Neovim 0.12+).

---
*Maintained by [lubasinkal](https://github.com/lubasinkal)*
