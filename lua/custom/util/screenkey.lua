-- Modern Screenkey Implementation
-- Mimics screenkey.nvim architecture with proper separation of concerns

local api = vim.api

---@class ScreenkeyConfig
---@field win_opts table Window options
---@field timeout number Clear timeout in milliseconds
---@field compress_after number Compress keys after N repeats
---@field keys table<string, string> Key translations
---@field show_leader boolean Show leader key
---@field disable table Disable conditions
---@field separator string Separator between keys
local Config = {}

function Config:new()
	local obj = {
		-- Window configuration
		win_opts = {
			relative = "editor",
			style = "minimal",
			border = "rounded",
			focusable = false,
			height = 1,
			width = 30,
			zindex = 50,
			anchor = "SE",
		},
		timeout = 3000,
		compress_after = 3,
		keys = {
			["<TAB>"] = "󰌒",
			["<CR>"] = "󰌑",
			["<ESC>"] = "Esc",
			["<SPACE>"] = "␣",
			["<BS>"] = "󰌥",
			["<DEL>"] = "Del",
			["<LEFT>"] = "←",
			["<RIGHT>"] = "→",
			["<UP>"] = "↑",
			["<DOWN>"] = "↓",
			["<HOME>"] = "Home",
			["<END>"] = "End",
			["<PAGEUP>"] = "PgUp",
			["<PAGEDOWN>"] = "PgDn",
			["CTRL"] = "Ctrl",
			["ALT"] = "Alt",
			["<leader>"] = "<leader>",
		},
		show_leader = true,
		separator = " ",
		disable = {
			filetypes = { "vim-plug", "qf" },
			buftypes = { "nofile", "prompt" },
			modes = {},
		},
	}
	setmetatable(obj, self)
	self.__index = self
	return obj
end

---@class KeyUtils
local KeyUtils = {}

---@param key string
---@return table Transformed key structure
function KeyUtils.transform_input(key)
	-- Use keytrans for proper Vim key translation
	local trans_key = vim.fn.keytrans(key)

	-- Check if this is a special key
	if trans_key:match("^<") then
		-- Handle modifier keys
		local modifier = trans_key:match("^<([CMAD])%-")
		local base_key = trans_key:match("^<.%-(.+)>$") or trans_key:match("^<(.+)>$")

		if base_key then
			if modifier == "C" then
				return {
					key = "Ctrl+" .. base_key,
					is_mapping = false,
					count = 1,
				}
			elseif modifier == "A" or modifier == "M" then
				return {
					key = "Alt+" .. base_key,
					is_mapping = false,
					count = 1,
				}
			end
		end
		return {
			key = trans_key,
			is_mapping = false,
			count = 1,
		}
	end

	return {
		key = trans_key,
		is_mapping = false,
		count = 1,
	}
end

