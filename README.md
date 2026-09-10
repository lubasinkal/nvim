# Personal Neovim Configuration

A modern, high performance Neovim configuration bootstrapped from [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim). Built for speed, clean visuals and a smooth editing experience, with plugins managed through Neovim 0.12 built in `vim.pack`.

## Features

- **Fast startup:** lean plugin set with lazy loading where it counts.
- **Modern UI:** cyberdream colourscheme with transparency, clean statusline, tabline with icons and floating windows.
- **Git integration:** inline blame and hunk actions via `gitsigns`.
- **Search and navigation:** fuzzy finding with `fzf-lua`, fast jumps with `flash.nvim`.
- **File management:** `neo-tree` for sidebar browsing, `oil.nvim` for editing the filesystem like a buffer.
- **LSP and completion:** full LSP support (Mason managed) with `blink.cmp`.
- **Syntax:** `nvim-treesitter` (0.12 rewrite branch) plus rendered Markdown via `render-markdown.nvim`.
- **Productivity:** `mini.nvim` modules for surround, pairs, commenting, sessions and more.

## Requirements

- **Neovim 0.12+**
- **Git**
- **Ripgrep** for fast searching
- **FD** for fast file finding
- **A Nerd Font** (optional, recommended for icons)

Optional extras:

- **unzip**, **make**, **gcc or zig** to build some `fzf-lua` extensions
- **xclip or xsel** (Linux), **win32yank** (Windows) for system clipboard support

## Installation

### 1. Clone the repository

Linux / macOS:

```sh
git clone https://github.com/Lubasinkal/nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
```

Windows (PowerShell):

```powershell
git clone https://github.com/Lubasinkal/nvim.git "$env:LOCALAPPDATA\nvim"
```

### 2. Launch Neovim

Run `nvim`. Plugins download and install automatically on first launch.

### Quick setup (Windows / Scoop)

With [Scoop](https://scoop.sh/) installed, grab every dependency at once:

```powershell
scoop bucket add extras
scoop install neovim git ripgrep fd unzip make zig nodejs win32yank lazygit
```

## Keybindings

Leader is `<Space>`. Press it and pause briefly and `which-key` shows every available mapping.

| Group | Key | Action |
|---|---|---|
| Explorer | `<leader>e` | Toggle Neo-tree |
| Search | `<leader>sf` | Find files |
| Search | `<leader>sg` | Live grep |
| Search | `<leader>sw` | Grep word under cursor |
| Buffers | `<leader>bb` | Buffer list |
| Sessions | `<leader>ws` | Save session |
| Git | `<leader>tb` | Toggle inline blame |
| Terminal | `<Esc><Esc>` | Exit terminal mode |

## Customisation

Most custom logic lives in `lua/config/`:

- `options.lua`: editor settings
- `keymaps.lua`: global keybindings
- `lsp.lua`: language servers and completion
- `plugins.lua`: plugin list and setup
- `autocmd.lua`: autocommands
- `util.lua`: helpers (floating terminal, sessions, tabs)

## Resources

- `:help kickstart`: docs for the base config
- `:help lua-guide`: Neovim official Lua guide
- [vim.pack](https://neovim.io/doc/user/usr_05.html#vim.pack): built in plugin manager (Neovim 0.12+)

---

*Maintained by [Lubasinkal](https://github.com/Lubasinkal)*
