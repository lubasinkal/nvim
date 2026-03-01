return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre" },
	dependencies = {
		{ "williamboman/mason.nvim", opts = {} },
		"williamboman/mason-lspconfig.nvim",
		{
			"j-hui/fidget.nvim",
			opts = {
				notification = {
					window = { winblend = 0 },
				},
			},
		},
		"saghen/blink.cmp",
	},
	config = function()
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
			callback = function(event)
				local wk = require("which-key")
				wk.add({
					{ "<leader>c", buffer = event.buf, group = "Code" },
					{
						"<leader>cn",
						vim.lsp.buf.rename,
						buffer = event.buf,
						desc = "Rename",
					},
					{
						"<leader>ca",
						vim.lsp.buf.code_action,
						buffer = event.buf,
						desc = "Code Action",
					},
					{
						"<leader>cr",
						require("telescope.builtin").lsp_references,
						buffer = event.buf,
						desc = "References",
					},
					{
						"<leader>ci",
						require("telescope.builtin").lsp_implementations,
						buffer = event.buf,
						desc = "Implementations",
					},
					{
						"<leader>cd",
						require("telescope.builtin").lsp_definitions,
						buffer = event.buf,
						desc = "Definitions",
					},
					{
						"<leader>cD",
						vim.lsp.buf.declaration,
						buffer = event.buf,
						desc = "Declaration",
					},
					{
						"<leader>ct",
						require("telescope.builtin").lsp_type_definitions,
						buffer = event.buf,
						desc = "Type Definitions",
					},
					{
						"<leader>co",
						require("telescope.builtin").lsp_document_symbols,
						buffer = event.buf,
						desc = "Document Symbols",
					},
					{
						"<leader>cw",
						require("telescope.builtin").lsp_dynamic_workspace_symbols,
						buffer = event.buf,
						desc = "Workspace Symbols",
					},
				})

				local function client_supports_method(client, method, bufnr)
					if vim.fn.has("nvim-0.11") == 1 then
						return client:supports_method(method, bufnr)
					else
						return client:supports_method(method, { bufnr = bufnr })
					end
				end

				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if
					client
					and client_supports_method(
						client,
						vim.lsp.protocol.Methods.textDocument_documentHighlight,
						event.buf
					)
				then
					local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.document_highlight,
					})

					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.clear_references,
					})

					vim.api.nvim_create_autocmd("LspDetach", {
						group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
						callback = function(event2)
							vim.lsp.buf.clear_references()
							vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
						end,
					})
				end
			end,
		})

		vim.diagnostic.config({
			severity_sort = true,
			float = { border = "rounded", source = "if_many" },
			underline = { severity = { min = vim.diagnostic.severity.WARN } },
			signs = vim.g.have_nerd_font and {
				text = {
					[vim.diagnostic.severity.ERROR] = "󰅚 ",
					[vim.diagnostic.severity.WARN] = "󰀪 ",
					[vim.diagnostic.severity.INFO] = "󰋽 ",
					[vim.diagnostic.severity.HINT] = "󰌶 ",
				},
			} or {},
			virtual_text = false,
		})
		-- Diagnonstic floating window on cursorhold
		vim.api.nvim_create_autocmd("CursorHold", {
			callback = function()
				if next(vim.diagnostic.get(0, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 })) then
					vim.diagnostic.open_float(nil, { focusable = false, border = "rounded" })
				end
			end,
		})

		local ensure_installed = { "stylua", "lua_ls" }
		vim.lsp.config("lua_ls", {
			settings = {
				Lua = {
					runtime = {
						-- Tell lua_ls you're using Neovim's LuaJIT
						version = "LuaJIT",
						-- Optional: mimic Neovim's package.path for require("…")
						-- Usually not strictly needed if you set workspace.library correctly
						path = {
							"lua/?.lua",
							"lua/?/init.lua",
						},
					},
					diagnostics = {
						-- Stop "undefined global vim" warnings
						globals = { "vim" },
					},
					workspace = {
						-- Very important: make lua_ls aware of Neovim's runtime files
						library = {
							-- Neovim runtime
							vim.env.VIMRUNTIME,
							"${3rd}/luv/library",
							vim.fn.stdpath("config"),
							"${3rd}/busted/library",
						},
						-- Recommended for performance & to avoid 3rd-party prompts
						checkThirdParty = false,
					},
					-- Optional: disable telemetry
					telemetry = { enable = false },
				},
			},
		})
		require("mason-lspconfig").setup({
			ensure_installed = ensure_installed,
			automatic_enable = true,
		})
	end,
}