---@param queued_keys table[]
---@param new_key table
---@return table[]
function KeyUtils.append_key(queued_keys, new_key)
	if #queued_keys > 0 and queued_keys[#queued_keys].key == new_key.key then
		-- Increment count for repeated keys
		queued_keys[#queued_keys].count = queued_keys[#queued_keys].count + 1
	else
		table.insert(queued_keys, new_key)
	end
	return queued_keys
end

---@param queued_keys table[]
---@param config ScreenkeyConfig
---@return string
function KeyUtils.to_string(queued_keys, config)
	local result = {}
	for _, qkey in ipairs(queued_keys) do
		if qkey.count >= (config.compress_after or 3) then
			table.insert(result, qkey.key .. "x" .. qkey.count)
		else
			for _ = 1, qkey.count do
				table.insert(result, qkey.key)
			end
		end
	end
	return table.concat(result, config.separator or " ")
end

---@class ScreenkeyUI
local UI = {}

function UI:new()
	local obj = {
		active = false,
		ns_id = vim.api.nvim_create_namespace("screenkey"),
		buf = -1,
		win = -1,
	}
	setmetatable(obj, self)
	self.__index = self
	return obj
end

function UI:is_active()
	return self.active
end

---@param config ScreenkeyConfig
function UI:open_win(config)
	if not vim.api.nvim_buf_is_valid(self.buf) then
		self.buf = api.nvim_create_buf(false, true)
		api.nvim_set_option_value("buftype", "nofile", { buf = self.buf })
		api.nvim_set_option_value("filetype", "screenkey", { buf = self.buf })
	end

	if not vim.api.nvim_win_is_valid(self.win) then
		local win_config = vim.tbl_extend("force", config.win_opts, {
			row = vim.o.lines - vim.o.cmdheight - config.win_opts.height - 1,
			col = vim.o.columns - config.win_opts.width - 1,
		})
		self.win = api.nvim_open_win(self.buf, false, win_config)
		api.nvim_set_option_value("winblend", 20, { win = self.win })
	end

	self.active = true
end

function UI:close_win()
	if vim.api.nvim_win_is_valid(self.win) then
		api.nvim_win_close(self.win, true)
		self.win = -1
	end
	self.active = false
end

---@param text string
function UI:update_text(text)
	if not self.active or not vim.api.nvim_buf_is_valid(self.buf) then
		return
	end

	-- Truncate text if too long
	if #text > 28 then
		text = "..." .. text:sub(-25)
	end

	-- Center the text
	local padding = math.max(0, math.floor((30 - #text) / 2))
	local line = string.rep(" ", padding) .. text

	api.nvim_buf_set_lines(self.buf, 0, -1, false, { line })
end

function UI:clear()
	if vim.api.nvim_buf_is_valid(self.buf) then
		api.nvim_buf_set_lines(self.buf, 0, -1, false, {})
	end
end

---@class Screenkey
local Screenkey = {}

function Screenkey:new(config)
	local obj = {
		enabled = false,
		config = config or Config:new(),
		ui = UI:new(),
		queued_keys = {},
		timer = nil,
		ns_id = vim.api.nvim_create_namespace("screenkey"),
	}
	setmetatable(obj, self)
	self.__index = self
	return obj
end

---@private
function Screenkey:should_disable()
	local buftype = api.nvim_get_option_value("buftype", { buf = 0 })
	if vim.tbl_contains(self.config.disable.buftypes, buftype) then
		return true
	end

	local filetype = api.nvim_get_option_value("filetype", { buf = 0 })
	if vim.tbl_contains(self.config.disable.filetypes, filetype) then
		return true
	end

	return false
end

---@private
function Screenkey:reset_timer()
	if self.timer then
		self.timer:stop()
		self.timer:close()
		self.timer = nil
	end

	if self.config.timeout > 0 then
		self.timer = vim.uv.new_timer()
		self.timer:start(
			self.config.timeout,
			0,
			vim.schedule_wrap(function()
				self:clear_keys()
			end)
		)
	end
end

---@private
function Screenkey:on_key_callback(char)
	if not self.enabled then
		return
	end

	if not char or char == "" or self:should_disable() then
		return
	end

	local key = KeyUtils.transform_input(char)
	self.queued_keys = KeyUtils.append_key(self.queued_keys, key)

	-- Limit history to prevent excessive memory use
	if #self.queued_keys > 20 then
		table.remove(self.queued_keys, 1)
	end

	local text = KeyUtils.to_string(self.queued_keys, self.config)
	self.ui:update_text(text)

	self:reset_timer()
end

function Screenkey:clear_keys()
	self.queued_keys = {}
	self.ui:clear()
	if self.timer then
		self.timer:stop()
		self.timer:close()
		self.timer = nil
	end
end

function Screenkey:toggle()
	self.enabled = not self.enabled

	if self.enabled then
		self.ui:open_win(self.config)
		-- Register key listener
		vim.on_key(function(char)
			self:on_key_callback(char)
		end, self.ns_id)
		vim.notify("Screenkey enabled", vim.log.levels.INFO)
	else
		self:clear_keys()
		self.ui:close_win()
		vim.notify("Screenkey disabled", vim.log.levels.INFO)
	end
end

function Screenkey:redraw()
	if self.enabled then
		self.ui:open_win(self.config)
		local text = KeyUtils.to_string(self.queued_keys, self.config)
		self.ui:update_text(text)
	end
end

-- Singleton instance
local screenkey = Screenkey:new()

-- Setup commands
api.nvim_create_user_command("Screenkey", function()
	screenkey:toggle()
end, {
	desc = "Toggle Screenkey display",
})

api.nvim_create_user_command("ScreenkeyRedraw", function()
	screenkey:redraw()
end, {
	desc = "Redraw Screenkey window",
})

-- Setup keymaps
vim.keymap.set("n", "<leader>tsk", function()
	screenkey:toggle()
end, {
	noremap = true,
	silent = true,
	desc = "[T]oggle [S]creen[K]ey",
})

-- Handle window resize
api.nvim_create_autocmd("VimResized", {
	callback = function()
		screenkey:redraw()
	end,
})

return {
	setup = function(opts)
		if opts then
			screenkey.config = vim.tbl_extend("force", screenkey.config, opts)
		end
	end,
	toggle = function()
		screenkey:toggle()
	end,
	redraw = function()
		screenkey:redraw()
	end,
}
