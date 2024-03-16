return {
	"nvimtools/none-ls.nvim",
	config = function()
		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
		local null_ls = require("null-ls")
		null_ls.setup({
			sources = {
				-- Groovy
				null_ls.builtins.diagnostics.npm_groovy_lint,
				-- null_ls.builtins.formatting.npm_groovy_lint,
				-- Lua
				null_ls.builtins.formatting.stylua,
				-- JS
				null_ls.builtins.formatting.prettier,
				-- CSS
				null_ls.builtins.diagnostics.stylelint,
				null_ls.builtins.formatting.stylelint,
				-- GO
				null_ls.builtins.diagnostics.staticcheck,
				null_ls.builtins.formatting.golines,
				null_ls.builtins.formatting.gofumpt,
				null_ls.builtins.formatting.goimports_reviser,
				null_ls.builtins.code_actions.gomodifytags,
				-- null_ls.builtins.diagnostics.revive,
			},
			on_attach = function(client, bufnr)
				if client.supports_method("textDocument/formatting") then
					vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = augroup,
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.format({ async = false, timeout_ms = 4000 })
						end,
					})
				end
			end,
		})

		vim.diagnostic.config({ underline = false, severity_sort = true })
		vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
			underline = false,
		})

		vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
	end,
}
