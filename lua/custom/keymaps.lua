-- NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " " -- Sets the global leader key to space.
vim.g.maplocalleader = " " -- Sets the local leader key to space.

-- [[ Basic Keymaps ]]
-- Remap ';' to act as ':' for easier command line access in normal mode.
vim.keymap.set("n", ";", ":", { noremap = true, silent = false, desc = "Enter command mode" })

-- Clear highlights on search when pressing <Esc> in normal mode.
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })

-- Diagnostic keymaps (requires Neovim's built-in LSP or a plugin)
local toggle_loclist = function()
	local loclist_winid = vim.fn.getloclist(0, { winid = 0 }).winid
	if loclist_winid ~= 0 then
		vim.cmd.lclose()
	else
		vim.diagnostic.setloclist({ open = true })
	end
end

vim.keymap.set("n", "<leader>q", toggle_loclist, { desc = "Toggle diagnostic [Q]uickfix list" })
vim.keymap.set("n", "[d", function()
	vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Go to previous [d]iagnostic message" })
vim.keymap.set("n", "]d", function()
	vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Go to next [d]iagnostic message" })

-- Exit terminal mode in the builtin terminal.
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- TIP: Disable arrow keys in normal mode
-- Uncomment these lines if you want to enforce using hjkl for navigation.
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split/window navigation easier.
-- Use CTRL+<hjkl> to switch between windows.
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- [[ Productivity Keymaps ]]

-- Reselect last visual selection after exiting visual mode.
vim.keymap.set("n", "gv", "`[v`]", { desc = "Reselect last visual selection" })

-- Moving lines in Normal and Visual modes.
-- Use Alt+j/k to move the current line up/down in normal mode.
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move current line down" })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move current line up" })

-- Use Alt+j/k to move selected lines up/down in visual mode.
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selected line(s) down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selected line(s) up" })

-- Indent/Dedent selected lines in Visual mode.
vim.keymap.set("v", "<", "<gv", { desc = "Dedent selected lines" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent selected lines" })

-- Paste without replacing selected text in Visual mode.
vim.keymap.set("x", "p", '"_dP', { desc = "Paste without replacing selected text" })

-- Faster way to save and quit.
vim.keymap.set("n", "<leader>x", "<cmd>wq<CR>", { desc = "[X] Write and Quit" })

-- [[ Basic Autocommands ]]
-- See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text.
-- Try it with `yap` in normal mode.
-- See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})
-- Quick file creation
vim.keymap.set("n", "<leader>fn", ":enew<CR>", { desc = "New file" })

-- Better window management
vim.keymap.set("n", "<leader>wv", "<C-w>v", { desc = "Split vertically" })
vim.keymap.set("n", "<leader>wh", "<C-w>s", { desc = "Split horizontally" })
vim.keymap.set("n", "<leader>wx", "<C-w>c", { desc = "Close window" })

-- Quick navigation
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })
vim.keymap.set("n", "gk", function()
	local new_config = not vim.diagnostic.config().virtual_lines
	vim.diagnostic.config({ virtual_lines = new_config })
end, { desc = "Toggle diagnostic virtual_lines" })
