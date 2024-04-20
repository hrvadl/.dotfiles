return {
	{ "VonHeikemen/lsp-zero.nvim", branch = "v3.x" },
	{ "neovim/nvim-lspconfig" },
	{ "L3MON4D3/LuaSnip" },
	{
		"williamboman/mason.nvim",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"jay-babu/mason-null-ls.nvim",
		},
		config = function()
			local lsp_zero = require("lsp-zero")
			lsp_zero.extend_lspconfig()

			vim.cmd([[autocmd BufRead,BufNewFile Jenkinsfile set filetype=groovy]])

			lsp_zero.on_attach(function(client, bufnr)
				lsp_zero.default_keymaps({ buffer = bufnr })

				vim.keymap.set("n", "gd", function()
					vim.lsp.buf.definition()
				end, {})
				vim.keymap.set("n", "gt", function()
					vim.lsp.buf.type_definition()
				end, {})
				vim.keymap.set("n", "gi", function()
					vim.lsp.buf.implementation()
				end, {})
				vim.keymap.set("n", "K", function()
					vim.lsp.buf.hover()
				end, {})
				vim.keymap.set("n", "<leader>ds", function()
					vim.diagnostic.open_float()
				end, {})
				vim.keymap.set("n", "<leader>dj", function()
					vim.diagnostic.goto_next()
				end, {})
				vim.keymap.set("n", "<leader>dl", "<cmd>Telescope diagnostics<cr>", {})
				vim.keymap.set("n", "<leader>dk", function()
					vim.diagnostic.goto_prev()
				end, {})
				vim.keymap.set("n", "<leader>ca", function()
					vim.lsp.buf.code_action()
				end, {})
				vim.keymap.set("n", "<leader>vrr", function()
					vim.lsp.buf.references()
				end, {})
				vim.keymap.set("n", "<leader>r", function()
					vim.lsp.buf.rename()
				end, {})
				vim.keymap.set("i", "<C-lh>", function()
					vim.lsp.buf.signature_help()
				end, {})
			end)

			local signs = {
				Error = "",
				Warn = "",
				Hint = "",
				Information = "",
			}

			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
			end

			require("mason").setup({})

			require("mason-lspconfig").setup({
				automatic_installation = true,
				ensure_installed = {
					-- JS/HTML/CSS
					"stylelint_lsp",
					"tsserver",
					-- GO
					"gopls",
					"golangci_lint_ls",
				},
				handlers = {
					lsp_zero.default_setup,
				},
			})

			require("lspconfig").groovyls.setup({
				cmd = { "java", "-jar", "/Users/vadymhrashchenko/groovy/groovy-language-server-all.jar" },
			})

			require("lspconfig").gopls.setup({
				settings = {
					gopls = {
						gofumpt = true,
					},
				},
			})

			require("mason-null-ls").setup({
				ensure_installed = {
					-- Groovy
					-- "npm-groovy-lint",
					-- Lua
					"formatting.stylua",
					-- SHELL
					-- formatting.shellharden,
					-- JS
					"prettierd",
					-- CSS
					-- "stylelint",
					-- GO
					"staticcheck",
					"golines",
					"gofumpt",
					"goimports-reviser",
					"gci",
					-- diagnostics.revive,
					-- C
					"clang-format",
					"clang-d",
				},
				automatic_installation = false,
			})
		end,
	},
}
