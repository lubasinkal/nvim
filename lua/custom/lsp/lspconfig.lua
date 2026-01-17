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
				local map = function(keys, func, desc, mode)
					mode = mode or "n"
					vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end

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
			underline = { severity = vim.diagnostic.severity.ERROR },
			signs = vim.g.have_nerd_font and {
				text = {
					[vim.diagnostic.severity.ERROR] = "󰅚 ",
					[vim.diagnostic.severity.WARN] = "󰀪 ",
					[vim.diagnostic.severity.INFO] = "󰋽 ",
					[vim.diagnostic.severity.HINT] = "󰌶 ",
				},
			} or {},
			virtual_text = {
				source = "if_many",
				spacing = 2,
				format = function(diagnostic)
					local diagnostic_message = {
						[vim.diagnostic.severity.ERROR] = diagnostic.message,
						[vim.diagnostic.severity.WARN] = diagnostic.message,
						[vim.diagnostic.severity.INFO] = diagnostic.message,
						[vim.diagnostic.severity.HINT] = diagnostic.message,
					}
					return diagnostic_message[diagnostic.severity]
				end,
			},
		})
		local capabilities = require("blink.cmp").get_lsp_capabilities()

		local function prevent_oil_attach(client, bufnr)
			local name = vim.api.nvim_buf_get_name(bufnr)
			if name:match("^oil://") then
				client.stop()
				return true
			end
			return false
		end
		local vue_typescript_plugin = vim.fn.expand(
			vim.fn.stdpath("data") .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"
		)
		local ensure_installed = { "stylua", "biome", "black" }
		require("mason-lspconfig").setup({
			ensure_installed = ensure_installed,
			automatic_enable = true,
		})
		local vue_ls_path = vim.fn.expand("$MASON/packages/vue-language-server/node_modules/@vue/language-server")

		vim.lsp.start(vim.tbl_deep_extend("force", vim.lsp.config.ts_ls, {
			init_options = {
				plugins = {
					{
						name = "@vue/typescript-plugin",
						location = vue_ls_path,
						languages = { "vue" },
					},
				},
			},
			filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
			on_attach = function(client)
				if vim.bo.filetype == "vue" then
					client.server_capabilities.semanticTokensProvider.full = false
				end
			end,
		}))
	end,
}
