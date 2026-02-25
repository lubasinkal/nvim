local M = {}

function M.setup()
	-- Check if mini.icons is available
	local has_mini_icons, icons = pcall(require, "mini.icons")

	-- Create tabline with buffer information
	local function generate_tabline()
		local tabline_elements = {}
		local current_buf = vim.api.nvim_get_current_buf()
		local buffers = vim.api.nvim_list_bufs()

		-- Filter only listed buffers
		local listed_buffers = {}
		for _, buf in ipairs(buffers) do
			if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted then
				table.insert(listed_buffers, buf)
			end
		end

		-- If no buffers, show empty tabline
		if #listed_buffers == 0 then
			return ""
		end

		-- Left truncation marker
		table.insert(tabline_elements, "%<")

		for i, buf in ipairs(listed_buffers) do
			-- Get buffer name
			local buf_name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t")
			if buf_name == "" then
				buf_name = "[No Name]"
			end

			-- Truncate long names
			if #buf_name > 20 then
				buf_name = buf_name:sub(1, 17) .. "..."
			end

			-- Get icon from mini.icons
			local icon = ""
			if has_mini_icons then
				-- mini.icons expects either a category and name, or just a name
				-- Using just the filename is sufficient
				local success, icon_data = pcall(icons.get, buf_name)
				if success and icon_data then
					icon = icon_data .. " "
				else
					-- Try with filetype as category
					local ft = vim.bo[buf].filetype
					if ft and ft ~= "" then
						local ft_success, ft_icon = pcall(icons.get, ft, "file")
						if ft_success and ft_icon then
							icon = ft_icon .. " "
						else
							icon = " "
						end
					else
						icon = " "
					end
				end
			else
				icon = " "
			end

			-- Modified indicator
			local modified = vim.bo[buf].modified and " ●" or ""

			-- Diagnostics (if nvim-lsp is active)
			local diagnostics = ""
			pcall(function()
				if vim.diagnostic then
					local error_count = #vim.diagnostic.get(buf, { severity = vim.diagnostic.severity.ERROR })
					local warn_count = #vim.diagnostic.get(buf, { severity = vim.diagnostic.severity.WARN })

					if error_count > 0 then
						diagnostics = diagnostics .. "  " .. error_count
					end
					if warn_count > 0 then
						diagnostics = diagnostics .. "  " .. warn_count
					end
				end
			end)

			-- Determine highlight based on current buffer
			local hl = (buf == current_buf) and "%#TabLineSel#" or "%#TabLine#"

			-- Build the tab item
			local tab_item = string.format("%s %s%s%s%s ", hl, icon, buf_name, modified, diagnostics)

			-- Add click handler
			tab_item = string.format("%%%d@v:lua.BufSelect@%s%%T", i, tab_item)

			-- Add separator
			if i < #listed_buffers then
				tab_item = tab_item .. "%#TabLineFill#│"
			end

			table.insert(tabline_elements, tab_item)
		end

		-- Right side
		table.insert(tabline_elements, "%=%#TabLineFill#%#TabLine#")

		return table.concat(tabline_elements)
	end

	-- Click handler function
	_G.BufSelect = function(buf_idx, _, _, _)
		local bufs = vim.tbl_filter(function(buf)
			return vim.bo[buf].buflisted
		end, vim.api.nvim_list_bufs())

		local idx = tonumber(buf_idx)
		if idx and idx <= #bufs then
			vim.cmd("buffer " .. bufs[idx])
		end
		return ""
	end

	-- Set tabline
	vim.o.tabline = "%!v:lua.tabline()"
	_G.tabline = generate_tabline

	-- Auto-refresh tabline on events
	local refresh_tabline = function()
		vim.o.tabline = "%!v:lua.tabline()"
	end

	local augroup = vim.api.nvim_create_augroup("NativeTabs", { clear = true })
	vim.api.nvim_create_autocmd({ "BufEnter", "BufLeave", "BufDelete", "BufNew", "BufNewFile", "BufReadPost" }, {
		group = augroup,
		callback = refresh_tabline,
	})
	vim.api.nvim_create_autocmd({ "OptionSet" }, {
		group = augroup,
		pattern = { "modified" },
		callback = refresh_tabline,
	})
	vim.api.nvim_create_autocmd({ "DiagnosticChanged" }, {
		group = augroup,
		callback = refresh_tabline,
	})

	-- Key mappings
	local map = vim.keymap.set

	-- Tab navigation
	map("n", "<Tab>", function()
		local bufs = vim.tbl_filter(function(buf)
			return vim.bo[buf].buflisted
		end, vim.api.nvim_list_bufs())

		local current = vim.api.nvim_get_current_buf()
		for i, buf in ipairs(bufs) do
			if buf == current then
				local next_buf = bufs[i + 1] or bufs[1]
				vim.cmd("buffer " .. next_buf)
				break
			end
		end
	end, { desc = "Next buffer" })

	map("n", "<S-Tab>", function()
		local bufs = vim.tbl_filter(function(buf)
			return vim.bo[buf].buflisted
		end, vim.api.nvim_list_bufs())

		local current = vim.api.nvim_get_current_buf()
		for i, buf in ipairs(bufs) do
			if buf == current then
				local prev_buf = bufs[i - 1] or bufs[#bufs]
				vim.cmd("buffer " .. prev_buf)
				break
			end
		end
	end, { desc = "Previous buffer" })

	-- Buffer management keymaps
	map("n", "<leader>bd", function()
		vim.cmd("bdelete")
	end, { desc = "[B]uffer [D]elete" })

	map("n", "<leader>bn", "<cmd>enew<CR>", { desc = "[B]uffer [N]ew" })
end

-- Run setup automatically when required
M.setup()

return M
