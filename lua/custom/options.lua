-- Global settings
vim.g.have_nerd_font = true -- Set to true if you have a Nerd Font installed for icon support.

-- General UI settings
vim.opt.cmdheight = 0 -- Sets the height of the command line to 1.
vim.opt.termguicolors = true -- Enables true colors in the terminal for better highlighting.
vim.opt.background = 'dark' -- Assumes a dark background for color schemes.
vim.opt.signcolumn = 'yes' -- Always show the sign column (for LSP, Git signs, etc.).
vim.opt.laststatus = 2 -- Always show the status line.
vim.opt.showtabline = 2 -- Always show the tab line, even with one tab open.
vim.opt.number = true -- Shows absolute line numbers.
vim.opt.relativenumber = true -- Shows relative line numbers, useful for quick jumps.
vim.opt.numberwidth = 4 -- Sets the width of the line number column.
vim.opt.cursorline = false -- Highlights the current line.
vim.opt.scrolloff = 12 -- Minimal number of screen lines to keep above and below the cursor.
vim.opt.sidescrolloff = 8 -- Minimal number of screen columns either side of cursor if wrapping is off.
vim.opt.wrap = true -- Disables line wrapping; lines will extend horizontally.
vim.opt.mouse = 'a' -- Enables mouse support in all modes.
vim.opt.fillchars = { eob = ' ' } -- Removes the '~' at the end of buffer, making it blank.
vim.opt.hidden = true -- Allows background buffers to be modified even if they are no longer in a window.
vim.opt.confirm = true -- Prompts for confirmation before unsaved changes are lost.
vim.opt.inccommand = 'split' -- Shows live preview of commands like :substitute in a split window.
-- vim.opt.colorcolumn = '100' -- Displays a vertical column at column 100 to indicate line length.

-- Transparency settings
vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' }) -- Sets background of normal mode to transparent.
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' }) -- Sets background of floating windows to transparent.
vim.opt.pumblend = 10 -- Makes the popup menu slightly transparent.
vim.opt.winblend = 10 -- Makes floating windows slightly transparent.

-- Indentation and formatting
vim.opt.autoindent = true -- Copies indentation from the previous line when starting a new one.
vim.opt.smartindent = true -- Smarter automatic indentation.
vim.opt.tabstop = 4 -- Sets the width of a tab character to 4 spaces.
vim.opt.shiftwidth = 4 -- Sets the number of spaces for each indentation level.
vim.opt.softtabstop = 4 -- Number of spaces that a tab counts for while performing editing operations.
vim.opt.expandtab = true -- Converts tabs to spaces when inserting.
vim.opt.breakindent = true -- Maintains indentation when lines wrap.
vim.opt.formatoptions:remove { 'c', 'r', 'o' } -- Prevents automatic comment insertion.

-- Search settings
vim.opt.hlsearch = true -- Highlights all search matches.
vim.opt.incsearch = true -- Highlights matches as you type.
vim.opt.ignorecase = true -- Ignores case in search patterns.
vim.opt.smartcase = true -- Uses case-sensitive search only if the pattern contains uppercase letters.
vim.opt.whichwrap = 'bs<>[]hl' -- Allows cursor to wrap to next/previous line using specified keys.
vim.opt.iskeyword:append '-' -- Includes hyphenated words as part of a keyword.

-- Splits and buffers
vim.opt.splitright = true -- Forces vertical splits to open to the right.
vim.opt.splitbelow = true -- Forces horizontal splits to open below.

-- Swap, backup, and undo files
vim.opt.swapfile = false -- Disables creation of swap files.
vim.opt.backup = false -- Disables creation of backup files.
vim.opt.writebackup = false -- Disables write backup files.
vim.opt.undofile = true -- Enables persistent undo history.

-- Create undo directory if it doesn't exist
local undodir = vim.fn.stdpath 'data' .. '/undodir'
if vim.fn.isdirectory(undodir) == 0 then
  vim.fn.mkdir(undodir, 'p')
end
vim.opt.undodir = undodir

-- Completion and popup menu
vim.opt.completeopt = 'menuone,noselect' -- Sets options for completion popups.
vim.opt.pumheight = 10 -- Sets the maximum height of the completion popup menu.
vim.opt.shortmess:append 'c' -- Suppresses "completion" messages.

-- Conceal and appearance
vim.opt.conceallevel = 0 -- Shows concealed text in its entirety (e.g., markdown links).
vim.opt.concealcursor = 'nc' -- Conceals text only when the cursor is not on the line.

-- File encoding and clipboard
vim.opt.fileencoding = 'utf-8' -- Sets the default file encoding to UTF-8.
vim.opt.encoding = 'utf-8' -- Sets the internal and script encoding to UTF-8.
vim.opt.clipboard = 'unnamedplus' -- Syncs clipboard with the system clipboard.

-- Performance and update times
vim.opt.updatetime = 250 -- Sets the time (in ms) before `CursorHold` and `CursorHoldI` events are triggered.
vim.opt.timeoutlen = 300 -- Sets the time (in ms) to wait for a mapped key sequence to complete.

-- Invisible characters
vim.opt.list = true -- Shows invisible characters.
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' } -- Customizes how invisible characters are displayed.

-- Folding
vim.opt.foldmethod = 'syntax' -- Sets folding method to syntax-based.
vim.opt.foldlevelstart = 99 -- Opens all folds by default when a buffer is loaded.

-- Terminal configuration
vim.opt.shell = vim.fn.executable 'pwsh' == 1 and 'pwsh'
  or vim.fn.executable 'powershell' == 1 and 'powershell'
  or vim.fn.executable 'bash' == 1 and 'bash'
  or vim.fn.expand '$SHELL'
