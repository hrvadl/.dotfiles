return {
	{ "VonHeikemen/lsp-zero.nvim", branch = "v3.x" },
	{ "neovim/nvim-lspconfig" },
	{ "L3MON4D3/LuaSnip" },
	{
		"zbirenbaum/copilot-cmp",
		dependencies = {
			{
				"zbirenbaum/copilot.lua",
				cmd = "Copilot",
				event = "InsertEnter",
				config = function()
					require("copilot").setup({
						suggestion = { enabled = false },
						panel = { enabled = false },
					})
				end,
			},
		},
		config = function()
			require("copilot_cmp").setup()
		end,
	},
	{
		"mason-org/mason.nvim",
		dependencies = {
			"mason-org/mason-lspconfig.nvim",
			"jay-babu/mason-null-ls.nvim",
		},
		config = function()
			local lsp_zero = require("lsp-zero")
			lsp_zero.extend_lspconfig()

			vim.cmd([[autocmd BufRead,BufNewFile Jenkinsfile set filetype=groovy]])
			vim.cmd([[autocmd BufRead,BufNewFile *.tf set filetype=hcl]])

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

			local function custom_rename_handler(err, result, ctx, config)
				if err then
					vim.notify("Rename failed: " .. err.message, vim.log.levels.ERROR)
					return
				end

				local client = vim.lsp.get_client_by_id(ctx.client_id)

				-- Track modified buffers
				local modified_buffers = {}

				-- Get current buffer
				local current_bufnr = vim.api.nvim_get_current_buf()

				-- Handle both types of LSP responses
				if result.documentChanges then
					-- Handle documentChanges (preferred)
					for _, change in ipairs(result.documentChanges) do
						if change.textDocument then
							local uri = change.textDocument.uri
							local bufnr = vim.uri_to_bufnr(uri)
							modified_buffers[bufnr] = true
						end
					end
				elseif result.changes then
					-- Handle changes (older style)
					for uri, _ in pairs(result.changes) do
						local bufnr = vim.uri_to_bufnr(uri)
						modified_buffers[bufnr] = true
					end
				end

				-- Apply the workspace edit
				vim.lsp.util.apply_workspace_edit(result, client.offset_encoding)

				-- Save and close modified buffers, except the current one
				for bufnr, _ in pairs(modified_buffers) do
					if vim.api.nvim_buf_is_loaded(bufnr) and bufnr ~= current_bufnr then
						vim.api.nvim_buf_call(bufnr, function()
							vim.cmd("silent! write") -- Silent write to avoid prompts
							vim.cmd("silent! bdelete") -- Silent delete to avoid prompts
						end)
					elseif bufnr == current_bufnr then
						-- Just save the current buffer without closing it
						vim.api.nvim_buf_call(bufnr, function()
							vim.cmd("silent! write")
						end)
					end
				end

				vim.notify("Rename successful", vim.log.levels.INFO)
			end

			-- Set up the handler
			vim.lsp.handlers["textDocument/rename"] = custom_rename_handler

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
				automatic_enable = false,
				ensure_installed = {
					-- Lua
					"lua_ls",
					-- JS/HTML/CSS
					-- "stylelint_lsp",
					-- GO
					"gopls",
					"clangd",
				},
				handlers = {
					lsp_zero.default_setup,
				},
			})

			local lspconfig = require("lspconfig")

			lspconfig.gopls.setup({
				settings = {
					gopls = {
						gofumpt = true,
						staticcheck = true,
						buildFlags = { "-tags=all" },
					},
				},
			})

			require("mason-null-ls").setup({
				ensure_installed = {
					-- Groovy
					-- Lua
					"formatting.stylua",
					-- SHELL
					-- formatting.shellharden,
					-- JS
					"eslint_d",
					"prettierd",
					-- CSS
					-- "stylelint",
					-- GO
					"golines",
					"gofumpt",
					"goimports-reviser",
					"goimports-reviser",
					"goimports",
					"golangci-lint",
					-- diagnostics.revive,
					-- C
					"clang-format",
					-- PROTO
					"protolint",
				},
				automatic_installation = false,
			})
		end,
	},
}
