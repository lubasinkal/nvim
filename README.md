# Neovim Configuration

Personal Neovim config bootstrapped from [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim). Fast startup, lazy-loaded plugins via `lazy.nvim`.

## Plugins

Telescope, Treesitter, Neotree, Oil, Gitsigns, Flash, Lazygit, which-key, mini.nvim, nvim-lspconfig, autocompletion, formatting, and more.

## Requirements

**Neovim 0.11+**

```sh
# Core
git ripgrep unzip make gcc/clang

# Optional
xclip/xsel (Linux) or win32yank (Windows)  # clipboard
Nerd Font                                    # set vim.g.have_nerd_font = true
```

## Install

```sh
# Linux/macOS
git clone https://github.com/lubasinkal/nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}/nvim"

# Windows (PowerShell)
git clone https://github.com/lubasinkal/nvim.git "$env:LOCALAPPDATA\nvim"
```

Run `nvim` — plugins install automatically on first launch. Check status with `:Lazy`.

### Quick Deps (Windows/Scoop)

```powershell
scoop bucket add extras nerd-fonts
scoop install neovim git ripgrep fd unzip make zig nodejs win32yank lazygit zoxide
```

## Useful Keymaps

| Key | Action |
|---|---|
| `<leader>lu` | Update plugins |
| `<leader>lh` | Lazy home |
| `<leader>lp` | Lazy profile |

## Tips

- Run alongside another config: `NVIM_APPNAME=nvim-custom nvim`
- Back up existing config before installing
- Uninstall guide: [lazy.nvim uninstall](https://lazy.folke.io/usage#-uninstalling)

## Resources

- [Neovim Getting Started Video](https://youtu.be/m8C0Cq9Uv9o)
- `:help lua-guide`
- `:help nvim-config` (full keymap reference)
