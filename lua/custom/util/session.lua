local M = {}

-- Define the central storage path
local session_dir = vim.fn.stdpath("data") .. "/sessions/"

-- Ensure the directory exists
if vim.fn.isdirectory(session_dir) == 0 then
	vim.fn.mkdir(session_dir, "p")
end

local function get_session_path()
	local cwd = vim.fn.getcwd()
	-- Check if we are in a git repo
	local is_git = vim.fn.system("git rev-parse --is-inside-work-tree 2> nil"):find("true")

	local session_name
	if is_git then
		local git_root = vim.fn.trim(vim.fn.system("git rev-parse --show-toplevel"))
		local branch = vim.fn.trim(vim.fn.system("git branch --show-current"))
		-- Format: C_Users_Name_Project_main.vim
		session_name = (git_root .. "_" .. branch):gsub("[\\/:]+", "_")
	else
		-- Format: C_Users_Name_Folder.vim
		session_name = cwd:gsub("[\\/:]+", "_")
	end

	return session_dir .. session_name .. ".vim"
end

function M.save_session()
	local path = get_session_path()
	vim.cmd("mksession! " .. vim.fn.fnameescape(path))
	vim.notify("Session saved to: " .. path, vim.log.levels.INFO)
end

function M.restore_session()
	local path = get_session_path()
	if vim.fn.filereadable(path) == 1 then
		vim.cmd("source " .. vim.fn.fnameescape(path))
		vim.notify("Session restored", vim.log.levels.INFO)
	else
		vim.notify("No session found for this branch/folder", vim.log.levels.WARN)
	end
end

-- Commands & Keymaps
vim.api.nvim_create_user_command("SessionSave", M.save_session, {})
vim.api.nvim_create_user_command("SessionRestore", M.restore_session, {})

vim.keymap.set("n", "<leader>wr", M.restore_session, { desc = "Restore project session" })
vim.keymap.set("n", "<leader>ws", M.save_session, { desc = "Save project session" })

vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals" }

return M
