-- Terminal configuration
vim.opt.shell = vim.fn.executable('pwsh') == 1 and 'pwsh' or
				vim.fn.executable('powershell') == 1 and 'powershell' or
				vim.fn.executable('bash') == 1 and 'bash' or
				vim.fn.expand('$SHELL')
