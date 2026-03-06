local M = {}
local e = vim.fn.fnameescape

local session_dir = vim.fn.stdpath("data") .. "/sessions/"

if vim.fn.isdirectory(session_dir) == 0 then
	vim.fn.mkdir(session_dir, "p")
end

local function get_session_path()
	local cwd = vim.fn.getcwd()
	local is_git = vim.uv.fs_stat(".git") ~= nil

	local session_name
	if is_git then
		local git_root = vim.fn.trim(vim.fn.system("git rev-parse --show-toplevel"))
		local branch = vim.fn.trim(vim.fn.system("git branch --show-current"))
		session_name = git_root:gsub("[\\/:]+", "_")
		if branch and branch ~= "main" and branch ~= "master" then
			session_name = session_name .. "%%" .. branch:gsub("[\\/:]+", "_")
		end
	else
		session_name = cwd:gsub("[\\/:]+", "_")
	end

	return session_dir .. session_name .. ".vim"
end

function M.save_session()
	local path = get_session_path()
	vim.cmd("mks! " .. e(path))
	vim.notify("Session saved to: " .. path, vim.log.levels.INFO)
end

function M.restore_session()
	local path = get_session_path()
	if vim.fn.filereadable(path) == 1 then
		vim.cmd("source " .. e(path))
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
